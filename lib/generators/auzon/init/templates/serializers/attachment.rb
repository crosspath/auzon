# frozen_string_literal: true

# Helper class for serializing records of attached files.
class Base::Serializers::Attachment
  # @param attachment [ActiveStorage::Attached::One]
  # @param url_options [Hash]
  def initialize(attachment, url_options)
    @attachment = attachment
    @blob = attachment.blob
    @meta = @blob.metadata
    @url_helpers = Rails.application.routes.url_helpers
    @url_options = url_options
  end

  # @return [Hash<Symbol, String | Integer | Float | Time-like>]
  def render
    sort_keys(common_fields.merge(viewable? ? links_to_viewable_files : links_to_documents))
  end

  private

  IN_MEGABYTES = 1024.0 * 1024.0
  VIEWABLE_TYPES = %w[image video].freeze

  private_constant :IN_MEGABYTES, :VIEWABLE_TYPES

  # @param attachment_variant [ActiveStorage::Attached::One, ActiveStorage::VariantWithRecord]
  # @return [String]
  def attachment_url(attachment_variant)
    @url_helpers.rails_storage_proxy_url(attachment_variant, **@url_options)
  end

  # @return [Hash]
  def common_fields
    {
      created_at: @blob.created_at,
      file_size: @blob.byte_size / IN_MEGABYTES, # megabytes
      mime_type: @blob.content_type,
      original_name: @blob.filename.to_s,
    }
  end

  # @return [Hash]
  def links_to_documents
    {document: attachment_url(@attachment)}
  end

  # @return [Hash]
  def links_to_viewable_files
    {
      full: attachment_url(@attachment),
      height: @meta[:height],
      thumbnail: thumbnail_url,
      width: @meta[:width],
    }
  end

  # @return [Hash]
  def sort_keys(hash)
    hash.sort_by(&:first).to_h
  end

  # @return [String, nil]
  def thumbnail_url
    attachment_settings = @attachment.record.attachment_reflections[@attachment.name]
    return if attachment_settings.nil? || !attachment_settings.named_variants.key?(:thumb)

    attachment_url(@attachment.representation(:thumb))
  end

  # @return [boolean]
  def viewable?
    VIEWABLE_TYPES.include?(@blob.content_type.split("/", 2).first)
  end
end
