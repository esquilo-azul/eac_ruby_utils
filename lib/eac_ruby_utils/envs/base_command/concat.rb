# frozen_string_literal: true

require 'eac_ruby_utils/struct'

module EacRubyUtils
  module Envs
    module BaseCommand
      module Concat
        AND_OPERATOR = '&&'
        BEFORE_OPERATOR = ';'
        OR_OPERATOR = '||'
        PIPE_OPERATOR = '|'

        # @param operator [Symbol]
        # @return [EacRubyUtils::Envs::CompositeCommand]
        def concat(operator, other_command)
          require 'eac_ruby_utils/envs/composite_command'
          ::EacRubyUtils::Envs::CompositeCommand.new(operator, self, other_command)
        end

        # @return [EacRubyUtils::Envs::Command]
        def and(other_command)
          concat(AND_OPERATOR, other_command)
        end

        # @return [EacRubyUtils::Envs::Command]
        def before(other_command)
          concat(BEFORE_OPERATOR, other_command)
        end

        def or(other_command)
          concat(OR_OPERATOR, other_command)
        end

        def pipe(other_command)
          concat(PIPE_OPERATOR, other_command)
        end
      end
    end
  end
end
