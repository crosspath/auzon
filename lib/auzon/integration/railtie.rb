# frozen_string_literal: true

module Auzon
  module Integration
    # Configuration for Rails application.
    class Railtie < Rails::Railtie
      initializer "auzon.controller_methods" do
        # For ActionController::API & ActionController::Base.
        ActiveSupport.on_load(:action_controller) { include Auzon::Integration::ControllerMethods }

        # For ActionController::API.
        ActiveSupport.on_load(:action_controller_api) do
          include Auzon::Integration::ControllerApiMethods
        end
      end
    end
  end
end
