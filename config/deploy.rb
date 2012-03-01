server 'rego.co.il', :app, :web, :db, :primary => true
set :user, "iplanrob"                   # Your server instance user
set :deploy_to, "/home/#{user}/apps/tarantula-iplan.co.il"          # Where on the server your app will be deployed
set :branch, "master"
set :keep_releases, 2

ssh_options[:port] = 22

set :scm, "git"
set :repository, "git@github.com:alextk/tarantula.git"  # Your clone URL
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

set :use_sudo, false
set :group_writable, false
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions

default_run_options[:pty] = true
# Cap won't work on windows without the above line, see
# http://groups.google.com/group/capistrano/browse_thread/thread/13b029f75b61c09d
# Its OK to leave it true for Linux/Mac

#Here we overrie the default restart task (that is part of deploy task), to issue command that makes mod_rails to restart the application
namespace :deploy do
  desc "Restart Passenger Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

#in this namespace we define all tasks that customize the deploy procedure
namespace :custom_deploy do

  #This taks created config shared folder
  #The task is run after deploy:setup task
  desc 'Create config shared folder (to hold production database.yml and yaml configuration entities)'
  task :create_shared_config do
    run "mkdir -p #{shared_path}/config"
  end
  
  desc 'Symlink production database.yml file (for security, so production db details will not sit in svn), symlynk application configuration yml files (so they won\'t be overriden each deploy)'
  task :symlink_config_resources do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end

after 'deploy:setup', 'custom_deploy:create_shared_config'
after 'deploy:symlink', 'custom_deploy:symlink_config_resources'

#Make sure old releases are deleted, after each time deploy:update is inovked (new version is pulled from svn)
after 'deploy:update', 'deploy:cleanup'

#Show production log contents on local machine
desc 'Connnect to the server, and show production log tail in local console'
task :log, :roles => :app do
  stream "tail -f #{shared_path}/log/production.log"
end

namespace :cache do
  desc 'Clear assets cache on the remote server (the cache is found in public/cache folder, and contains cache resources like javascripts, css etc.)'
  task :clear, :roles => :app do
    run "rm -f #{current_path}/public/javascripts/cache/*"
    run "rm -f #{current_path}/public/stylesheets/cache/*"
  end
end

