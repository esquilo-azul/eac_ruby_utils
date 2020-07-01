# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'eac_ruby_utils/console/speaker'
require 'eac_ruby_utils/envs/command/extra_options'
require 'eac_ruby_utils/envs/process'
require 'eac_ruby_utils/envs/spawn'
require 'pp'
require 'shellwords'

module EacRubyUtils
  module Envs
    class Command
      include EacRubyUtils::Console::Speaker
      include EacRubyUtils::Envs::Command::ExtraOptions

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
            append_chdir(append_pipe(append_envvars(c)))
          ),
          options
        )
      end

      def execute!(options = {})
        options[:exit_outputs] = status_results.merge(options[:exit_outputs].presence || {})
        er = ExecuteResult.new(execute(options), options)
        return er.result if er.success?

        raise "execute! command failed: #{self}\n#{er.r.pretty_inspect}"
      end

      def execute(options = {})
        c = command(options)
        puts "BEFORE: #{c}".light_red if debug?
        t1 = Time.now
        r = ::EacRubyUtils::Envs::Process.new(c).to_h
        i = Time.now - t1
        puts "AFTER [#{i}]: #{c}".light_red if debug?
        r
      end

      def spawn(options = {})
        c = command(options)
        puts "SPAWN: #{c}".light_red if debug?
        ::EacRubyUtils::Envs::Spawn.new(c)
      end

      def system!(options = {})
        return if system(options)

        raise "system! command failed: #{self}"
      end

      def system(options = {})
        c = command(options)
        puts c.light_red if debug?
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

      class ExecuteResult
        attr_reader :r, :options

        def initialize(result, options)
          @r = result
          @options = options
        end

        def result
          return exit_code_zero_result if exit_code_zero?
          return expected_error_result if expected_error?

          raise 'Failed!'
        end

        def success?
          exit_code_zero? || expected_error?
        end

        private

        def exit_code_zero?
          r[:exit_code]&.zero?
        end

        def exit_code_zero_result
          r[options[:output] || :stdout]
        end

        def expected_error_result
          options[:exit_outputs][r[:exit_code]]
        end

        def expected_error?
          options[:exit_outputs].is_a?(Hash) && options[:exit_outputs].key?(r[:exit_code])
        end
      end
    end
  end
end
