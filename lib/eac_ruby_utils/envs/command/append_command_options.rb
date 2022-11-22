# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'shellwords'

module EacRubyUtils
  module Envs
    class Command
      class AppendCommandOptions
        enable_method_class
        common_constructor :command, :command_line, :options

        def result # rubocop:disable Metrics/AbcSize
          r = command_line
          r = input.command + ' | ' + r if input
          if options[:input_file]
            r = "cat #{Shellwords.escape(options[:input_file])}" \
              " | #{r}"
          end
          r += ' > ' + Shellwords.escape(options[:output_file]) if options[:output_file]
          r
        end

        # @return [EacRubyUtils::Envs::Command, nil]
        def input
          options[:input]
        end
      end
    end
  end
end
