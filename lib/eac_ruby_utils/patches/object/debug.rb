# frozen_string_literal: true

class Object
  def print_debug
    STDERR.write(to_debug + "\n")

    self
  end

  def to_debug
    "|#{self.class}|#{self}|"
  end

  def raise_debug
    raise to_debug
  end
end
