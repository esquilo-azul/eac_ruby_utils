# frozen_string_literal: true

require 'eac_ruby_utils/regexp_parser'

class Regexp
  # @return [::EacRubyUtils::RegexpParser]
  def to_parser(&block)
    ::EacRubyUtils::RegexpParser.new(self, &block)
  end
end
