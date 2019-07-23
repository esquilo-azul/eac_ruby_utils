# frozen_string_literal: true

module EacRubyUtils
  module Listable
    module InstanceMethods
      LISTABLE_INSTANCE_VALUE_METHODS = %w[label description].freeze

      def method_missing(name, *args, &block)
        list, method = parse_method(name)
        list && method ? list.instance_value(self).send(method) : super
      end

      def respond_to_missing?(name, include_all = false)
        list, method = parse_method(name)
        list && method ? true : super
      end

      private

      def parse_method(method)
        self.class.lists.acts_as_listable_items.each do |item, list|
          LISTABLE_INSTANCE_VALUE_METHODS.each do |m|
            return [list, m] if method.to_s == "#{item}_#{m}"
          end
        end
        [nil, nil]
      end
    end
  end
end
