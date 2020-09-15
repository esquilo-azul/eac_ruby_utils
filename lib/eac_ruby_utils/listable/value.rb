# frozen_string_literal: true

require 'eac_ruby_utils/inflector'

module EacRubyUtils
  module Listable
    class Value
      attr_reader :value, :key

      def initialize(list, value, key)
        @list = list
        @value = value
        @key = key
      end

      def to_s
        "I: #{@list.item}, V: #{@value}, K: #{@key}"
      end

      def constant_name
        ::EacRubyUtils::Inflector.variableize("#{@list.item}_#{@key}").upcase
      end

      def label
        translate('label')
      end

      def description
        translate('description')
      end

      private

      def translate(translate_key)
        ::I18n.t("#{@list.i18n_key}.#{@key}.#{translate_key}")
      end
    end
  end
end
