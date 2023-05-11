# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_abstract'

class Module
  def enable_abstract_methods(*methods)
    include ::EacRubyUtils::ActsAsAbstract
    abstract_methods(*methods)
  end
end
