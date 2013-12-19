namespace :permissions do
  desc "Grant permissions to app directory"
  task :grant, roles: :app do
    run "#{sudo} mkdir -p /home/#{user}/apps/#{application}"
    run "#{sudo} chown -R deployer:deployers /home/#{user}/apps/#{application}"
    run "#{sudo} chmod -R g+w /home/#{user}/apps/#{application}"
  end
  after "deploy:install", "permissions:grant"
end