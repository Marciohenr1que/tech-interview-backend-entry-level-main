require 'rails_helper'

RSpec.describe ShoppingCart::RemoveProductService do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let(:cart_item) { create(:cart_item, cart: cart, product: product) }

  before do
    cart_item 
  end

  describe '#call' do
    context 'when the product exists in the cart' do
      it 'removes the product from the cart' do
        service = described_class.new(cart: cart, product_id: product.id)
        result = service.call

        expect(result.success?).to be true
        expect(cart.cart_items.find_by(product: product)).to be_nil
        expect(cart.total_price).to eq(0.0)
      end
    end

    context 'when the product does not exist in the cart' do
      it 'returns an error message' do
        another_product = create(:product, name: 'Another Product', price: 50.00)
        service = described_class.new(cart: cart, product_id: another_product.id)
        result = service.call

        expect(result.success?).to be false
        expect(result.error).to eq('Produto não está no carrinho')
      end
    end

    context 'when the product does not exist in the database' do
      it 'returns an error message' do
        service = described_class.new(cart: cart, product_id: 9999) # Produto inexistente
        result = service.call

        expect(result.success?).to be false
        expect(result.error).to eq('Produto não encontrado')
      end
    end

    context 'when an exception occurs during removal' do
      before do
        allow_any_instance_of(CartItem).to receive(:destroy!).and_raise(StandardError, 'Unexpected error')
      end

      it 'returns an error message with the exception' do
        service = described_class.new(cart: cart, product_id: product.id)
        result = service.call

        expect(result.success?).to be false
        expect(result.error).to eq('Unexpected error')
      end
    end
  end
end

