class Api::NotesController < Api::ApiController

  before_filter :load_and_authorize_trip

  MAPPING = { lon: :longitude, lat: :latitude, 'note_date' => :note_datetime }.with_indifferent_access

  def create
    @note = Note.new note_params
    @note.trip = @trip

    if @note.save
      head :created
    else
      render json: @note.errors, status: :bad_request
    end
  end

  def update
    @note = @trip.notes.find_by(uid: params[:uid])
    head :not_found and return unless @note
    @note.update note_params.except(:uid)

    if @note.save
      head :accepted
    else
      render json: @note.errors, status: :bad_request
    end
  end

private

  def load_and_authorize_trip
    @trip = Trip.owned_by(current_user).find_by(uid: params[:trip_uid])
    head :not_found unless @trip
  end

  def note_params
    params = body_as_json.slice(:uid, :title, :content, :location, :updated_at, :note_date) || {}
    params.merge!(params.delete(:location).slice(:lon, :lat)) if params[:location]
    rename_keys(params, MAPPING)
  end

  def rename_keys(hash, mapping)
    result = {}
    hash.map do |k,v|
      mapped_key = mapping[k] ? mapping[k] : k
      result[mapped_key] = v.kind_of?(Hash) ? rename_keys(v, mapping) : v
      result[mapped_key] = v.collect{ |obj| rename_keys(obj, mapping) if obj.kind_of?(Hash)} if v.kind_of?(Array)
    end
    result
  end
end