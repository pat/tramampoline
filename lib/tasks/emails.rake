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
    Event.next.attendees.active.order('created_at ASC').each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.preparing(attendee).deliver
    end
    puts "Done."
  end

  desc 'Send out Final Reminder'
  task :final_reminder => :environment do
    Event.next.attendees.active.order('created_at ASC').each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.final_reminder(attendee).deliver
    end
    puts "Done."
  end

  desc 'Send out Wrapping up'
  task :wrapup => :environment do
    Event.latest.attendees.active.order('created_at ASC').each do |attendee|
      puts "Emailing #{attendee.name}"
      Notifications.wrapup(attendee).deliver
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
    Event.next.uninvited_attendees.each do |attendee|
      next unless attendee.invite.attendees.empty?

      puts "Emailing #{attendee.name}"
      Notifications.invite_reminder(attendee).deliver
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
