# -*- encoding: utf-8 -*-
require File.expand_path("../lib/omniauth-owa/version", __FILE__)

Gem::Specification.new do |gem|
  gem.add_runtime_dependency "omniauth", "~> 1.0"
  gem.add_runtime_dependency "faraday", "~> 0.9"

  gem.add_development_dependency "nokogiri", "~> 1.6"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rack-test", "~> 0.6"
  gem.add_development_dependency "rspec", "~> 2.14"
  gem.add_development_dependency "webmock", "~> 1.17"

  gem.name = "omniauth-owa"
  gem.version = OmniAuth::Owa::VERSION
  gem.description = "Omniauth strategy to authenticate against an Outlook Web Access server."
  gem.summary = gem.description
  gem.email = ["kerryjbuckley@gmail.com"]
  gem.homepage = "http://github.com/kerryb/omniauth-owa"
  gem.authors = ["Kerry Buckley"]
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if gem.respond_to? :required_rubygems_version=
end
