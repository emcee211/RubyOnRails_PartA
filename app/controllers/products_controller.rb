class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    # get data + insert
    product_manager = ProductManager.new()
    @response = product_manager.get_data(params[:upc_code])

    puts "== success insert"

    respond_to do |format|
      if params[:upc_code].nil? || params[:upc_code] == ""
        format.html { redirect_to root_path,  notice: "UPC cannot be null" }
      elsif @response["code"] == 1
        # format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.html { redirect_to products_path, notice: "Product was successfully created." }
        # format.json { render :show, status: :created, location: @product }
      else
        # format.html { redirect_to home_index_path, notice: "Product was failed created." }
        format.html { redirect_to root_path,  notice: @response["errors"] }
        # format.json { render :show, status: :failed, location: @product }
        # format.html { render : "home/index", locals: { msg: @response["errors"] } }
      end
    end
  end


  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:upc_code, :product_name, :size, :brands, :categories, :ingredients, :image_url)
    end
end
