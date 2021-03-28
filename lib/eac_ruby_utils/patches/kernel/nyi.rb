# frozen_string_literal: true

module Kernel
  # Raise exception with text "Not yet implemented".
  def nyi(message = nil)
    s = "Not yet implemented (Called in #{caller.first})"
    s += ": #{message}" if message
    raise s
  end
end
