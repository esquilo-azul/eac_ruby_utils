# frozen_string_literal: true

require 'eac_ruby_utils/contextualizable'

module EacRubyUtils
  module Speaker
    include ::EacRubyUtils::Contextualizable

    class << self
      # @return [EacRubyUtils::Speaker::Receiver]
      def current_receiver
        context.current
      end
    end
  end
end
