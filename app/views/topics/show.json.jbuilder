# json.partial! "topics/topic", topic: @topic

json.(@topic, :id, :title, :description, :created_at, :updated_at)
