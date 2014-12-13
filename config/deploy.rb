require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/whenever'

ruby_version = "2.0.0-p594"

set :rails_env, "production"
set :user, 'skelz0r'
set :domain, 'tiny-listing-production'
set :branch, 'master'

set :repository, 'https://github.com/skelz0r/tiny_listing.git'
set :deploy_to, '/var/www/tiny_listing'

set :rvm_path, "/usr/local/rvm/scripts/rvm"

set :shared_paths, [
  'log',
  'bin',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'public/system',
  'public/uploads',

  "config/database.yml",
  "config/environments/production.rb"
]

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/bin"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/bin"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/cache"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/cache"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/system"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
end

task :environment do
  invoke :"rvm:use[#{ruby_version}]"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    # invoke :'whenever:update'

    to :launch do
      queue "touch #{deploy_to}/current/tmp/restart.txt"
    end
  end
end
