# frozen_string_literal: true

require 'pathname'

class Pathname
  def basename_sub
    parent.join(yield(basename))
  end
end
