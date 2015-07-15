class Api::TripsController < Api::ApiController

  # /api/trips[?timestamp=123]
  def index
    @trips = trips.recent
  end

  # /api/trips/:uid
  def show
    @trip = trips.where(uid: params['id']).first
    head(:not_found) unless @trip
  end

  def create
    @trip = Trip.new trip_params
    @trip.user = current_user
    unless @trip.save
      return render json: @trip.errors, status: :bad_request
    end
    render :show
  end

  private
    def trips
      Trip.accessible_by(current_ability)
    end

    def trip_params
      params.require(:trip).permit(:uid, :title, :content, :public, :created_at, :updated_at)
    end
end