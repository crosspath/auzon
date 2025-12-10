# frozen_string_literal: true

module Auzon
  # Base class for service objects and form objects.
  class Service < ActiveObject
    include ActiveModel::Validations

    # @return [Auzon::Service]
    def call
      return self unless valid?

      yield

      self
    end

    # @return [boolean]
    def success?
      errors.empty?
    end

    private

    # @param attribute [Symbol | String]
    # @param message [String]
    # @return [false]
    def add_error(attribute, message) # rubocop:disable Naming/PredicateMethod
      errors.add(attribute, message:)
      false
    end

    # @param other_errors [ActiveModel::Errors]
    # @return [ActiveModel::Errors] other_errors
    def merge_errors(other_errors)
      other_errors.each { |e| errors.objects.append(e) }
    end

    # @param service [Auzon::Service]
    # @return [Auzon::Service]
    def use_service(service)
      merge_errors(service.call.errors)

      service
    end
  end
end
