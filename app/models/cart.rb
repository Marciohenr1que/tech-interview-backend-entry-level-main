class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  validates :session_id, presence: true
  validates :total_price, numericality: true, allow_nil: true

 
  scope :abandoned, -> { where('updated_at < ?', 3.hours.ago).where(abandoned: false) }

 
  before_save :recalculate_total_price

  private

  def recalculate_total_price
    self.total_price = cart_items.sum { |item| item.product.price * item.quantity }
  end
end

