# frozen_string_literal: true

module Auzon
  # Helper methods for ActiveRecord Preloader.
  module PreloaderHelper
    private

    # Fetch associated records from database. Useful for "strict loading".
    # @see ActiveRecord::Associations::Preloader
    # @example
    #   preload_records([current_user], :contacts)
    #   preload_records([current_user], {posts: :comments})
    #   preload_records([current_user], [:contacts, {posts: :comments}])
    # @param source [Array<Class(ActiveRecord::Base)>]
    # @param associations [Symbol | String | Array<Symbol> | Hash]
    # @return [void]
    def preload_records(source, associations)
      ActiveRecord::Associations::Preloader.new(records: source, associations:).call
    end
  end
end
