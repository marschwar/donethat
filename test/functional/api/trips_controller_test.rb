require 'test_helper'

class Api::TripsControllerTest < ActionController::TestCase

  setup do
    @user = create :twuser
    @trip = create :trip, user: @user
    create :trip # someone elses trip

    @request.headers["Content-Type"] = 'application/json'
  end

  context 'an unauthorized user' do
    should "be rejected" do
      get :index
      assert_response :unauthorized
    end
  end

  context 'a user' do
    setup do
      authenticate_user
    end

    should "retrieve its trips" do
      get :index, format: :json
      assert_response :success
      assert_equal 1, json_response.count
    end

    should "retrieve a trip" do
      get :show, uid: @trip.uid, format: :json
      assert_response :success
      assert_equal @trip.title, json_response[:title]
    end

    should "fail to retrieve with invalid uid" do
      get :show, uid: 'unknown-uid'
      assert_response :not_found
    end

    should "create a new trip" do
      a_trip = build :trip
      assert_difference('Trip.count') do
        post :create, { uid: a_trip.uid, title: a_trip.title, content: a_trip.content }.to_json, format: :json
      end
      assert_response :created
      assert_equal "/api/trips/#{a_trip.uid}", @response.headers['Location']
    end

    should "fail if data is incomplete" do
      a_trip = build :trip
      assert_no_difference('Trip.count') do
        post :create, { uid: a_trip.uid, content: a_trip.content }.to_json
      end
      assert_response :bad_request
    end

    should "fail if uid exists" do
      a_trip = build :trip
      assert_no_difference('Trip.count') do
        post :create, { uid: @trip.uid, title: a_trip.title, content: a_trip.content }.to_json
      end
      assert_response :bad_request
    end

    should "update an existing trip" do
      a_trip = build :trip
      assert_no_difference('Trip.count') do
        @request.env['RAW_POST_DATA'] = { title: a_trip.title, content: a_trip.content }.to_json
        put :update, uid: @trip.uid
      end
      assert_response :no_content
    end

    should "not be able to remove title" do
      a_trip = build :trip
      @request.env['RAW_POST_DATA'] = { title: '', content: a_trip.content }.to_json
      put :update, uid: @trip.uid
      assert_response :bad_request
    end

    should "not be able to update from someone else" do
      a_trip = build :trip
      someones_trip = create :trip
      @request.env['RAW_POST_DATA'] = { title: a_trip.title, content: a_trip.content }.to_json
      put :update, uid: someones_trip.uid
      assert_response :not_found
    end

    should "not be able to update from someone else even if it is public" do
      someones_trip = create :trip, public: true
      @request.env['RAW_POST_DATA'] = { title: 'title', content: 'content' }.to_json
      put :update, uid: someones_trip.uid
      assert_response :not_found
    end

    should "delete his own trip" do
      trip = create :trip, :with_notes
      authenticate_user trip.user
      assert_difference('Trip.count', -1) do
        delete :destroy, uid: trip.uid
      end
      assert_response :no_content
    end

    should "not delete someone elses trip" do
      authenticate_user create :user
      assert_no_difference('Trip.count') do
        delete :destroy, uid: @trip.uid
      end
      assert_response :not_found
    end

  end

end
