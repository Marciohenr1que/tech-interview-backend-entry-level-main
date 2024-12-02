require 'rails_helper'

RSpec.describe DeleteAbandonedCartsJob, type: :job do
  let!(:abandoned_cart_older_than_7_days) { create(:cart, abandoned: true, updated_at: 8.days.ago) }
  let!(:abandoned_cart_within_7_days) { create(:cart, abandoned: false, updated_at: 6.days.ago) }
  let!(:non_abandoned_cart_older_than_7_days) { create(:cart, abandoned: false, updated_at: 8.days.ago) }
  let!(:non_abandoned_cart_within_7_days) { create(:cart, abandoned: false, updated_at: 6.days.ago) }

  describe '#perform' do
    context 'when there are abandoned carts older than 7 days' do
      it 'destroys the abandoned carts older than 7 days' do
        expect { DeleteAbandonedCartsJob.new.perform }.to change { Cart.count }.by(-1)
      end
    end

    context 'when there are no abandoned carts older than 7 days' do
      it 'does not destroy any carts' do
        # Remover o cart abandonado mais antigo
        abandoned_cart_older_than_7_days.destroy
        expect { DeleteAbandonedCartsJob.new.perform }.not_to change { Cart.count }
      end
    end
  end
end

