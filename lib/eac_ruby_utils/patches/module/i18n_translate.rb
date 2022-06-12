# frozen_string_literal: true

require 'eac_ruby_utils/locales/module_i18n_translate'

class Module
  def i18n_translate(entry_suffix, values = {})
    ::EacRubyUtils::Locales::ModuleI18nTranslate.new(self, entry_suffix, values).result
  end
end
