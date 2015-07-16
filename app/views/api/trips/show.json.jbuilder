json.uid @trip.uid
json.title @trip.title
json.created_at @trip.created_at
json.updated_at @trip.updated_at
json.content @trip.content

json.notes @trip.notes do |note|
  json.title note.title
  json.uid note.uid
  json.note_date note.note_date
  json.updated_at note.updated_at
  if note.longitude && note.latitude
    json.location do
      json.lon note.longitude
      json.lat note.latitude
    end
  end
  if note.image?
    json.image note.image.main.url
  end
  json.content note.content
end
