# frozen_string_literal: true

module Auzon
  module Integration
    # Configuration for Rails application.
    class Railtie < Rails::Railtie
      initializer "auzon.controller_methods" do
        [ActionController::API, ActionController::Base].each do |controller|
          controller.include(Auzon::Integration::ControllerMethods)
        end
        ActionController::API.include(Auzon::Integration::ControllerApiMethods)
      end
    end
  end
end
