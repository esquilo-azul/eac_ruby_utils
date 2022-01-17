# frozen_string_literal: true

require 'eac_ruby_utils/speaker/receiver'

module EacRubyUtils
  module Rspec
    class StubSpeaker
      include ::EacRubyUtils::Speaker::Receiver

      def error(_string); end

      def fatal_error(string)
        error(string)
        raise('Fatal error')
      end

      # @see EacRubyUtils::Speaker::Sender.input
      def input(_question, _options = {})
        raise 'Input requested'
      end

      def info(_string); end

      def infom(_string); end

      def infov(*_args); end

      def out(_string = ''); end

      def puts(_string = ''); end

      def success(_string); end

      def title(_string); end

      def warn(_string); end
    end
  end
end
