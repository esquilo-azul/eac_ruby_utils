# frozen_string_literal: true

require 'eac_ruby_utils/abstract_methods'

class Module
  def enable_abstract_methods(*methods)
    include ::EacRubyUtils::AbstractMethods
    abstract_methods(*methods)
  end
end
