namespace :tester do
  desc "puts somstuf to the screen"
  task :write => :environment do
    haha
  end
end

def haha
  puts "....loading...."
  puts "DONE!"
  puts "#{Church.count} churches"
end