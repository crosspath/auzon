# frozen_string_literal: true

module Auzon
  # Base class for mailers that allows to keep mailer view files with mailer files nearby.
  class Mailer < ActionMailer::Base
    layout "layout"
    prepend_view_path Rails.root.join("domains")
  end
end
