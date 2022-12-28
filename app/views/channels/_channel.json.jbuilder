json.extract! channel, :id, :title, :description, :stream_link, :preview_url, :created_at, :updated_at
json.url channel_url(channel, format: :json)
