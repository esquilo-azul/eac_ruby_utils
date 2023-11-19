# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'

class Class
  def common_constructor(...)
    ::EacRubyUtils::CommonConstructor.new(...).setup_class(self)
  end
end
