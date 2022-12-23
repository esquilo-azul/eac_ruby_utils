# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'
require 'eac_ruby_utils/inflector'

module EacRubyUtils
  module Listable
    class Item
      common_constructor :list, :value, :key, :translation_required, default: [true]

      def to_s
        "I: #{list.item}, V: #{value}, K: #{key}"
      end

      def constant_name
        ::EacRubyUtils::Inflector.variableize("#{list.item}_#{key}").upcase
      end

      def label
        translate('label')
      end

      def description
        translate('description')
      end

      # @return [Array] A two-item array in format `[label, value]`.
      def to_option
        [label, value]
      end

      def translation_required?
        translation_required
      end

      private

      def translate(translate_key)
        full_translate_key = "#{list.i18n_key}.#{key}.#{translate_key}"
        if !::I18n.exists?(full_translate_key) && !translation_required?
          ''
        else
          ::I18n.t(full_translate_key)
        end
      end
    end
  end
end
