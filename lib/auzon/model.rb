# frozen_string_literal: true

module Auzon
  # Base class for ActiveRecord models, nothing more.
  class Model < ActiveRecord::Base
    primary_abstract_class
  end
end
