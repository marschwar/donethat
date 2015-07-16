require 'test_helper'

class Api::NotesControllerTest < ActionController::TestCase

  setup do
    @user = create [:user, :twuser].sample
    @trip = create :trip, user: @user
    create :trip # someone elses trip

    @request.headers["Content-Type"] = 'application/json'
  end

  context 'a user' do
    setup do
      authenticate_user
    end

    should "create a new note" do
      assert_difference('@trip.notes.count') do
        post_json hash_from_note(build :note)
      end
      assert_response :created
    end

    should "create a new note with location" do
      note = build :note, :with_location
      assert_difference('@trip.notes.count') do
        post_json hash_from_note(note)
      end
      assert_response :created

      persisted_note = Note.find_by(uid: note.uid)
      assert_equal @trip, persisted_note.trip
      assert_equal note.longitude, persisted_note.longitude
      assert_equal note.latitude, persisted_note.latitude
      assert_equal note.note_timestamp, persisted_note.note_timestamp
    end

    should "update a note" do
      existing_note = create :note, trip: @trip
      note = build :note, :with_location

      assert_no_difference('@trip.notes.count') do
        put_json hash_from_note(note), existing_note
      end
      assert_response :accepted

      existing_note.reload
      assert_equal @trip, existing_note.trip
      assert_equal note.longitude, existing_note.longitude
      assert_equal note.latitude, existing_note.latitude
      assert_equal note.note_timestamp, existing_note.note_timestamp
    end
  end

private

  def post_json(hash, trip = @trip)
    @request.env['RAW_POST_DATA'] = hash.to_json
    post :create, trip_uid: trip.uid
  end

  def put_json(hash, note)
    @request.env['RAW_POST_DATA'] = hash.to_json
    put :update, trip_uid: note.trip.uid, uid: note.uid
  end

  def hash_from_note(note)
    result = {
      uid: note.uid,
      title: note.title,
      content: note.content,
      note_date: note.note_datetime
    }
    if note.longitude && note.latitude
      result[:location] = { lon: note.longitude, lat: note.latitude }
    end
    result
  end
end
