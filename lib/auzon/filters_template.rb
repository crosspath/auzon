# frozen_string_literal: true

module Auzon
  # DSL for declaring filters for Arel scopes.
  class FiltersTemplate
    # rubocop:disable Style/MutableConstant
    FilterConfiguration = Struct.new(:type, :options, :block, keyword_init: true)
    FilterEvaluator = Struct.new(:arel, :key, :val, :options, keyword_init: true)
    UnknownFiltersError = Class.new(ArgumentError)
    # rubocop:enable Style/MutableConstant

    class << self
      attr_reader :filters

      # @param type [Symbol]
      # @param extra_keys [Array<Symbol>]
      # @yieldreturn [Arel::Nodes::NodeExpression]
      # @return [void]
      def filter(type, *extra_keys, &block)
        define_singleton_method(type) do |key, **kwargs|
          @filters ||= {}
          @filters[key] = FilterConfiguration.new(type:, options: kwargs.slice(*extra_keys), block:)
        end
      end
    end

    # @param klass [ActiveRecord::Base]
    # @param values [Hash<Symbol, Object>]
    def initialize(klass, values)
      extra_keys = values.keys - (self.class.filters&.keys || [])
      raise UnknownFiltersError, "Unknown keys: #{extra_keys.sort.join(", ")}" if !extra_keys.empty?

      @klass = klass
      @values = values
    end

    # @return [Arel::Nodes::NodeExpression, nil]
    def to_arel
      arel_expressions.reduce { |acc, el| acc.and(el) }
    end

    private

    # @return [Array<Arel::Nodes::NodeExpression>]
    def arel_expressions
      arel = @klass.arel_table
      filters = self.class.filters || {}

      @values.filter_map { |key, val| expression_for_filter(arel, filters[key], key, val) }
    end

    # @param arel
    # @param filter [Base::FiltersTemplate::FilterConfiguration]
    # @param key [Symbol]
    # @param val [Object]
    # @return [Arel::Nodes::NodeExpression]
    def expression_for_filter(arel, filter, key, val)
      FilterEvaluator.new(arel:, key:, val:, options: filter.options).instance_eval(&filter.block)
    end
  end
end
