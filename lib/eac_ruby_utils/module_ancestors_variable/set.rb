# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'eac_ruby_utils/module_ancestors_variable/base'

module EacRubyUtils
  module ModuleAncestorsVariable
    class Set < ::EacRubyUtils::ModuleAncestorsVariable::Base
      INITIAL_VALUE = ::Set.new

      def initialize(the_module, method_name)
        super(the_module, method_name, INITIAL_VALUE)
      end

      delegate(*::EacRubyUtils::EnumerablesMethods::SET_READ_METHODS, to: :ancestors_variable)
      delegate(*::EacRubyUtils::EnumerablesMethods::SET_WRITE_METHODS, to: :self_variable)
    end
  end
end
