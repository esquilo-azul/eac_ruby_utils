# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/require_sub'

module EacRubyUtils
  module Rspec
    require_sub __FILE__, include_modules: true
  end
end
