# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'shellwords'

module EacRubyUtils
  module Envs
    module BaseCommand
      require_sub __FILE__

      common_concern do
        enable_abstract_methods
        include ::EacRubyUtils::Envs::BaseCommand::Concat
        include ::EacRubyUtils::Envs::BaseCommand::Debugging
        include ::EacRubyUtils::Envs::BaseCommand::Execution
        include ::EacRubyUtils::Envs::BaseCommand::ExtraOptions
      end

      # @return [EacRubyUtils::Envs::BaseEnv]
      def env
        raise_abstract_method __method__
      end

      def command(options = {})
        append_command_options(
          env.command_line(command_line_without_env),
          options
        )
      end

      # @return [String]
      def command_line_without_env(_options = {})
        raise_abstract_method __method__
      end

      private

      def escape(arg)
        arg = arg.to_s
        m = /^@ESC_(.+)$/.match(arg)
        m ? m[1] : Shellwords.escape(arg)
      end
    end
  end
end
