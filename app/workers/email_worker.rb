class EmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    puts "Sidekiq worker generating report"
  end
end