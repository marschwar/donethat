class Api::TripsController < Api::ApiController

  # /api/trips[?timestamp=123]
  def index
    @trips = Trip.owned_by(@user).recent
  end

  # /api/trips/:uid
  def show
    @trip = Trip.owned_by(@user).where(uid: params['id'])
    head(:not_found) unless @trip
  end
end