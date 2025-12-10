# frozen_string_literal: true

module Auzon
  # @see attribute types: https://api.rubyonrails.org/classes/ActiveModel/Type.html
  class ActiveObject
    include ActiveModel::AttributeAssignment
    include ActiveModel::Attributes

    class << self
      # @param params [ActionController::Parameters]
      # @param options [Hash<Symbol | String | Object>] Extra arguments for initializer
      # @return [Base::ActiveObject] Instance of this class
      def new_from_params(params, **options)
        attr_names = attribute_names.map(&:to_sym) - Auzon.config.skip_attributes_from_params

        new(**params_values(params, attr_names), **options)
      end

      private

      # @param params [ActionController::Parameters]
      # @param attribute_names [Array<Symbol>]
      # @return [Hash<Symbol | Object>]
      def params_values(params, attribute_names)
        hash = params.send(:parameters).to_hash # rubocop:disable Style/Send

        hash.deep_symbolize_keys.slice(*attribute_names)
      end
    end

    # @param options [Hash<Symbol | String, Object>]
    def initialize(**options)
      @attributes = self.class._default_attributes.deep_dup
      assign_attributes(options)
    end

    # You should override this method in descendant classes.
    def call
      raise NotImplementedError
    end
  end
end
