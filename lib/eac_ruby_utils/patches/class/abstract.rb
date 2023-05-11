# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_abstract'

class Class
  def abstract?
    ::EacRubyUtils::ActsAsAbstract.abstract?(self)
  end
end
