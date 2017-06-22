$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "police_state/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "police_state"
  s.version     = PoliceState::VERSION
  s.authors     = ["ipurvis"]
  s.email       = ["ian.c.purvis@gmail.com"]
  s.summary     = "Simple state machining with ActiveRecord."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
