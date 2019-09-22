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

  s.add_dependency "activemodel", ">= 4.2.0"
  s.add_dependency "activesupport", ">= 4.2.0"

  s.add_development_dependency "byebug"
  s.add_development_dependency "codecov"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
end
