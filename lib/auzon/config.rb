# frozen_string_literal: true

module Auzon
  # Configuration options for Auzon-based objects.
  Config =
    Struct.new(:skip_attributes_from_params, keyword_init: true) do
      # @return [Hash<Symbol, Object>]
      def self.default_values
        {skip_attributes_from_params: []}
      end

      # @return [Array<Symbol>]
      # @raise [ArgumentError] When required property is not set
      def validate
        %i[skip_attributes_from_params].each do |prop|
          raise ArgumentError, "`#{prop}` should not be nil" if self[prop].nil?
        end
      end
    end
end
