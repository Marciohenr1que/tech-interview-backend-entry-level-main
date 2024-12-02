class CartItemSerializer
  include JSONAPI::Serializer

  attributes :quantity

  attribute :total_price do |cart_item|
    cart_item.product.decorate.format_price(cart_item.total_price)
  end

  belongs_to :product, serializer: ProductSerializer
end


  