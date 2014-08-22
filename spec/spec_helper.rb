begin
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end
ACCESS_TOKEN = "55d8ac94bfb93a71f1fb7ee730079e8a"
require File.expand_path(File.dirname(__FILE__) + '/../lib/dimelo_api')
Dir[File.dirname(__FILE__) + "/examples/**/*.rb"].sort.each { |f| require f }
