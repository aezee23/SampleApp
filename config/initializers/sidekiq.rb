require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/api'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['sidekiq_uname'], ENV['sidekiq_pword']]
end

