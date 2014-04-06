class TripsController < ApplicationController

  TripsController::CAROUSEL_ITEM_COUNT = 3;
  TripsController::PER_PAGE = 10;

  # GET /trips
  # GET /trips.json
  def index
    visible_trips = Trip.visible(@user).recent
    @carousel_items = visible_trips.slice(0..(TripsController::CAROUSEL_ITEM_COUNT-1))
    @trips = visible_trips.slice(TripsController::CAROUSEL_ITEM_COUNT, TripsController::PER_PAGE - TripsController::CAROUSEL_ITEM_COUNT)
    @carousel = @trips and @trips.count > 6

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: visible_trips }
    end
  end

  def my
    redirect_to '/trips/all' unless @user
    @trips = Trip.owned_by(@user).recent
    respond_to do |format|
      format.html { render 'index'}
    end
  end

  def all
    @trips = Trip.visible(@user).recent
    respond_to do |format|
      format.html { render 'index'}
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @trip = Trip.find(params[:id])
    # TODO: allowed?
    @google = maps_service.maps_data_json(@trip.notes.recent)

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @trip }
    end
  end

private
  def maps_service
    @maps_service ||= GoogleMapsService.new self
  end
end
