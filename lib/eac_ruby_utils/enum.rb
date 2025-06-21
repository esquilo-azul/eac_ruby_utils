# frozen_string_literal: true

require 'eac_ruby_utils/inflector'

module EacRubyUtils
  # Similar to Java's enum type (https://docs.oracle.com/javase/tutorial/java/javaOO/enum.html).
  class Enum
    class << self
      def enum(key, *args, &block)
        value = Value.new(self, key, args, &block)
        raise ::ArgumentError, "#{self} already has a value with key=#{value.key}" if
          value_set.include?(value)

        value_set << value.apply

        self
      end

      def values
        value_set.map(&:value)
      end

      private

      def value_set
        @value_set ||= []
      end
    end

    attr_reader :key

    protected

    def initialize(key)
      @key = key
    end

    class Value
      include ::Comparable

      attr_reader :klass, :key, :args, :block

      def initialize(klass, key, args, &block)
        @klass = klass
        @key = ::EacRubyUtils::Inflector.variableize(key.to_s).to_sym
        @args = args
        @block = block
      end

      def <=>(other)
        key <=> other.key
      end

      def apply
        define_constant
        define_class_method

        self
      end

      # @return [String]
      def class_method_name
        key.to_s
      end

      # @return [String]
      def constant_name
        class_method_name.upcase
      end

      def value
        @value ||= uncached_value
      end

      private

      def define_class_method
        the_value = self
        klass.define_singleton_method(class_method_name) { the_value.value }
      end

      def define_constant
        klass.const_set(constant_name, value)
      end

      def uncached_value
        klass.new(key, *value_args)
      end

      def value_args
        r = if block
              block.call
            elsif args.one? && args.first.is_a?(::Enumerable)
              args.first
            else
              args
            end
        r.is_a?(::Enumerable) ? r : [r]
      end
    end
  end
end
