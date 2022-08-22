class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :upc_code
      t.string :product_name
      t.string :size
      t.string :brands
      t.text :categories
      t.text :ingredients
      t.text :image_url

      t.timestamps
    end
  end
end
