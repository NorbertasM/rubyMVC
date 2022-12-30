json.extract! preview_status, :id, :channel_id, :preview_id, :valid_until, :created_at, :updated_at
json.url preview_status_url(preview_status, format: :json)
