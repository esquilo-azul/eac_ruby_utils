# frozen_string_literal: true

require 'eac_ruby_utils'

class Integer
  RJUST_ZERO_STRING = '0'

  # @param size [Integer]
  # @return [String]
  def rjust_zero(size)
    to_s.rjust(size, RJUST_ZERO_STRING)
  end
end
