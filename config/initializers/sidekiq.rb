Sidekiq.configure_server do |config|
    config.redis = { url: 'rediss://red-cp5nvsa1hbls73fj3ssg:9ocnNmDZK6fPz4UChUI3wfF8AukSP0oU@virginia-redis.render.com:6379/0' }
    
    if Rails.env.production?
      Sidekiq::Cron::Job.create(
        name: 'Mark abandoned carts job every hour',    
        cron: '0 * * * *',   
        class: 'MarkAbandonedCartsJob'  
      )
  
      Sidekiq::Cron::Job.create(
        name: 'Delete abandoned carts job every day',    
        cron: '0 0 * * *',   
        class: 'DeleteAbandonedCartsJob'  
      )
    end
  end
  
  Sidekiq.configure_client do |config|
    config.redis = { url: 'rediss://red-cp5nvsa1hbls73fj3ssg:9ocnNmDZK6fPz4UChUI3wfF8AukSP0oU@virginia-redis.render.com:6379/0' }
  end
  
  