# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/template'

class Object
  def template
    self.class.template
  end
end
