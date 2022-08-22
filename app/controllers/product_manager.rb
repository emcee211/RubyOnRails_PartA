# httparty2.rb
require "httparty"

class ProductManager
  include HTTParty
  @@base_uri = 'https://world.openfoodfacts.org/api/v0/product/'

  @@response = {
    "code" => 200,
    "errors" => "",
    "data" => []
  }

  def initialize()

  end

  def get_data(upc)
    @@response = {
        "code" => 200,
        "errors" => "",
        "data" => []
      }
    
    parsed_response = {}
    parsed_response["status"] = "Error"
    # API get from network
    begin 
      @apiresponse = HTTParty.get(@@base_uri + upc + ".json")
      parsed_response = JSON.parse(@apiresponse.body)
    rescue 
      @@response["errors"] = "Something went wrong"
      @@response["data"] = []
      @@response["code"] = 2
      return @@response
    rescue Exception
      @@response["errors"] = "Something went wrong"
      @@response["data"] = [] 
      @@response["code"] = 2
      return @@response
    end

    if parsed_response['status'] == 1
      # puts @apiresponse.body
      @@response["errors"] = parsed_response["status_verbose"]
      @@response["code"] = parsed_response["status"]
      product = parsed_response["product"]

      # insert to database
      begin
        new_product = Product.create(
          "upc_code" => upc, 
          "product_name" => product["product_name"],
          "size" => product["quantity"],
          "brands" => product["brands"],
          "categories" => product["categories"],
          "ingredients" => product["ingredients_text"],
          "image_url" => product["image_url"]
         )
        new_product.save
        # WHY??
        @@response["data"] = Product.all
        # @@response["data"] = new_product.save
      rescue ActiveRecord::RecordNotFound
        @@response["errors"] = "Not Found"
        @@response["data"] = []
        @@response["code"] = 2
      rescue ActiveRecord::ActiveRecordError
        @@response["errors"] = "ActiveRecordError"
        @@response["data"] = []
        @@response["code"] = 2
      rescue 
        @@response["errors"] = "Data not found"
        @@response["data"] = []
        @@response["code"] = 2
      rescue Exception
        @@response["errors"] = "Something went wrong"
        @@response["data"] = [] 
        @@response["code"] = 2
      end
    else 
      # data
      @@response["errors"] = parsed_response["status_verbose"]
      @@response["code"] = parsed_response["status"]
    end
      # return 
    @@response
  end
end