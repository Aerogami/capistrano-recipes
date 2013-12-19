namespace :deploy do
  desc "Install required packages"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install python-software-properties software-properties-common"
    run "#{sudo} apt-get -y update"
  end
end