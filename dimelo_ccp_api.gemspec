# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dimelo/ccp/api/version"

Gem::Specification.new do |s|
  s.name        = "dimelo_ccp_api"
  s.version     = Dimelo::CCP::API::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jean Boussier", "Renaud Morvan"]
  s.email       = ["jean.boussier@dimelo.com", "nel@w3fu.com"]
  s.homepage    = ""
  s.summary     = %q{Dimelo CCP v2 API client}
  s.description = %q{Rest API client for Dimelo CCP v2 plateform}

  s.rubyforge_project = "dimelo_ccp_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('activesupport', '>= 3.0.0')
  s.add_dependency('activemodel', '>= 3.0.0')
  s.add_dependency('faraday')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.0')
end
