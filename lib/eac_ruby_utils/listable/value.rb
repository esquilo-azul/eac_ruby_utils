# frozen_string_literal: true

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
        "#{@list.item}_#{@key}".gsub(/[^a-z0-9_]/, '_').gsub(/_+/, '_')
                               .gsub(/(?:\A_|_\z)/, '').upcase
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
