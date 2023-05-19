# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'eac_ruby_utils/module_ancestors_variable/base'
require 'eac_ruby_utils/enumerables_methods'

module EacRubyUtils
  module ModuleAncestorsVariable
    class Hash < ::EacRubyUtils::ModuleAncestorsVariable::Base
      INITIAL_VALUE = {}.freeze

      def initialize(the_module, method_name)
        super(the_module, method_name, INITIAL_VALUE)
      end

      delegate(*::EacRubyUtils::EnumerablesMethods::HASH_READ_METHODS, to: :ancestors_variable)
      delegate(*::EacRubyUtils::EnumerablesMethods::HASH_WRITE_METHODS, to: :self_variable)
    end
  end
end
