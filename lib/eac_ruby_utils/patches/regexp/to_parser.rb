# frozen_string_literal: true

require 'eac_ruby_utils/regexp_parser'

class Regexp
  # @return [::EacRubyUtils::RegexpParser]
  def to_parser(&)
    ::EacRubyUtils::RegexpParser.new(self, &)
  end
end
