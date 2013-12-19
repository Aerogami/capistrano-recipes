require "bundler/capistrano"
require 'sidekiq/capistrano'

load "config/recipes/base"
load "config/recipes/packages"
load "config/recipes/permissions"
load "config/recipes/github"
load "config/recipes/nodejs"
load "config/recipes/nginx"
load "config/recipes/postgresql"
load "config/recipes/unicorn"
load "config/recipes/figaro"
load "config/recipes/redis"

stages = {
  production: {
    user: '!username',
    pass: '!password',
    host: '!host',
    port: '!port', # integer (remove quotes)
    branch: 'master',
    environment: 'production'
  }
}

# Choose stage
stage = stages[:production].clone

# Application name
set :application, "imobiliario"

# server IP
server stage[:host], :app, :web, :db, primary: true

# Version control
set :scm, "git"

# Application repository
set :repository, "git@github.com:!git_username/#{application}.git"

# Branch to pull from
set :branch, stage[:branch]

# Rails environment to deploy
set :rails_env, stage[:environment]

# Avoids permission errors on server
set :use_sudo, false

# `copy` copies the entire repo, `remote_cache` pulls the latest changes only
set :deploy_via, :remote_cache

# Number of old releases to keep under /releases
# set :keep_releases, 3

# The server's user for deploys
set :user, stage[:user]

# The deploy user's password
set :scm_passphrase, stage[:pass]

# Deployment location
set :deploy_to, "/home/#{user}/apps/#{application}"

# Use dev machine RSA key, and set port number to the ssh port set on the server
set :ssh_options, { forward_agent: true, port: stage[:port] }

# Allows the password prompt to work during deployment
default_run_options[:pty] = true

# Clean up old releases on each deploy
after "deploy:restart", "deploy:cleanup"
