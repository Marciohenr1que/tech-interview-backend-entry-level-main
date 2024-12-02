module ShoppingCart
    class UpdateProductQuantityService
      def initialize(cart:, product_id:, new_quantity:)
        @cart = cart
        @product = Product.find_by(id: product_id)
        @new_quantity = new_quantity
      end
  
      def call
        return Result.new(success: false, error: "Produto não encontrado") if @product.nil?
        cart_item = @cart.cart_items.find_by(product: @product)
        return Result.new(success: false, error: "Produto não está no carrinho") if cart_item.nil?
  
        cart_item.update!(quantity: @new_quantity)
        @cart.reload
        @cart.update!(total_price: @cart.cart_items.sum(&:total_price))
  
        Result.new(success: true, cart_items: @cart.cart_items)
      rescue StandardError => e
        Result.new(success: false, error: e.message)
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
  