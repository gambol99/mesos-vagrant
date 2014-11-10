set :stages, %w(staging prod)
set :scm, :git
set :repository,  "https://github.com/gambol99/mesos-vagrant.git"
set :branch, ENV["branch"]
set :application, "docker"
set :shell, "bash"
set :user, "root"
set :use_sudo, true
set :deploy_to, "/etc/puppet"
set :deploy_via, :remote_cache
set :copy_exclude, ".git"
set :git_enable_submodules, 1
set :normalize_asset_timestamps, false

ssh_options[:paranoid] = false

before "deploy:update", "deploy:announce"
after "deploy:update", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do ; end
  task :announce do
    asciify "Deploy #{fetch(:stage)}"
  end
end
