# frozen_string_literal: true

# Base class for form objects. You may use forms to apply data modifications from controllers.
# @see attribute types: https://api.rubyonrails.org/classes/ActiveModel/Type.html
class Base::Form < Auzon::Service
  # Include this module into your form class to require admin privileges.
  concern :Admin do
    included do
      include(Authorized)

      validate(:valid_admin?)
    end

    private

    # @return [boolean]
    def valid_admin?
      current_user&.admin? || add_error(:current_user, "unauthorized")
    end
  end

  # Include this module into your form class to require authorized state.
  concern :Authorized do
    included { validate(:valid_authorized?) }
  end

  # Include this module into your form class to add instance variable for created record.
  concern :CreateForm do
    included { attr_reader :object }
  end

  # Include this module into your form class to require unauthorized state.
  concern :NotAuthorized do
    included { validate(:valid_not_authorized?) }
  end

  attribute :current_user # Base::Model

  private

  # @return [boolean]
  def valid_authorized?
    current_user || add_error(:current_user, "User isn't authorized")
  end

  # @return [boolean]
  def valid_not_authorized?
    !current_user.nil? || add_error(:current_user, "User has been already authorized")
  end
end
