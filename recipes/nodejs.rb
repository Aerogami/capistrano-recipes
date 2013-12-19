namespace :nodejs do
  desc "Install latest stable release of NodeJS"
  task :install, roles: :app do
    run "#{sudo} add-apt-repository ppa:chris-lea/node.js", pty: true do |ch, stream, data|
      if data =~ /Press.\[ENTER\].to.continue/
        ch.send_data(Capistrano::CLI.password_prompt("Press enter to continue:") + "\n")
      else
        Capistrano::Configuration.default_io_proc.call(ch,stream,data)
      end
    end
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nodejs"
  end
  after "deploy:install", "nodejs:install"
end