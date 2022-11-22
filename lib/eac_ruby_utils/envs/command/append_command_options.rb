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
          r = "cat #{Shellwords.escape(input_file)} | #{r}" if input_file
          r += ' > ' + Shellwords.escape(options[:output_file]) if options[:output_file]
          r
        end

        # @return [EacRubyUtils::Envs::Command, nil]
        def input
          options[:input]
        end

        # @return [Pathname,  nil]
        def input_file
          options[:input_file].if_present(&:to_pathname)
        end
      end
    end
  end
end
