# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'shellwords'

module EacRubyUtils
  module Console
    class DocoptRunner
      SUBCOMMAND_ARG = '<subcommand>'
      SUBCOMMAND_ARGS_ARG = '<subcommand-args>'
      SUBCOMMANDS_MACRO = '__SUBCOMMANDS__'

      def subcommands?
        source_doc.include?(SUBCOMMANDS_MACRO)
      end

      def check_subcommands
        return unless subcommands?
        singleton_class.include(SubcommandsSupport)
        return if singleton_class.method_defined?(:run)
        singleton_class.send(:alias_method, :run, :run_with_subcommand)
      end

      module SubcommandsSupport
        def run_with_subcommand
          if options.fetch(SUBCOMMAND_ARG)
            check_valid_subcommand
            subcommand.run
          else
            run_without_subcommand
          end
        end

        def subcommand
          @subcommand ||= subcommand_class_name(subcommand_name).constantize.new(
            argv: subcommand_args,
            program_name: subcommand_program,
            parent: self
          )
        end

        def target_doc
          super.gsub(SUBCOMMANDS_MACRO, "[#{SUBCOMMAND_ARG}] [#{SUBCOMMAND_ARGS_ARG}...]") +
            "\n" + subcommands_target_doc
        end

        def docopt_options
          super.merge(options_first: true)
        end

        def subcommand_class_name(subcommand)
          "#{self.class.name}::#{subcommand.underscore.camelize}"
        end

        def subcommand_args
          options.fetch(SUBCOMMAND_ARGS_ARG)
        end

        def subcommand_program
          subcommand_name
        end

        def subcommand_name
          options.fetch(SUBCOMMAND_ARG)
        end

        def available_subcommands
          setting_value(:subcommands).sort
        end

        def subcommands_target_doc
          available_subcommands.inject("Subcommands:\n") do |a, e|
            a + "  #{e}\n"
          end
        end

        def run_without_subcommand
          "Method #{__method__} should be overrided in #{self.class.name}"
        end

        protected

        def check_valid_subcommand
          return if available_subcommands.include?(subcommand_name)
          raise ::Docopt::Exit, "\"#{subcommand_name}\" is not a valid subcommand" \
            " (Valid: #{available_subcommands.join(', ')})"
        end
      end
    end
  end
end
