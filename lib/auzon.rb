# frozen_string_literal: true

require "auzon/integration/railtie" if defined?(Rails::Railtie)

# Base code for Rails projects with Clean architecture and Domain-Driven Design.
module Auzon
  autoload :ActiveObject, "auzon/active_object"
  autoload :Config, "auzon/config"
  autoload :FiltersTemplate, "auzon/filters_template"
  autoload :Integration, "auzon/integration"
  autoload :Mailer, "auzon/mailer"
  autoload :Model, "auzon/model"
  autoload :Query, "auzon/query"
  autoload :Serializer, "auzon/serializer"
  autoload :Service, "auzon/service"
  autoload :VERSION, "auzon/version"

  class << self
    # Read configuration for some base classes.
    def config
      @config ||= Auzon::Config.new(**Auzon::Config.default_values)
    end

    # @yieldparam config [Auzon::Config]
    # @yieldreturn [void]
    # @return [void]
    def configure
      yield(config)
      config.validate
    end
  end
end
