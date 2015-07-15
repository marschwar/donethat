require 'test_helper'
require 'mocha/test_unit'

class GoogleMapsServiceTest < ActiveSupport::TestCase
  setup do
    mock = Object.new
    mock.stubs(:trip_note_path).returns('url')
    @service = GoogleMapsService.new mock
  end

  context 'maps_data' do
    should 'return nil for no notes' do
      assert_equal nil, @service.maps_data(nil)
      assert_equal nil, @service.maps_data([])
    end

    should 'return nil for one note without geo location' do
      note = create(:note)
      assert_equal nil, @service.maps_data(note)
    end

    should 'work for one note with location' do
      note = create(:note, longitude: 10.0, latitude: 5.0, content: 'my content')

      data = @service.maps_data(note)
      assert_equal 10.0, data[:center][:lon]
      assert_equal 5.0, data[:center][:lat]
      assert_equal 'my content', data[:locations][0][:teaser]

      data = @service.maps_data([note])
      assert_equal 10.0, data[:center][:lon]
      assert_equal 5.0, data[:center][:lat]
      assert_equal 'my content', data[:locations][0][:teaser]
    end

    should 'work for two notes with the same coordinates' do
      data = @service.maps_data([create(:note_with_location), create(:note_with_location)])
      assert_equal 10.0, data[:center][:lon]
      assert_equal 5.0, data[:center][:lat]
    end

    should 'two notes but one without coordinates' do
      data = @service.maps_data([create(:note_with_location), create(:note)])
      assert_equal 10.0, data[:center][:lon]
      assert_equal 5.0, data[:center][:lat]
    end

    should 'two notes with the different coordinates' do
      n1 = create(:note, longitude: 10.0, latitude: 5.0, content: 'test')
      n2 = create(:note, longitude: 11.0, latitude: -2.0)
      data = @service.maps_data([n1, n2])
      assert_equal 10.5, data[:center][:lon]
      assert_equal 1.5, data[:center][:lat]
      assert_equal 'test', data[:locations][0][:teaser]
      assert_equal n1.id, data[:locations][0][:id]
      assert_equal 2, data[:locations].size
    end
  end
end