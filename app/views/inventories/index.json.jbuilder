json.array!(@inventories) do |product|
  json.extract! product, :id
  json.url inventory_url(product, format: :json)
end
