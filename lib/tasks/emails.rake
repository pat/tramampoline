namespace :emails do
  desc 'Send out Final Reminder'
  task :final_reminder => :environment do
    Attendee.all.each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.deliver_final_reminder attendee
    end
    puts "Done."
  end
end
