require 'rspec'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
Dir["#{root}/lib/**/*.rb"].each{ |f| require f }

Rspec.configure do |c|
  c.mock_with :rspec
end