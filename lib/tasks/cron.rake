task :cron => :environment do
  LuTze.gather_and_send
end
