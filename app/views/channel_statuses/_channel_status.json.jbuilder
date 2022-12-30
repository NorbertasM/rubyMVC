json.extract! channel_status, :id, :channel_id, :status_id, :created_at, :updated_at
json.url channel_status_url(channel_status, format: :json)
