begin
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end
ACCESS_TOKEN = "6265b6a77b826145b102985eecb0b9da"
require File.expand_path(File.dirname(__FILE__) + '/../lib/dimelo_api')
Dir[File.dirname(__FILE__) + "/examples/**/*.rb"].sort.each { |f| require f }
