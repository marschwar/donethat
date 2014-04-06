require 'test_helper'

class FactoriesTest < ActiveSupport::TestCase

  test 'create twitter user' do
    u = create(:twuser)
    assert u.id
    assert u.identifier
    assert_equal 'TwitterUser', u.type
    assert_equal 'TwitterUser', u.class.name
  end

  test 'create empty trip' do
    t = create(:trip)
    assert t.title
    assert t.slug
    assert t.user.identifier
  end

  test 'create note' do
    n = create(:note)
    assert n.trip.user.identifier
    assert n.uid.present?
    assert n.title.present?
  end

  test 'create trip with notes' do
    t = create(:trip_with_notes)
    assert_equal 10, t.notes.count

    t = create(:trip_with_notes, note_count: 5)
    assert_equal 5, t.notes.count
  end

end