require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  setup do
    @trip = create(:trip)
  end

  context 'a user' do
    setup do
      ensure_logged_in
    end

    should "should get new for user" do
      get :new
      assert_response :success
    end
    should "create trip" do
      assert_difference('Trip.count') do
        post :create, trip: { title: 'new title', content: 'any content', user_id: @trip.user_id }
      end

      assert_redirected_to trip_path(assigns(:trip))
    end
    should "not create trip without title" do
      assert_no_difference('Trip.count') do
        post :create, trip: { content: 'something', user_id: @trip.user_id }
      end

      assert_response :success
    end
    should "show trip to owner" do
      get :show, id: @trip.slug
      assert_response :success
    end
    should "not see private trip by other user" do
      ensure_logged_in create :user
      get :show, id: @trip.slug
      assert_response :forbidden
    end
    should "be able to see update form" do
      get :edit, id: @trip.slug
      assert_response :success
    end
  end

  context 'a guest' do
    should "be able to see index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:trips)
    end

    should "be able to see create form" do
      get :new
      assert_response :forbidden
    end
    should "not be able to create trip" do
      assert_no_difference('Trip.count') do
        post :create, trip: { content: 'new title' }
      end
      assert_response :forbidden
    end
    should "be able see public trip" do
      @trip = create :trip, public: true
      get :show, id: @trip.slug
      assert_response :success
    end
    should "not see private trip" do
      get :show, id: @trip.slug
      assert_response :forbidden
    end
  end

private
  def ensure_logged_in(user = @trip.user)
    session[:user_id] = user.id
  end

end
