# frozen_string_literal: true

class Object
  def pretty_debug
    STDERR.write(pretty_inspect)

    self
  end

  def print_debug
    STDERR.write(to_debug + "\n")

    self
  end

  def to_debug
    "|#{::Object.instance_method(:to_s).bind(self).call}|#{self}|"
  end

  def raise_debug
    raise to_debug
  end
end
