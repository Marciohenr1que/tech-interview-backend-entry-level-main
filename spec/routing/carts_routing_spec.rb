require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/carts/1').to route_to('carts#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/carts').to route_to('carts#create')
    end

    it 'routes to #add_product_to_cart' do
      expect(post: '/carts/1/addproducttocart').to route_to('carts#add_product_to_cart', id: '1')
    end

    it 'routes to #remove_product' do
      expect(patch: '/carts/1/removeproduct').to route_to('carts#remove_product', id: '1')
    end

    it 'routes to #update_quantity' do
      expect(patch: '/carts/1/updatequantity').to route_to('carts#update_quantity', id: '1')
    end
  end
end


