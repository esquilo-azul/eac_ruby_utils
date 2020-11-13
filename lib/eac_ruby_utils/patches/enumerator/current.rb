# frozen_string_literal: true

class Enumerator
  def current(default_value = nil)
    peek
  rescue ::StopIteration
    default_value
  end
end
