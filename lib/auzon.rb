# frozen_string_literal: true

require "auzon/integration/railtie" if defined?(Rails::Railtie)

# Base code for Rails projects with Clean architecture and Domain-Driven Design.
module Auzon
  autoload :Integration, "auzon/integration"
  autoload :VERSION, "auzon/version"
end
