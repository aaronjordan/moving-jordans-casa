json.extract! event, :id, :title, :desc, :start_time, :end_time, :location, :created_at, :updated_at
json.url event_url(event, format: :json)
json.desc event.desc.to_s
