# frozen_string_literal: true

require 'eac_ruby_utils/compare_by'

class Module
  def compare_by(*fields)
    ::EacRubyUtils::CompareBy.new(fields).apply(self)
  end
end
