# frozen_string_literal: true

module EacRubyUtils
  module Immutable
    module InstanceMethods
      def immutable_constructor_args
        []
      end

      private

      def immutable_values_get
        @immutable_values || {}
      end

      def immutable_values_set(new_values)
        @immutable_values = new_values
      end
    end
  end
end
