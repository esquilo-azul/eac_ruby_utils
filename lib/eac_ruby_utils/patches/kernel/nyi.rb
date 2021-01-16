# frozen_string_literal: true

module Kernel
  # Raise exception with text "Not yet implemented".
  def nyi
    raise "Not yet implemented (Called in #{caller.first})"
  end
end
