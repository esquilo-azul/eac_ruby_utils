# frozen_string_literal: true

require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  module Envs
    class Executable
      include ::EacRubyUtils::SimpleCache

      attr_reader :env, :name, :check_args

      def initialize(env, name, *check_args)
        @env = env
        @name = name
        @check_args = check_args
      end

      def exist?
        exist
      end

      def validate
        return nil if exist?

        "Program \"#{::Shellwords.join(executable_args)}\" not found in environment #{env}"
      end

      def validate!
        message = validate

        raise ProgramNotFoundError, message if message
      end

      def command(*command_args)
        validate!
        env.command(*executable_args, *command_args)
      end

      def executable_args
        executable_args_from_envvar || [name]
      end

      def executable_args_envvar
        "#{name}_command".variableize.upcase
      end

      def executable_args_from_envvar
        ENV[executable_args_envvar].if_present { |v| ::Shellwords.split(v) }
      end

      private

      def exist_uncached
        env.command(*executable_args, *check_args).execute!
        true
      rescue Errno::ENOENT
        false
      end

      class ProgramNotFoundError < ::StandardError; end
    end
  end
end
