# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs/base_command'

module EacRubyUtils
  module Envs
    class CompositeCommand
      include ::EacRubyUtils::Envs::BaseCommand

      enable_listable
      lists.add_string :operator, '&&' => :and, ';' => :before, '||' => :or, '|' => :pipe

      common_constructor :operator, :left_command, :right_command do
        self.operator = self.class.lists.operator.value_validate!(operator.to_s)
      end

      # @return [EacRubyUtils::Envs::BaseEnv]
      delegate :env, to: :left_command

      # @return [String]
      def command_line_without_env(_options = {})
        ::Shellwords.join(['bash', '-c', bash_command])
      end

      # @return [String]
      def bash_command
        ['set', '-euo', 'pipefail', OPERATOR_BEFORE, left_command_line, operator,
         right_command.command].join(' ')
      end

      def left_command_line
        left_command.command
      end
    end
  end
end
