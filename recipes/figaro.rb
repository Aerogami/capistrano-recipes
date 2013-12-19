namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup, roles: :app do
    transfer :up, "config/application.yml", "#{shared_path}/config/application.yml", via: :scp
  end
  after "deploy:finalize_update", "figaro:setup"

  desc "Symlink application.yml to the release path"
  task :symlink, roles: :app do
    run "ln -sf #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "figaro:symlink"
end