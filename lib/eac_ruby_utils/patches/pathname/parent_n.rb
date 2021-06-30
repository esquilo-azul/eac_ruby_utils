# frozen_string_literal: true

require 'pathname'

class Pathname
  # Apply .parent n times.
  # @return [Pathname]
  def parent_n(n) # rubocop:disable Naming/MethodParameterName
    n.times.inject(self) { |a, _e| a.parent }
  end
end
