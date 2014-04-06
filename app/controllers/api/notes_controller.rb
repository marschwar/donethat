class Api::NotesController < Api::ApiController

  before_filter :load_trip

  # /api/trips/:trip_id/notes
  def index
    notes = @trip.notes.recent
    if params[:timestamp]
      notes = notes.changed_after(Time.at(params[:timestamp].to_i))
    end
    respond_to do |format|
      format.json { render json: notes }
    end
  end

  # /api/trips/:uid
  def show
    trip = Trip.owned_by(@user).where(id: params['id'])

    if trip.present?
      respond_to do |format|
        format.json { render json: trip }
      end
    else
      head(:not_found)
    end
  end

private

  def load_trip
    trips = Trip.owned_by(@user).where(uid: params['trip_id'])
    if trips.size == 1
      @trip = trips.first
    else
      head(:not_found) unless @trip.present?
    end
  end
end