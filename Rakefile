$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'bundler/version'
require './lib/backframe'
require './lib/backframe/version'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Build the gem"
task :build do
  system "gem build backframe.gemspec"
end

desc "install the gem"
task :install do
  system "gem install backframe-#{Backframe::VERSION}.gem"
end

desc "Build and release the gem"
task :release => :build do
  system "gem push backframe-#{Backframe::VERSION}.gem"
end
