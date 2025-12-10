# frozen_string_literal: true

require_relative "lib/auzon/version"

Gem::Specification.new do |spec|
  spec.name = "auzon"
  spec.version = Auzon::VERSION
  spec.summary = "Base code for Rails projects with Clean architecture and Domain-Driven Design."
  # spec.description = ""
  spec.authors = ["Evgeniy Nochevnov"]
  # spec.homepage = "https://..."
  # spec.license = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 3.3.0")

  spec.add_development_dependency("rspec-core", "~> 3.13")
  spec.add_development_dependency("rspec-expectations", "~> 3.13")
  spec.add_development_dependency("rubocop", "~> 1.81")
  spec.add_development_dependency("rubocop-performance", "~> 1.26")
  spec.add_development_dependency("rubocop-rails", "~> 2.33")
  spec.add_development_dependency("yard", "~> 0.9")

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = spec.homepage

  spec.files = %w[Gemfile auzon.gemspec] + Dir.glob("lib/**/*", base: __dir__)
  spec.require_paths = ["lib"]
end
