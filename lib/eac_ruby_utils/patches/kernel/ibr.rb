# frozen_string_literal: true

module Kernel
  # Raise exception with text "Invalid branch reached".
  def ibr(message = nil)
    s = "Invalid branch reached (Called in #{caller.first})"
    s += ": #{message}" if message
    raise s
  end
end
