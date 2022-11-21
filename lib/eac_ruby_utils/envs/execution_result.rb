# frozen_string_literal: true

require 'eac_ruby_utils/envs/execution_error'

module EacRubyUtils
  module Envs
    class ExecutionResult
      attr_reader :r, :options

      def initialize(result, options)
        @r = result
        @options = options
      end

      def result
        return exit_code_zero_result if exit_code_zero?
        return expected_error_result if expected_error?

        raise ::EacRubyUtils::Envs::ExecutionError, 'Failed!'
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
