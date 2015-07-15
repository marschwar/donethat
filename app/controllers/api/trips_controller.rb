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
    @trip = parse_trip
    if @trip
      @trip.user = current_user
      if @trip.save
        render :show
      else
        render json: @trip.errors, status: :bad_request
      end
    else
      head :bad_request
    end

  end

  private
    def trips
      Trip.accessible_by(current_ability)
    end

    def parse_trip
      Trip.new json.slice(:uid, :title, :content, :public, :created_at, :updated_at)
    end

    def json
      @json ||= JSON.parse(request.body.read).try(:with_indifferent_access)
    end
end