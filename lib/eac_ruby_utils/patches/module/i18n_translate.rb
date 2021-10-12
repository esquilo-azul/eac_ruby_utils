# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'i18n'

class Module
  TRANSLATE_LOCALE_KEY = :__locale

  def i18n_translate(entry_suffix, values = {})
    on_i18n_locale(values.delete(TRANSLATE_LOCALE_KEY)) do
      ::I18n.translate(i18n_translate_entry_full(entry_suffix), values)
    end
  end

  def i18n_translate_entry_full(entry_suffix)
    "#{i18n_translate_entry_self_prefix}.#{entry_suffix}"
  end

  def i18n_translate_entry_self_prefix
    name.underscore.gsub('/', '.')
  end

  def on_i18n_locale(locale)
    old_locale = ::I18n.locale
    begin
      ::I18n.locale = locale
      yield
    ensure
      ::I18n.locale = old_locale
    end
  end
end
