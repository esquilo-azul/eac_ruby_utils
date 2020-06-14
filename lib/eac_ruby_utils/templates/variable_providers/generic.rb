# frozen_string_literal: true

require 'eac_ruby_utils/templates/variable_providers/base'

module EacRubyUtils
  module Templates
    module VariableProviders
      class Generic < ::EacRubyUtils::Templates::VariableProviders::Base
        class << self
          def accept?(variables_source)
            variables_source.is_a?(::Object)
          end
        end

        def variable_exist?(name)
          source.respond_to?(name)
        end

        def variable_fetch(name)
          source.send(name)
        end
      end
    end
  end
end
