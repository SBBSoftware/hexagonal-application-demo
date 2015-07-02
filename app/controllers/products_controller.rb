class ProductsController < ApplicationController
  include SbbHexagonal::RepositoryAdapter
  before_action :set_product, only: [:show, :edit, :update, :destroy, :reorder]
  before_action :set_repository

  # GET /products
  # GET /products.json
  def index
    @products = repo.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = repo.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = repo.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH /products/1/reorder
  # PATCH /products/1/reorder.json
  def reorder
    respond_to do |format|
      if repo.create_reorder(@product)
        format.html { redirect_to @product, notice: 'Product was successfully reordered.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { redirect_to @product, alert: 'Could not reorder' }
        format.json { render json: 'Could not reorder', status: :unprocessable_entity }
      end
    end
  end

  private

  def set_product
    @product = repo.find(params[:id])
  end

  def set_repository
    @repository = repo
  end

  def product_params
    params.require(:product).permit(:name, :sku, :blurb, :stock)
  end
end
