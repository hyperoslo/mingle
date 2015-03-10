$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mingle/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mingle"
  s.version     = Mingle::VERSION
  s.authors     = ["Johannes Gorset", "Tim Kurvers", "Sindre Moen"]
  s.email       = ["johannes@hyper.no", "tim@hyper.no", "sindre@hyper.no"]
  s.homepage    = "https://github.com/hyperoslo/mingle"
  s.summary     = "Social media integration for Ruby on Rails"
  s.description = "Facebook, Twitter and Instagram integration for Ruby on Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "spec/factories/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "twitter", "~> 5.5"
  s.add_dependency "fb_graph", "~> 2.7"
  s.add_dependency "instagram", "~> 1.0"
  s.add_dependency "google-api-client", "~> 0.7"
  s.add_dependency "mini_magick", "~> 4.1.0"
  s.add_dependency "refile", "~> 0.5"

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "rspec-rails", "~> 3.0"
  s.add_development_dependency "webmock", "~> 1.18"
  s.add_development_dependency "factory_girl_rails", "~> 4.4"
  s.add_development_dependency "sidekiq", "~> 3.0"
  s.add_development_dependency "pry", "~> 0.10"
end
