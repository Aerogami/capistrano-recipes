namespace :redis do
  desc "Install the latest release of Redis"
  task :install, roles: :app do
    run "#{sudo} add-apt-repository ppa:chris-lea/redis-server", pty: true do |ch, stream, data|
      if data =~ /Press.\[ENTER\].to.continue/
        ch.send_data(Capistrano::CLI.password_prompt("Press enter to continue:") + "\n")
      else
        Capistrano::Configuration.default_io_proc.call(ch,stream,data)
      end
    end
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install redis-server"
  end
  after "deploy:install", "redis:install"

  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command, roles: :web do
      run "#{sudo} service redis-server #{command}"
    end
  end
end