module ShoppingCart
  class AddProductService
    def initialize(cart:, product_id:, quantity:)
      @cart = cart
      @product = Product.find(product_id)
      @quantity = quantity
    end

    def call
      cart_item = @cart.cart_items.find_or_initialize_by(product: @product)
      cart_item.quantity ||= 0
      cart_item.quantity += @quantity
      cart_item.save!

      update_cart_total
      Result.new(success: true)
    rescue StandardError => e
      Result.new(success: false, error: e.message)
    end

  
    private

    def update_cart_total
      @cart.update!(total_price: @cart.cart_items.sum(&:total_price))
    end

    class Result
      attr_reader :success, :error, :cart_items

      def initialize(success:, error: nil, cart_items: nil)
        @success = success
        @error = error
        @cart_items = cart_items
      end

      def success?
        @success
      end
    end
  end
end
