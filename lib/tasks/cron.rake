task :cron => :environment do
  LuTze.gather_and_send 'trampoline'
end
