# frozen_string_literal: true

require 'eac_ruby_utils/inflector'

class String
  def variableize
    ::EacRubyUtils::Inflector.variableize(self)
  end
end
