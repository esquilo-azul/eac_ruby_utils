# frozen_string_literal: true

class Object
  # @return [Symbol]
  def to_sym_by_eac
    return self if is_a?(::Symbol)
    return to_sym if respond_to?(:to_sym)

    to_s.to_sym
  end
end
