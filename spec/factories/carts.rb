FactoryBot.define do
    factory :cart do
      session_id { 'black Friday' }
      total_price { 0.00 }
      abandoned { false }
    end
  end