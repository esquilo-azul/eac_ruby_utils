# frozen_string_literal: true

require 'eac_ruby_utils/abstract_methods'

class Class
  def abstract?
    ::EacRubyUtils::AbstractMethods.abstract?(self)
  end
end
