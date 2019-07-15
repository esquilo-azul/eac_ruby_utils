# frozen_string_literal: true

class Hash
  def to_sym_keys_hash
    each_with_object({}) do |(key, value), memo|
      symbol_key = key.respond_to?(:to_sym) ? key.to_sym : key.to_s.to_sym
      memo[symbol_key] = value
    end
  end
end
