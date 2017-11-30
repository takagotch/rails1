json.extract! order, :id, :orderdate, :member_id, :box_id, :created_at, :updated_at
json.url order_url(order, format: :json)