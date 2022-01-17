# frozen_string_literal: true

require 'eac_ruby_utils/abstract_methods'

module EacRubyUtils
  module Speaker
    module Receiver
      extend ::ActiveSupport::Concern
      extend ::EacRubyUtils::AbstractMethods

      module ClassMethods
        def on(*args, &block)
          ::EacRubyUtils::Speaker.context.on(new(*args), &block)
        end
      end

      def error(_string)
        raise_abstract_method(__method__)
      end

      def fatal_error(string)
        error(string)
        ::Kernel.exit 1 # rubocop:disable Rails/Exit
      end

      # @see EacRubyUtils::Speaker::Sender.input
      def input(_question, _options = {})
        raise_abstract_method(__method__)
      end

      def info(_string)
        raise_abstract_method(__method__)
      end

      def infom(_string)
        raise_abstract_method(__method__)
      end

      def infov(*_args)
        raise_abstract_method(__method__)
      end

      def out(_string = '')
        raise_abstract_method(__method__)
      end

      def puts(_string = '')
        raise_abstract_method(__method__)
      end

      def success(_string)
        raise_abstract_method(__method__)
      end

      def title(_string)
        raise_abstract_method(__method__)
      end

      def warn(_string)
        raise_abstract_method(__method__)
      end
    end
  end
end
