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

end
