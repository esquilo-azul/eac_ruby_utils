# frozen_string_literal: true

require 'eac_ruby_utils/listable/item'

module EacRubyUtils
  module Listable
    class List
      BLANK_VALUE = nil
      BLANK_KEY = :__blank

      attr_reader :item

      def initialize(lists, item, labels)
        @lists = lists
        @item = item
        @values = build_values(labels)
        apply_constants
      end

      def blank_value
        @blank_value ||= ::EacRubyUtils::Listable::Item.new(self, BLANK_VALUE, BLANK_KEY, false)
      end

      def each_value(&block)
        values.each(&block)
      end

      # @return [EacRubyUtils::Listable::Item, nil]
      def item_by_value(value)
        @values.values.find { |item| item.value == value }
      end

      def values
        @values.values.map(&:value)
      end

      def values_with_blank
        [blank_value.value] + values
      end

      def options
        @values.values.map(&:to_option)
      end

      def options_with_blank
        [blank_value.to_option] + options
      end

      def method_missing(name, *args, &block)
        list = find_list_by_method(name)
        list || super
      end

      def respond_to_missing?(name, include_all = false)
        find_list_by_method(name) || super
      end

      def hash_keys_validate!(hash, error_class = ::StandardError)
        hash.each_key { |key| value_validate!(key, error_class) }
        hash
      end

      def i18n_key
        "eac_ruby_utils.listable.#{class_i18n_key}.#{item}"
      end

      # @return [EacRubyUtils::Listable::Item, nil]
      def instance_value(instance)
        v = instance.send(item)
        return blank_value if v.blank?
        return @values[v] if @values.key?(v)

        raise "List value unkown: \"#{v}\" (Source: #{@lists.source}, Item: #{item}, Instance: " \
          "#{instance.to_debug}, Values: #{@values.keys})"
      end

      def value_valid?(value)
        values.include?(value)
      end

      def value_validate!(value, error_class = ::StandardError)
        return value if value_valid?(value)

        raise(error_class, "Invalid value: \"#{value}\" (Valid: #{values_to_s})")
      end

      def values_to_s
        values.map { |v| "\"#{v}\"" }.join(', ')
      end

      private

      def class_i18n_key
        @lists.source.name.underscore.to_sym
      end

      def find_list_by_method(method)
        @values.each_value do |v|
          return v if method.to_s == "value_#{v.key}"
        end
        nil
      end

      def constants
        labels.each_with_index.map { |v, i| ["#{item.upcase}_#{v.upcase}", values[i]] }
      end

      def apply_constants
        @values.each_value do |v|
          @lists.source.const_set(v.constant_name, v.value)
        end
      end

      def build_values(labels)
        vs = {}
        parse_labels(labels).each do |value, key|
          v = ::EacRubyUtils::Listable::Item.new(self, value, key)
          vs[v.value] = v
        end
        vs
      end
    end
  end
end
