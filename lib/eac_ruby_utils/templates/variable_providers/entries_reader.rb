# frozen_string_literal: true

require 'eac_ruby_utils/templates/variable_providers/base'

module EacRubyUtils
  module Templates
    module VariableProviders
      class EntriesReader < ::EacRubyUtils::Templates::VariableProviders::Base
        class << self
          def accept?(variables_source)
            variables_source.respond_to?(:read_entry)
          end
        end

        def variable_exist?(_name)
          true
        end

        def variable_fetch(name)
          source.read_entry(name)
        end
      end
    end
  end
end
