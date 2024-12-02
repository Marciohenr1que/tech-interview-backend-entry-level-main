class CartSerializer
  include JSONAPI::Serializer
  attributes :session_id, :created_at, :updated_at

  
  has_many :cart_items, serializer: CartItemSerializer

  
  attribute :total_price do |object|
    object.cart_items.sum(&:total_price).to_f
  end


  attribute :products do |object|
    object.cart_items.map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price.to_f,
        total_price: item.total_price.to_f
      }
    end
  end
end


