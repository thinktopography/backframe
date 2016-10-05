$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'rake/testtask'
require 'bundler/version'
require './lib/backframe'
require './lib/backframe/version'

Rake::TestTask.new do |t|
  t.libs << '.' << 'lib' << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end

desc "Build the gem"
task :build do
  system "gem build backframe.gemspec"
end

desc "install the gem"
task :install do
  system "gem install backframe-#{imagecache::VERSION}.gem"
end

desc "Build and release the gem"
task :release => :build do
  system "gem push backframe-#{imagecache::VERSION}.gem"
end