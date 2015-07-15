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

  private
    def trips
      Trip.accessible_by(current_ability)
    end
end