# frozen_string_literal: true

# Base class for mailers that allows to keep mailer view files with mailer classes nearby.
class Base::Mailer < ActionMailer::Base
  layout "layout"
  prepend_view_path Rails.root.join("domains")
end
