set :application, "tramampoline"
set :repository,  "git@github.com:freelancing-god/tramampoline.git"

set :scm,       :git
set :user,      'trampoline'
set :use_sudo,  false

default_run_options[:pty] = true

role :web, "trampolineday.com"
role :app, "trampolineday.com"
role :db,  "trampolineday.com", :primary => true

set :deploy_to, "/var/www/#{application}"

namespace :deploy do
  task :start do
    #
  end
  
  task :stop do
    #
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code' do
  run "cd #{release_path} && bundle install && bundle lock"
end

after 'deploy:symlink' do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
