# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/i18n_translate'

class Object
  def i18n_translate(entry_suffix, values = {})
    self.class.i18n_translate(entry_suffix, values)
  end

  delegate :on_i18n_locale, to: :class
end
