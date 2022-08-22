json.extract! product, :id, :upc_code, :product_name, :size, :brands, :categories, :ingredients, :image_url, :created_at, :updated_at
json.url product_url(product, format: :json)
