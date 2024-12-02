class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    carts = Cart.where('updated_at < ?', 3.hours.ago).where(abandoned: false)
    carts.update_all(abandoned: true)
  end
end
