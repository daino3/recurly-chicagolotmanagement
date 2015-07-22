require 'rake'
require_relative './config/environment'
require 'active_support/core_ext'
require "sinatra/activerecord/rake"

desc 'Start IRB with application environment loaded'
task "console" do
  exec "irb -r./config/environment"
end

namespace :db do
  desc "Create the database at #{DB_NAME}"
  # TODO: Remove once AR fully implemented
  task :create_db do
    puts "Creating database #{DB_NAME} if it doesn't exist..."
    exec("createdb #{DB_NAME}")
  end

  # TODO: Remove once AR fully implemented
  desc "Drop the database at #{DB_NAME}"
  task :drop_db do
    puts "Dropping database #{DB_NAME}..."
    exec("dropdb #{DB_NAME}")
  end
end