class NotesController < ApplicationController

  before_action :load_trip, only: [:new, :create, :show]
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  def new
    @note = Note.new(trip: @trip, note_datetime: DateTime.now)
  end

  def create
    @note = Note.new note_params
    @note.uid = SecureRandom.uuid
    @note.trip = @trip

    if @note.save
      redirect_to @trip
    else
      render 'new'
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = @trip.notes.friendly.find(params[:id])
    @google = maps_service.maps_data_json(@note)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

private

  def load_trip
    @trip = Trip.friendly.find(params[:trip_id])
  end

  def maps_service
    @maps_service ||= GoogleMapsService.new self
  end

  def note_params
    params.require(:note).permit(:title, :content, :longitude, :latitude, :note_datetime, :picture)
  end
end
