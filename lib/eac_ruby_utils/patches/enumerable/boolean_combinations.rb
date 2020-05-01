# frozen_string_literal: true

module Enumerable
  # Produces a array with values's all combinations.
  #
  # Example:
  #   %i[a b].boolean_combinations
  #   => [[], [:a], [:b], [:a, :b]]
  #
  # @return [Array]
  def bool_array_combs
    bool_combs([], method(:bool_array_combs_new_comb))
  end

  # Produces a hash with values's all combinations.
  #
  # Example:
  #   %i[a b].boolean_combinations
  #   => [{a: false, b: false}, {a: false, b: true}, {a: true, b: false}, {a: true, b: true}]
  #
  # @return [Hash]
  def bool_hash_combs
    bool_combs({}, method(:bool_hash_combs_new_comb))
  end

  private

  def bool_combs(empty_value, new_comb_method)
    head = [empty_value]
    r = inject(head) do |a, value|
      new_comb_method.call(value, a)
    end
    r == head ? [] : r
  end

  def bool_array_combs_new_comb(value, combs)
    combs + combs.map { |c| c + [value] }
  end

  def bool_hash_combs_new_comb(value, combs)
    combs.flat_map do |comb|
      [false, true].map { |bool_value| comb.dup.merge(value => bool_value) }
    end
  end
end
