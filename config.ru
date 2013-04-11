require 'sidekiq'

use Rack::Auth::Basic do |username, password|
  username == "electnext" && password == "secret"
end

Sidekiq.configure_client do |config|
  if ENV['RAILS_ENV'] == "production"
    config.redis = { :url => 'redis://redis-1.electnext.com:6379' }
  elsif ENV['RAILS_ENV'] == "staging"
    config.redis = { :url => 'redis://redis-staging.electnext.com:6379' }
  else
    config.redis = { :url => 'redis://localhost:6379' }
  end
end

require 'sidekiq/web'
run Sidekiq::Web