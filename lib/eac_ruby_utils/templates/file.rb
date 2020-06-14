# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'eac_ruby_utils/simple_cache'
require 'eac_ruby_utils/templates/variable_providers/base'
require 'eac_ruby_utils/templates/variable_providers/entries_reader'

module EacRubyUtils
  module Templates
    class File
      include ::EacRubyUtils::SimpleCache

      VARIABLE_DELIMITER = ::Regexp.quote('%%')
      VARIABLE_PATTERN = /#{VARIABLE_DELIMITER}([a-z0-9\._]*)#{VARIABLE_DELIMITER}/i.freeze

      attr_reader :path

      def initialize(path)
        @path = path
      end

      # +variables_provider+ A [Hash] or object which responds to +read_entry(entry_name)+.
      def apply(variables_source)
        variables_provider = build_variables_provider(variables_source)
        variables.inject(content) do |a, e|
          a.gsub(variable_pattern(e), variables_provider.variable_value(e).to_s)
        end
      end

      def apply_to_file(variables_source, output_file_path)
        ::File.write(output_file_path, apply(variables_source))
      end

      private

      def variables_uncached
        content.scan(VARIABLE_PATTERN).map(&:first).map do |name|
          sanitize_variable_name(name)
        end.to_set
      end

      def content_uncached
        ::File.read(path)
      end

      def sanitize_variable_name(variable_name)
        variable_name.to_s.downcase
      end

      def build_variables_provider(variables_source)
        return HashVariablesProvider.new(variables_source) if variables_source.is_a?(::Hash)
        return ::EacRubyUtils::Templates::VariableProviders::EntriesReader.new(variables_source) if
        variables_source.respond_to?(:read_entry)

        raise "Variables provider not found for #{variables_source}"
      end

      def variable_pattern(name)
        /#{VARIABLE_DELIMITER}#{::Regexp.quote(name)}#{VARIABLE_DELIMITER}/i
      end

      class HashVariablesProvider < ::EacRubyUtils::Templates::VariableProviders::Base
        def initialize(source)
          super(source.with_indifferent_access)
        end

        def variable_exist?(name)
          source.key?(name)
        end

        def variable_fetch(name)
          source.fetch(name)
        end
      end
    end
  end
end
