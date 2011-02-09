namespace :subscribers do
  task :export_to_mailchimp => :environment do
    Subscriber.all.each { |s| s.send :add_to_mailchimp }
  end
end
