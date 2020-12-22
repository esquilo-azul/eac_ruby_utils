# frozen_string_literal: true

require 'pathname'

class Pathname
  def basename_sub(suffix = '')
    parent.join(yield(basename(suffix)))
  end
end
