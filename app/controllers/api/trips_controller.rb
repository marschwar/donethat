class Api::TripsController < Api::ApiController

  # /api/trips[?timestamp=123]
  def index
    @trips = trips.recent
  end

  # /api/trips/:uid
  def show
    @trip = trips.where(uid: params[:uid]).first
    head(:not_found) unless @trip
  end

  def create
    @trip = parse_trip
    if @trip
      @trip.user = current_user
      if @trip.save
        head :created, location: api_trip_path(@trip.uid)
      else
        render json: @trip.errors, status: :bad_request
      end
    else
      head :bad_request
    end
  end

  def update
    @trip = trips.find_by(uid: params[:uid])
    if @trip
      @trip.update trip_hash.except(:uid)
      if @trip.save
        head :accepted
      else
        render json: @trip.errors, status: :bad_request
      end
    else
      head :not_found
    end
  end

  private
    def trips
      Trip.owned_by(current_user)
    end

    def parse_trip
      Trip.new trip_hash
    end

    def trip_hash
      json.slice(:uid, :title, :content, :public, :created_at, :updated_at) || {}
    end

    def json
      @json ||= JSON.parse(request.body.read).try(:with_indifferent_access)
    end
end