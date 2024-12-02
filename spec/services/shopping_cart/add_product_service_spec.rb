require 'rails_helper'

RSpec.describe ShoppingCart::AddProductService, type: :service do
  describe '#call' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, price: 50.00) }
    let(:quantity) { 2 }

    subject(:service) { described_class.new(cart: cart, product_id: product.id, quantity: quantity) }

    context 'when adding a new product to the cart' do
      it 'creates a new cart item with the correct quantity' do
        result = service.call

        expect(result.success?).to be(true)
        expect(cart.reload.cart_items.count).to eq(1)
        expect(cart.cart_items.first.quantity).to eq(quantity)
      end

      it 'updates the cart total price' do
        service.call
        expect(cart.reload.total_price).to eq(100.00) 
      end
    end

    context 'when updating an existing product in the cart' do
      before do
        create(:cart_item, cart: cart, product: product, quantity: 1)
      end

      it 'increments the quantity of the cart item' do
        result = service.call

        expect(result.success?).to be(true)
        expect(cart.reload.cart_items.first.quantity).to eq(3)
      end
    end

    context 'when an error occurs during the operation' do
      before do
        allow_any_instance_of(CartItem).to receive(:save!).and_raise(StandardError, 'Unexpected error')
      end

      it 'returns an error result' do
        result = service.call

        expect(result.success?).to be(false)
        expect(result.error).to eq('Unexpected error')
      end

      it 'does not update the cart total price' do
        service.call rescue nil
        expect(cart.reload.total_price).to eq(0.0)  
      end
    end
  end
end
