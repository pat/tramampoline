namespace :emails do
  desc 'tickets'
  task :tickets => :environment do
    Subscriber.all.each do |subscriber|
      puts "Emailing #{subscriber.name} | #{subscriber.email}"
      Announcements.deliver_tickets subscriber
    end
    puts "Done."
  end
  
  desc 'Send out Trampoline Preparation Reminder'
  task :preparing => :environment do
    Attendee.all.each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.deliver_preparing attendee
    end
    puts "Done."
  end
  
  desc 'Send out Final Reminder'
  task :final_reminder => :environment do
    Attendee.all.each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.deliver_final_reminder attendee
    end
    puts "Done."
  end
  
  desc 'Send out Wrapping up'
  task :wrapup => :environment do
    Attendee.all.each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.deliver_wrapup attendee
    end
    puts "Done."
  end
  
  desc 'Announcing Trampoline Melbourne'
  task :tramp4 => :environment do
    Subscriber.all.each do |subscriber|
      puts "Emailing #{subscriber.name} | #{subscriber.email}"
      Announcements.deliver_tramp4 subscriber
    end
    puts "Done."
  end
  
  desc 'Send invitation reminders'
  task :invite_reminders => :environment do
    Event.last.uninvited_attendees.each do |attendee|
      next unless attendee.invited.nil?
      
      puts "Emailing #{attendee.name}"
      Notifications.deliver_invite_reminder attendee
    end
    puts "Done."
  end
  
  desc 'Send out notice about upcoming second ticket release'
  task :more_soon => :environment do
    Subscriber.all.each do |subscriber|
      puts "Emailing #{subscriber.name} | #{subscriber.email}"
      Announcements.deliver_more_soon subscriber
    end
    puts "Done."
  end
  
  desc 'Send out second ticket release announcement'
  task :more => :environment do
    Subscriber.all.each do |subscriber|
      puts "Emailing #{subscriber.name} | #{subscriber.email}"
      Announcements.deliver_more subscriber
    end
    puts "Done."
  end
end
