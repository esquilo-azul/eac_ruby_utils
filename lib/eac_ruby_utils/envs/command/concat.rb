# frozen_string_literal: true

require 'eac_ruby_utils/struct'

module EacRubyUtils
  module Envs
    class Command
      module Concat
        AND_OPERATOR = '&&'
        BEFORE_OPERATOR = ';'
        OR_OPERATOR = '||'
        PIPE_OPERATOR = '|'

        def concat(operator, other_command)
          duplicate_by_extra_options(concat: ::EacRubyUtils::Struct.new(
            operator: operator, command: other_command
          ))
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

        private

        def append_concat(command)
          extra_options[:concat].if_present(command) do |v|
            "#{command} #{v.operator} #{v.command.command}"
          end
        end
      end
    end
  end
end
