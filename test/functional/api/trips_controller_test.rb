require 'test_helper'

class Api::TripsControllerTest < ActionController::TestCase

  setup do
    @user = create :twuser, password: password
    @trip = create :trip, user: @user
    create :trip # someone elses trip
  end

  context 'an unauthorized user' do
    should "be rejected" do
      get :index, format: :json
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
      get :show, id: @trip.uid, format: :json
      assert_response :success
      assert_equal @trip.title, json_response[:title]
    end

    should "fail to retrieve with invalid uid" do
      get :show, id: 'unknown-uid', format: :json
      assert_response :not_found
    end

    should "create a new trip" do
      a_trip = build :trip
      assert_difference('Trip.count') do
        post :create, trip: { uid: a_trip.uid, title: a_trip.title, content: a_trip.content }, format: :json
      end
      assert_response :success
      assert_equal a_trip.title, json_response[:title]
    end

    should "fail if data is incomplete" do
      a_trip = build :trip
      assert_no_difference('Trip.count') do
        post :create, trip: { uid: a_trip.uid, content: a_trip.content }, format: :json
      end
      assert_response :bad_request
    end

    should "fail if uid exists" do
      a_trip = build :trip
      assert_no_difference('Trip.count') do
        post :create, trip: { uid: @trip.uid, title: a_trip.title, content: a_trip.content }, format: :json
      end
      assert_response :bad_request
    end
  end

private
  def authenticate_user(user = @trip.user)
    request.headers['X-Auth-Token'] = "#{user.identifier}:#{password}"
  end

  def password
    'password'
  end

  def json_response
    response = ActiveSupport::JSON.decode @response.body
    if response.class == Hash
      response.with_indifferent_access
    else
      response
    end
  end

end