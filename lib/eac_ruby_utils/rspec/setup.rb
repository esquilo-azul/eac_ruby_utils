# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRubyUtils
  module Rspec
    module Setup
      require_sub __FILE__

      def self.extended(obj)
        obj.extend(::EacRubyUtils::Rspec::Setup::Conditionals)
      end
    end
  end
end
