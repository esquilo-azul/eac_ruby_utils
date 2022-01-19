# frozen_string_literal: true

require 'pathname'

class Pathname
  def readlink_r
    r = self
    r = r.readlink while r.symlink?
    r
  end
end
