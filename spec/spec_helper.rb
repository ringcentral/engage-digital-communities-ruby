begin
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end
require File.expand_path(File.dirname(__FILE__) + '/../lib/dimelo_ccp_api')
Dir[File.dirname(__FILE__) + "/examples/**/*.rb"].sort.each { |f| require f }
