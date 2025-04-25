# frozen_string_literal: true

# Base class for ActiveRecord models, nothing more.
class Base::Model < ActiveRecord::Base
  primary_abstract_class
end
