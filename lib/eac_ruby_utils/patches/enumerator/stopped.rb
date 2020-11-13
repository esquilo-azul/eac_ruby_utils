# frozen_string_literal: true

class Enumerator
  def ongoing?
    !stopped?
  end

  def stopped?
    peek
    false
  rescue ::StopIteration
    true
  end
end
