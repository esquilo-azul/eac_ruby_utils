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

        "Program \"#{name}\" not found in environment #{env}"
      end

      def validate!
        message = validate

        raise ProgramNotFoundError, message if message
      end

      def command
        validate!
        env.command(name)
      end

      private

      def exist_uncached
        env.command(name, *check_args).execute!
        true
      rescue Errno::ENOENT
        false
      end

      class ProgramNotFoundError < ::StandardError; end
    end
  end
end
