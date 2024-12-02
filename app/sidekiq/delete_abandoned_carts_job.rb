class DeleteAbandonedCartsJob
  include Sidekiq::Job

  def perform
    
    carts = Cart.where('updated_at < ?', 7.days.ago).where(abandoned: true)
    
   
    carts.destroy_all
  end
end
