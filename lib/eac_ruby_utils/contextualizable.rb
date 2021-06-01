# frozen_string_literal: true

require 'eac_ruby_utils/context'

module EacRubyUtils
  module Contextualizable
    common_concern

    module ClassMethods
      def context
        @context ||= ::EacRubyUtils::Context.new
      end
    end

    module InstanceMethods
      def context
        self.class.context
      end
    end
  end
end
