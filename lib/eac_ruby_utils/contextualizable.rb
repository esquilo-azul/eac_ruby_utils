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
      delegate :context, to: :class
    end
  end
end
