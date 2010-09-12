task :cron => :environment do
  LuTze.gather_and_send if Time.now.hour == 0
  Waiter.close_and_reinvite
end
