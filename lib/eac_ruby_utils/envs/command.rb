# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs/base_command'

module EacRubyUtils
  module Envs
    class Command
      require_sub __FILE__, include_modules: true, require_mode: :kernel
      include ::EacRubyUtils::Envs::BaseCommand

      class << self
        # @param command [Array]
        # @return [Array]
        def sanitize_initialize_arguments(arguments)
          if arguments.one? && arguments.first.is_a?(Array)
            arguments.first
          elsif arguments.is_a?(Array)
            arguments
          else
            raise "Invalid argument command: #{arguments}|#{arguments.class}"
          end
        end
      end

      common_constructor :env, :args, :extra_options, default: [{}] do
        self.extra_options = extra_options.with_indifferent_access
        self.args = self.class.sanitize_initialize_arguments(args)
      end

      def append(args)
        duplicate_by_command(self.args + args)
      end

      def prepend(args)
        duplicate_by_command(args + self.args)
      end

      def to_s
        "#{args} [ENV: #{env}]"
      end

      # @return [String]
      def command_line_without_env
        c = args
        c = c.map { |x| escape(x) }.join(' ') if c.is_a?(Enumerable)
        append_chdir(append_envvars(c))
      end

      protected

      def duplicate(command, extra_options)
        self.class.new(env, command, extra_options)
      end

      private

      def duplicate_by_command(new_command)
        duplicate(new_command, extra_options)
      end

      def duplicate_by_extra_options(set_extra_options)
        duplicate(args, extra_options.merge(set_extra_options))
      end
    end
  end
end
