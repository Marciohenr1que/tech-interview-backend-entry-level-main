require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe '#total_price' do
    it 'returns the total price for the cart item based on quantity and product price' do
      product = create(:product, price: 20.00)
      cart_item = create(:cart_item, product: product, quantity: 3)

      expect(cart_item.total_price).to eq(60.00) 
    end
  end
end

