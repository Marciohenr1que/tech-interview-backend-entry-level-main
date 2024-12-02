class CartsController < ApplicationController

  def index
    carts = Cart.all
    render json: CartSerializer.new(carts).serializable_hash
  end
  
  def show
    cart = Cart.find(params[:id])
    render json: CartSerializer.new(cart).serializable_hash
  end

  def create
    if params[:product_id].blank? || params[:quantity].blank? || params[:session_id].blank?
      return render json: { error: 'Product ID, quantity, and session ID are required' }, status: :bad_request
    end
  
  
    cart = Cart.find_or_create_by(session_id: params[:session_id])
    Rails.logger.info "Cart found or created: #{cart.id}"
  
    service = ShoppingCart::AddProductService.new(cart: cart, product_id: params[:product_id], quantity: params[:quantity])
  
    result = service.call
  
    if result.success?
      render json: CartSerializer.new(cart.reload).serializable_hash
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  def add_product_to_cart
    cart = Cart.find(params[:id])
    product_id = params[:product_id]
    quantity = params[:quantity]
  
    service = ShoppingCart::AddProductService.new(cart: cart, product_id: product_id, quantity: quantity)
    result = service.call
  
    if result.success?
      render json: CartSerializer.new(cart.reload).serializable_hash
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
  def remove_product
    cart = Cart.find(params[:id]) 
    product_id = params[:product_id]

    service = ShoppingCart::RemoveProductService.new(cart: cart, product_id: product_id)
    result = service.call

    if result.success?
      render json: CartSerializer.new(cart.reload).serializable_hash
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  def update_quantity
    cart = Cart.find(params[:id])  
    product_id = params[:product_id]
    new_quantity = params[:quantity].to_i 

    if new_quantity <= 0
      return render json: { error: 'Quantidade inválida' }, status: :unprocessable_entity
    end

    
    service = ShoppingCart::UpdateProductQuantityService.new(cart: cart, product_id: product_id, new_quantity: new_quantity)
    result = service.call  

    if result.success?
      
      render json: CartSerializer.new(cart.reload).serializable_hash
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
end


