# frozen_string_literal: true

module Auzon
  # DSL for declaring filters for Arel scopes.
  # @example
  #   class Base::QueryFilters < Auzon::FiltersTemplate
  #     # SQL examples here given for PostgreSQL.
  #     # SQL: "#{col} = #{val}"
  #     filter(:eq) { val.present? && arel[key].eq(val) }
  #
  #     # SQL: "#{col} ILIKE #{val}"
  #     filter(:substring, :fixed_begin, :fixed_end) do
  #       next if val.blank?
  #
  #       pattern =
  #         [
  #           options[:fixed_begin] ? "" : "%",
  #           val.gsub(/[%_\\]/, "\\\\\\0"), # Prepend "\\" before characters "%", "_", "\\".
  #           options[:fixed_end] ? "" : "%",
  #         ].join
  #
  #       arel[key].matches(pattern)
  #     end
  #
  #     # SQL: "#{col} ~* #{pattern}"
  #     filter(:regexp, :column, :pattern) do
  #       val.present? && arel[options[:column]].matches_regexp(options[:pattern], false)
  #     end
  #   end
  #
  #   # Table columns: {id: Integer, role: String, first_name: String, job_position: String}
  #   class Users::Queries::Accounts::Index < Auzon::Query
  #     class Filters < Base::QueryFilters
  #       eq :id
  #       eq :role
  #       substring :first_name, fixed_begin: true, fixed_end: false
  #       regexp :director, column: "job_position", pattern: "^C.O$|^Head" # CEO, CTO, etc
  #     end
  #
  #     include Filterable
  #
  #     # @return [Users::Account::ActiveRecord_Relation]
  #     def call
  #       apply_filters(Users::Account, Filters)
  #     end
  #   end
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
      # @yieldreturn [Arel::Nodes::NodeExpression | false | nil]
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

    # @return [Arel::Nodes::NodeExpression | nil]
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

    # @param arel [Arel::Table]
    # @param filter [Base::FiltersTemplate::FilterConfiguration]
    # @param key [Symbol]
    # @param val [Object]
    # @return [Arel::Nodes::NodeExpression]
    def expression_for_filter(arel, filter, key, val)
      FilterEvaluator.new(arel:, key:, val:, options: filter.options).instance_eval(&filter.block)
    end
  end
end
