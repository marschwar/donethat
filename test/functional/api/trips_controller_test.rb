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
