class ProductsController < ApplicationController
  def index
    products = Product.all.page(params[:page]).per(10)
    render json: ProductSerializer.new(products).serializable_hash
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: ProductSerializer.new(product).serializable_hash, status: :created
    else
      
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price)
  end
end

