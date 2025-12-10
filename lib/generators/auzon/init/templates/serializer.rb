# frozen_string_literal: true

# Base class for all serializers.
class Base::Serializer < Blueprinter::Base
  # @param attachment [ActiveStorage::Attached::One]
  # @param url_options [Hash]
  # @return [Hash<Symbol, String | Integer | Float | Time-like>]
  def self.attachment_metadata(attachment, url_options)
    Base::Serializers::Attachment.new(attachment, url_options).render if attachment.attached?
  end

  # @param attachment [ActiveStorage::Attached::One]
  # @param url_options [Hash]
  # @return [nil | String]
  def self.link_to_attachment(attachment, url_options)
    return if !attachment.attached?

    @url_helpers ||= Rails.application.routes.url_helpers
    @url_helpers.rails_storage_proxy_url(attachment, **url_options)
  end
end
