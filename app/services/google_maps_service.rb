class GoogleMapsService

  def initialize(routing_support)
    @routing_support = routing_support
  end

  def maps_data(notes)
    if notes.present?
      notes = [notes] if notes.class == Note
      # select those that have geo locations
      notes = notes.select { |n| n.longitude && n.latitude}
    end

    return nil unless notes.present?

    result = {
      center: calculate_center(notes),
      locations: locations(notes)
    }
  end

  def maps_data_json(notes)
    data = maps_data(notes)
    data.to_json if data.present?
  end

private

  def calculate_center(notes)
    values = {lon: [], lat: []}
    notes.inject(values) do |hash, n|
       hash[:lon] << n.longitude
       hash[:lat] << n.latitude
       hash
    end

    {
      lon: values[:lon].sum / values[:lon].size,
      lat: values[:lat].sum / values[:lat].size
    }
  end

  def locations(notes)
    notes.map do |note|
      {
        longitude: note.longitude,
        latitude: note.latitude,
        title: note.title,
        id: note.id,
        url: @routing_support.trip_note_path(note.trip, note),
        teaser: note.lead
      }
    end
  end
end