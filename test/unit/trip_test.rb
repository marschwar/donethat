require 'test_helper'

class TripTest < ActiveSupport::TestCase

  test 'friendly id' do
    t = create(:trip, title: 'My friendly Test')

    assert_equal 'my-friendly-test', t.slug
  end

  test 'validation' do
    t = Trip.new
    refute t.valid?
    assert t.errors[:uid].present?
    assert t.errors[:title].present?
    assert t.errors[:user].present?
    assert t.errors[:created_at].blank?
  end

  test 'owned_by scope' do
    me = create(:user)
    trip1 = create(:trip, user: me)
    trip2 = create(:trip)
    trip3 = create(:trip, public: true)

    assert_equal [trip1], Trip.owned_by(me)
  end

  test 'visible scope with user' do
    me = create(:user)
    trip1 = create(:trip, user: me)
    trip2 = create(:trip)
    trip3 = create(:trip, public: true)

    assert_equal [trip1, trip3], Trip.visible(me)
  end

  test 'visible scope without user' do
    me = create(:user)
    trip1 = create(:trip, user: me)
    trip2 = create(:trip)
    trip3 = create(:trip, public: true)

    assert_equal [trip3], Trip.visible
  end
end
