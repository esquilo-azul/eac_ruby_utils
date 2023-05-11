# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_abstract'

class Module
  # Include [EacRubyUtils::ActsAsAbstract] and perform EacRubyUtils::ActsAsAbstract.abstract_methods
  # on parameter +methods+.
  # @param methods [Array<Symbol>]
  # @return [void]
  def acts_as_abstract(*methods)
    include ::EacRubyUtils::ActsAsAbstract
    abstract_methods(*methods)
  end
end
