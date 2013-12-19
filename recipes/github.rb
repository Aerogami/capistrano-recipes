namespace :github do
  desc "Install git-core library"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install git-core"
    run "#{sudo} apt-get -y update"
  end
  after "deploy:install", "github:install"
end