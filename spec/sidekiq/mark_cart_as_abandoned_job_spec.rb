require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  let!(:cart_1) { create(:cart, updated_at: 4.hours.ago, abandoned: false) }
  let!(:cart_2) { create(:cart, updated_at: 2.hours.ago, abandoned: false) }
  let!(:cart_3) { create(:cart, updated_at: 4.hours.ago, abandoned: true) }
  let!(:cart_4) { create(:cart, updated_at: 5.hours.ago, abandoned: false) }

  describe '#perform' do
    context 'when there are carts that have not been updated in the last 3 hours' do
      it 'marks carts as abandoned' do
        # Verificando o estado antes de rodar o job
        expect(cart_1.reload.abandoned).to eq(false)
        expect(cart_2.reload.abandoned).to eq(false)
        expect(cart_3.reload.abandoned).to eq(true)
        expect(cart_4.reload.abandoned).to eq(false)

        # Rodando o job
        MarkCartAsAbandonedJob.new.perform

       
        expect(cart_1.reload.abandoned).to eq(true)  
        expect(cart_2.reload.abandoned).to eq(false) 
        expect(cart_3.reload.abandoned).to eq(true)  
        expect(cart_4.reload.abandoned).to eq(true)  
      end
    end

    context 'when there are no carts to mark as abandoned' do
      before do
        # Limpar os carrinho
        Cart.destroy_all
      end

      it 'does not update any carts' do
        expect { MarkCartAsAbandonedJob.new.perform }.not_to change(Cart, :count)
      end
    end

    context 'when there are only carts that were recently updated' do
      it 'does not mark any carts as abandoned' do
        # antes de rodar o job
        expect(cart_2.reload.abandoned).to eq(false)
        expect(cart_3.reload.abandoned).to eq(true)

        # job
        MarkCartAsAbandonedJob.new.perform

        # não foi marcado como abandonado
        expect(cart_2.reload.abandoned).to eq(false)
        expect(cart_3.reload.abandoned).to eq(true)  
      end
    end
  end
end
