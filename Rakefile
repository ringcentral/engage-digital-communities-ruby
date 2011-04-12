require 'rake'
require 'rspec/core/rake_task'

desc 'Default: run rspec.'
task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end