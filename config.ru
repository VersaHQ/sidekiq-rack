require 'sidekiq'
environment = ENV['RAILS_ENV'] || "development"
config_vars = YAML.load_file("./config.yml")[environment]

use Rack::Auth::Basic do |username, password|
  username == config_vars["username"] && password == config_vars["password"]
end

Sidekiq.configure_client do |config|
  config.redis = { :url => config_vars["redis_url"] }
end

require 'sidekiq/web'
run Sidekiq::Web