# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs/command/execute_result'
require 'eac_ruby_utils/envs/execution_error'
require 'eac_ruby_utils/envs/process'
require 'eac_ruby_utils/envs/spawn'
require 'pp'
require 'shellwords'

module EacRubyUtils
  module Envs
    class Command
      require_sub __FILE__, include_modules: true

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

      def execute!(options = {})
        options[:exit_outputs] = status_results.merge(options[:exit_outputs].presence || {})
        er = ::EacRubyUtils::Envs::Command::ExecuteResult.new(execute(options), options)
        return er.result if er.success?

        raise ::EacRubyUtils::Envs::ExecutionError,
              "execute! command failed: #{self}\n#{er.r.pretty_inspect}"
      end

      def execute(options = {})
        c = command(options)
        debug_print("BEFORE: #{c}")
        t1 = Time.now
        r = ::EacRubyUtils::Envs::Process.new(c).to_h
        i = Time.now - t1
        debug_print("AFTER [#{i}]: #{c}")
        r
      end

      def spawn(options = {})
        c = command(options)
        debug_print("SPAWN: #{c}")
        ::EacRubyUtils::Envs::Spawn.new(c)
      end

      def system!(options = {})
        return if system(options)

        raise ::EacRubyUtils::Envs::ExecutionError, "system! command failed: #{self}"
      end

      def system(options = {})
        c = command(options)
        debug_print(c)
        Kernel.system(c)
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

      def debug?
        ENV['DEBUG'].to_s.strip != ''
      end

      # Print a message if debugging is enabled.
      def debug_print(message)
        message = message.to_s
        puts message.if_respond(:light_red, message) if debug?
      end

      def append_command_options(command, options)
        command = options[:input].command + ' | ' + command if options[:input]
        if options[:input_file]
          command = "cat #{Shellwords.escape(options[:input_file])}" \
            " | #{command}"
        end
        command += ' > ' + Shellwords.escape(options[:output_file]) if options[:output_file]
        command
      end

      def escape(arg)
        arg = arg.to_s
        m = /^\@ESC_(.+)$/.match(arg)
        m ? m[1] : Shellwords.escape(arg)
      end
    end
  end
end
