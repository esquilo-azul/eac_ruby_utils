# frozen_string_literal: true

require 'eac_ruby_utils/string_delimited'

class String
  # @return [EacRubyUtils::StringDelimited]
  def delimited(begin_delimiter, end_delimiter)
    ::EacRubyUtils::StringDelimited.new(self, begin_delimiter, end_delimiter)
  end

  %w[inner outer without_inner without_outer].each do |method_suffix|
    define_method "delimited_#{method_suffix}" do |begin_delimiter, end_delimiter|
      delimited(begin_delimiter, end_delimiter).send(method_suffix)
    end
  end
end
