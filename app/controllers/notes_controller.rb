class NotesController < ApplicationController
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])
    @google = maps_service.maps_data_json(@note)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

private

  def maps_service
    @maps_service ||= GoogleMapsService.new self
  end
end
