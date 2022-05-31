# frozen_string_literal: true

require 'eac_ruby_utils/inflector'

module EacRubyUtils
  module Listable
    class Value
      attr_reader :value, :key

      def initialize(list, value, key, translation_required = true)
        @list = list
        @value = value
        @key = key
        @translation_required = translation_required
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

      def translation_required?
        @translation_required
      end

      private

      def translate(translate_key)
        full_translate_key = "#{@list.i18n_key}.#{@key}.#{translate_key}"
        if !::I18n.exists?(full_translate_key) && !translation_required?
          ''
        else
          ::I18n.t(full_translate_key)
        end
      end
    end
  end
end
