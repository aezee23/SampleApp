namespace :mailer do
  desc "Sends the late email"
  task :late => :environment do
    late_mail
  end
end

def haha
  puts "....loading...."
  puts "DONE!"
  puts "#{Church.count} churches"
end

def late_mail
  puts 'running'
  Church.missing_latest_data.each do |church|
    UserMailer.missed_email(church).deliver_later
    puts "Sent mail for #{church.name} to #{church.elder.name}"
  end
  puts "Complete. Sent #{Church.missing_latest_data.count} emails to churches."
end