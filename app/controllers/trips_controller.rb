class TripsController < ApplicationController

  TripsController::CAROUSEL_ITEM_COUNT = 3;
  TripsController::PER_PAGE = 10;

  def new
    redirect_to '/trips/all' unless @user
    @trip = Trip.new(user: @user)
  end

  def create
    @trip = Trip.create(trip_params)
    @trip.uid = SecureRandom.uuid
    if @trip.save
      redirect_to @trip
    else
      render 'new'
    end
  end

  # GET /trips
  # GET /trips.json
  def index
    visible_trips = Trip.visible(@user).recent.first_n(TripsController::PER_PAGE)
    with_images = visible_trips.select { |t| t.image? }

    @carousel_items = with_images.slice(0..(TripsController::CAROUSEL_ITEM_COUNT - 1))
    @trips = visible_trips - @carousel_items
    @carousel = @trips and @trips.count > 6

    respond_to do |format|
      format.html
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
    @trip = Trip.friendly.find(params[:id])
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

  def trip_params
    params.require(:trip).permit(:user_id, :title, :content, :public)
  end
end
