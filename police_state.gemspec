$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "police_state/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "police_state"
  s.version     = PoliceState::VERSION
  s.authors     = ["Ian Purvis"]
  s.email       = ["ian@purvisresearch.com"]
  s.summary     = "Lightweight state machine for Active Record and Active Model."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activemodel", ">= 5.2.0"
  s.add_dependency "activesupport", ">= 5.2.0"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "activerecord-nulldb-adapter"
  s.add_development_dependency "debug", ">= 1.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-cobertura"
end
