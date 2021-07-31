# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRubyUtils
  module Rspec
    class Setup
      require_sub __FILE__
      common_constructor :setup_obj

      def perform
        setup_obj.singleton_class.include(::EacRubyUtils::Rspec::Setup::Conditionals)
      end
    end
  end
end
