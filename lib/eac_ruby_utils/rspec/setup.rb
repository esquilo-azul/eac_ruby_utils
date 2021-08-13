# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRubyUtils
  module Rspec
    module Setup
      extend ::ActiveSupport::Concern
      require_sub __FILE__, include_modules: true
    end
  end
end
