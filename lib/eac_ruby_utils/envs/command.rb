# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'shellwords'

module EacRubyUtils
  module Envs
    class Command
      require_sub __FILE__, include_modules: true, require_dependency: true

      def initialize(env, command, extra_options = {})
        @env = env
        @extra_options = extra_options.with_indifferent_access
        if command.count == 1 && command.first.is_a?(Array)
          @command = command.first
        elsif command.is_a?(Array)
          @command = command
        else
          raise "Invalid argument command: #{command}|#{command.class}"
        end
      end

      def args
        @command
      end

      def append(args)
        duplicate_by_command(@command + args)
      end

      def prepend(args)
        duplicate_by_command(args + @command)
      end

      def to_s
        "#{@command} [ENV: #{@env}]"
      end

      def command(options = {})
        c = @command
        c = c.map { |x| escape(x) }.join(' ') if c.is_a?(Enumerable)
        append_command_options(
          @env.command_line(
            append_chdir(append_concat(append_envvars(c)))
          ),
          options
        )
      end

      protected

      def duplicate(command, extra_options)
        self.class.new(@env, command, extra_options)
      end

      private

      attr_reader :extra_options

      def duplicate_by_command(new_command)
        duplicate(new_command, @extra_options)
      end

      def duplicate_by_extra_options(set_extra_options)
        duplicate(@command, @extra_options.merge(set_extra_options))
      end

      def escape(arg)
        arg = arg.to_s
        m = /^\@ESC_(.+)$/.match(arg)
        m ? m[1] : Shellwords.escape(arg)
      end
    end
  end
end
