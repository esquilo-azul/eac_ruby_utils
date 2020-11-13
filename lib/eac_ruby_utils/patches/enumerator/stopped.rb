# frozen_string_literal: true

class Enumerator
  def stopped?
    peek
    false
  rescue ::StopIteration
    true
  end
end
