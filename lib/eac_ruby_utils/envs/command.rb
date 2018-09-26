# frozen_string_literal: true

module EacRubyUtils
  module Envs
    class Command
      include EacRubyUtils::Console::Speaker

      def initialize(env, command)
        @env = env
        if command.count == 1 && command.first.is_a?(Array)
          @command = command.first
        elsif command.is_a?(Array)
          @command = command
        else
          raise "Invalid argument command: #{command}|#{command.class}"
        end
      end

      def append(args)
        self.class.new(@env, @command + args)
      end

      def prepend(args)
        self.class.new(@env, args + @command)
      end

      def to_s
        "#{@command} [ENV: #{@env}]"
      end

      def command(options = {})
        c = @command
        c = c.map { |x| escape(x) }.join(' ') if c.is_a?(Enumerable)
        c = @env.command_line(c)
        append_command_options(c, options)
      end

      def execute!(options = {})
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

      def system!(options = {})
        return if system(options)

        raise "system! command failed: #{self}"
      end

      def system(options = {})
        c = command(options)
        puts c.light_red if debug?
        Kernel.system(c)
      end

      private

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
        raise "#{arg}|#{arg.class}" unless arg.is_a?(String)

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
