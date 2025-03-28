# frozen_string_literal: true

module Auzon
  # Base class for all serializers.
  class Serializer < Blueprinter::Base
    # @param attachment [ActiveStorage::Attached::One]
    # @param url_options [Hash]
    # @return [nil, String]
    def self.link_to_attachment(attachment, url_options)
      return if !attachment.attached?

      @url_helpers ||= Rails.application.routes.url_helpers
      @url_helpers.rails_storage_proxy_url(attachment, **url_options)
    end
  end
end
