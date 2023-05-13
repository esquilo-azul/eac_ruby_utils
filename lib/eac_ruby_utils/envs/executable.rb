# frozen_string_literal: true

require 'eac_ruby_utils/listable'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  module Envs
    class Executable
      include ::EacRubyUtils::Listable
      include ::EacRubyUtils::SimpleCache

      lists.add_symbol :option, :check_args, :auto_validate

      DEFAULT_AUTO_VALIDATE = true

      attr_reader :env, :name, :options

      def initialize(env, name, *check_args)
        @env = env
        @name = name
        self.options = self.class.lists.option.hash_keys_validate!(check_args.extract_options!)
        options[OPTION_CHECK_ARGS] = check_args unless options.key?(OPTION_CHECK_ARGS)
        options.freeze
      end

      def auto_validate?
        options.key?(OPTION_AUTO_VALIDATE) ? options[OPTION_AUTO_VALIDATE] : DEFAULT_AUTO_VALIDATE
      end

      def check_args
        options[OPTION_CHECK_ARGS]
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
        validate! if auto_validate?
        env.command(*executable_args, *command_args)
      end

      def executable_args
        executable_args_from_envvar || executable_args_from_name
      end

      def executable_args_envvar
        "#{name}_command".variableize.upcase
      end

      def executable_args_from_envvar
        ENV[executable_args_envvar].if_present { |v| ::Shellwords.split(v) }
      end

      # @return [Enumerable<String>]
      def executable_args_from_name
        ::Shellwords.split(name)
      end

      private

      attr_writer :options

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
