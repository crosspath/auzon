# frozen_string_literal: true

require "action_controller"
require "active_record"

require_relative "../lib/auzon"

module RSpecMethods
  def spec
    @spec ||= self.class.parent_groups.last
  end

  def spec_class
    @spec_class ||= spec.metadata[:described_class] || spec.metadata[:description].constantize
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!

  # @see rspec-rails, lib/rspec/rails/configuration.rb
  config.filter_gems_from_backtrace(
    "actionmailer",
    "actionpack",
    "actionview",
    "activejob",
    "activemodel",
    "activerecord",
    "activesupport"
  )

  config.include(RSpecMethods)
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
end
