require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:products).through(:cart_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:session_id) }
    it { should validate_numericality_of(:total_price).allow_nil }
  end

  describe 'callbacks' do
    describe 'before_save :recalculate_total_price' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product, price: 50) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }
  
      it 'recalculates total_price before saving' do
        cart.reload.save! # Garante que o callback seja acionado
        expect(cart.total_price).to eq(100.00) # 50 * 2
      end
    end
  end

  describe 'scopes' do
    describe '.abandoned' do
      it 'returns carts that have not been updated for more than 3 hours and are not marked as abandoned' do
        old_cart = create(:cart, updated_at: 4.hours.ago, abandoned: false)
        recent_cart = create(:cart, updated_at: 2.hours.ago, abandoned: false)

        expect(Cart.abandoned).to include(old_cart)
        expect(Cart.abandoned).not_to include(recent_cart)
      end
    end
  end
end

