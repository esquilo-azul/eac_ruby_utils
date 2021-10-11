# frozen_string_literal: true

require 'eac_ruby_utils/compact'

class Object
  # If +self+ is a Proc, return the value of +.call+. If not, return +self+.
  # @return [Object]
  def call_if_proc
    is_a?(::Proc) ? call : self
  end
end
