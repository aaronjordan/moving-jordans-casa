json.extract! item, :id, :title, :draft, :suggested_price, :reserve_price, :created_at, :updated_at
json.url item_url(item, format: :json)
