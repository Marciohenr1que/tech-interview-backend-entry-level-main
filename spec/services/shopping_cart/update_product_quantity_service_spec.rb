require 'rails_helper'
RSpec.describe ShoppingCart::UpdateProductQuantityService, type: :service do
    describe '#call' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }
      let(:new_quantity) { 3 }
      let(:service) { described_class.new(cart: cart, product_id: product.id, new_quantity: new_quantity) }
  
      context 'when the product is found and in the cart' do
        it 'updates the quantity of the cart item' do
          result = service.call
          expect(result.success?).to be_truthy
          expect(cart_item.reload.quantity).to eq(new_quantity)
        end
  
        it 'updates the total price of the cart' do
          result = service.call
          cart.reload
          expect(cart.total_price).to eq(300.00)  
        end
  
        it 'returns the updated cart items' do
          result = service.call
          expect(result.cart_items.size).to eq(1)  
        end
      end
  
      context 'when the product is not found' do
        let(:service) { described_class.new(cart: cart, product_id: 9999, new_quantity: new_quantity) }
  
        it 'returns an error indicating the product is not found' do
          result = service.call
          expect(result.success?).to be_falsey
          expect(result.error).to eq('Produto não encontrado')
        end
      end
  
      context 'when the product is not in the cart' do
        let(:other_product) { create(:product) }
        let(:service) { described_class.new(cart: cart, product_id: other_product.id, new_quantity: new_quantity) }
  
        it 'returns an error indicating the product is not in the cart' do
          result = service.call
          expect(result.success?).to be_falsey
          expect(result.error).to eq('Produto não está no carrinho')
        end
      end
  
      context 'when an exception is raised' do
        before do
          allow_any_instance_of(CartItem).to receive(:update!).and_raise(StandardError.new('Test error'))
        end
  
        it 'returns an error message' do
          result = service.call
          expect(result.success?).to be_falsey
          expect(result.error).to eq('Test error')
        end
      end
    end
  end
  
