# frozen_string_literal: true

require 'eac_ruby_utils/require_sub'

module EacRubyUtils
  module Fs
    include ::EacRubyUtils::Fs::Extname

    ::EacRubyUtils.require_sub __FILE__
  end
end
