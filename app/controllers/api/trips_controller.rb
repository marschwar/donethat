class Api::TripsController < Api::ApiController

  # /api/trips[?timestamp=123]
  def index
    trips = Trip.owned_by(@user).recent
    if params[:timestamp]
      trips = trips.changed_after(Time.at(params[:timestamp].to_i))
    end

    respond_to do |format|
      format.json { render json: trips }
    end
  end

  # /api/trips/:uid
  def show
    trip = Trip.owned_by(@user).where(uid: params['id'])

    if trip.present?
      respond_to do |format|
        format.json { render json: trip }
      end
    else
      head(:not_found)
    end
  end
end