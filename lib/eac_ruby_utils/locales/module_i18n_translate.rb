# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/common_constructor'
require 'i18n'

module EacRubyUtils
  module Locales
    class ModuleI18nTranslate
      TRANSLATE_LOCALE_KEY = :__locale

      common_constructor :the_module, :entry_suffix, :values, default: [{}]

      def i18n_key
        "#{module_entry_prefix}.#{entry_suffix}"
      end

      def i18n_options
        values.except(TRANSLATE_LOCALE_KEY)
      end

      def i18n_translate
        ::I18n.translate(i18n_key, i18n_options)
      end

      def locale
        values[TRANSLATE_LOCALE_KEY]
      end

      def module_entry_prefix
        the_module.name.underscore.gsub('/', '.')
      end

      def on_locale
        old_locale = ::I18n.locale
        begin
          ::I18n.locale = locale
          yield
        ensure
          ::I18n.locale = old_locale
        end
      end

      def result
        on_locale do
          i18n_translate
        end
      end
    end
  end
end
