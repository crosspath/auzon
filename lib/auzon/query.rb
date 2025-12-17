# frozen_string_literal: true

module Auzon
  # Base class for retrieving and aggregating records from database.
  class Query < ActiveObject
    include Auzon::PreloaderHelper

    concern :Filterable do
      included do
        attribute :filters # Hash<Symbol, Object>

        private

        # @param scope [Class(ActiveRecord::Base) | ActiveRecord::Relation]
        # @param filters_class [Class(Auzon::FiltersTemplate)]
        # @param model_class [Class(ActiveRecord::Base) | nil] Optional
        # @return [ActiveRecord::Relation]
        def apply_filters(scope, filters_class, model_class = nil)
          scope = scope.all if scope.is_a?(ActiveRecord::Base)
          return scope if filters.blank?

          model_class ||= scope.model if scope.respond_to?(:model)
          raise ArgumentError, "Please specify `model_class`" if model_class.nil?

          conditions = filters_class.new(model_class, filters).to_arel

          conditions ? scope.where(conditions) : scope
        end
      end
    end

    # Concern with constants should be defined as module.
    module Paginatable
      # :nodoc:
      def self.included(base)
        base.class_eval do
          attribute(:limit, :integer)
          attribute(:offset, :integer)
        end
      end

      private

      NOT_SET = [0, nil].freeze

      private_constant :NOT_SET

      # @param scope [ActiveRecord::Relation]
      # @return [Hash {objects: Array<Class(ActiveRecord::Base)>, total: Integer}]
      def paginate(scope)
        objects = scope.limit(limit).offset(offset).to_a
        total = select_all_records? ? objects.size : scope.reselect(nil).count

        {objects:, total:}
      end

      # @return [boolean]
      def select_all_records?
        NOT_SET.include?(limit) && NOT_SET.include?(offset)
      end
    end

    concern :Searchable do
      included do
        attribute :search, :string

        def initialize(**)
          super

          search&.gsub!(/%|\?/) { |char| "\\#{char}" } # Replace special characters for LIKE/ILIKE.
        end
      end
    end
  end
end
