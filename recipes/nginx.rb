namespace :nginx do
  desc "Install latest stable release of Nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository ppa:nginx/stable", pty: true do |ch, stream, data|
      if data =~ /Press.\[ENTER\].to.continue/
        ch.send_data(Capistrano::CLI.password_prompt("Press enter to continue:") + "\n")
      else
        Capistrano::Configuration.default_io_proc.call(ch,stream,data)
      end
    end
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup Nginx configuration for this app"
  task :setup, roles: :web do
    template "nginx.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end