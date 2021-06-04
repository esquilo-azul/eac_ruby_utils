# frozen_string_literal: true

require 'eac_ruby_utils/abstract_methods'

module EacRubyUtils
  module Speaker
    module Receiver
      extend ::EacRubyUtils::AbstractMethods

      def error(_string)
        raise_abstract_method(__FILE__)
      end

      def fatal_error(string)
        error(string)
        ::Kernel.exit 1 # rubocop:disable Rails/Exit
      end

      # @see EacRubyUtils::Speaker::Sender.input
      def input(_question, _options = {})
        raise_abstract_method(__FILE__)
      end

      def info(_string)
        raise_abstract_method(__FILE__)
      end

      def infom(_string)
        raise_abstract_method(__FILE__)
      end

      def infov(*_args)
        raise_abstract_method(__FILE__)
      end

      def out(_string = '')
        raise_abstract_method(__FILE__)
      end

      def puts(_string = '')
        raise_abstract_method(__FILE__)
      end

      def success(_string)
        raise_abstract_method(__FILE__)
      end

      def title(_string)
        raise_abstract_method(__FILE__)
      end

      def warn(_string)
        raise_abstract_method(__FILE__)
      end
    end
  end
end
