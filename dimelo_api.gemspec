# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dimelo/api/version"

Gem::Specification.new do |s|
  s.name        = "dimelo_api"
  s.version     = Dimelo::API::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jean Boussier", "Renaud Morvan"]
  s.email       = ["jean.boussier@dimelo.com", "nel@w3fu.com"]
  s.homepage    = ""
  s.summary     = %q{Dimelo v2 API client}
  s.description = %q{Rest API client for Dimelo v2 plateform}

  s.rubyforge_project = "dimelo_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('activesupport', '>= 3.0.0') #could probably be made less restrictive
  s.add_dependency('activemodel', '>= 3.0.0')   #could probably be made less restrictive
  s.add_development_dependency('rake') #rspec 1 or 2
  s.add_development_dependency('rspec-core', '2.6.0') #rspec 1 or 2
  s.add_development_dependency('rspec', '2.6.0') #rspec 1 or 2
end
