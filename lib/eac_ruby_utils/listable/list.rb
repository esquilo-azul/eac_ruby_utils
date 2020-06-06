# frozen_string_literal: true

module EacRubyUtils
  module Listable
    class List
      attr_reader :item

      def initialize(lists, item, labels)
        @lists = lists
        @item = item
        @values = build_values(labels)
        apply_constants
      end

      def each_value(&block)
        values.each(&block)
      end

      def values
        @values.values.map(&:value)
      end

      def options
        @values.values.map { |v| [v.label, v.value] }
      end

      def method_missing(name, *args, &block)
        list = find_list_by_method(name)
        list || super
      end

      def respond_to_missing?(name, include_all = false)
        find_list_by_method(name) || super
      end

      def i18n_key
        "eac_ruby_utils.listable.#{class_i18n_key}.#{item}"
      end

      def instance_value(instance)
        v = instance.send(item)
        return @values[v] if @values.key?(v)

        raise "List value unkown: #{v} (Source: #{@lists.source}, Item: #{item})"
      end

      def value_valid?(value)
        values.include?(value)
      end

      def value_validate!(value, error_class = ::StandardError)
        value_valid?(value) ||
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
        @values.values.each do |v|
          return v if method.to_s == "value_#{v.key}"
        end
        nil
      end

      def constants
        labels.each_with_index.map { |v, i| ["#{item.upcase}_#{v.upcase}", values[i]] }
      end

      def apply_constants
        @values.values.each do |v|
          @lists.source.const_set(v.constant_name, v.value)
        end
      end

      def build_values(labels)
        vs = {}
        parse_labels(labels).each do |value, key|
          v = Value.new(self, value, key)
          vs[v.value] = v
        end
        vs
      end
    end
  end
end
