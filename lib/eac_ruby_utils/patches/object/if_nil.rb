# frozen_string_literal: true

class Object
  # @return +block.call(self)+ if +self+ is not nil, +default_value+ otherwise.
  def if_not_nil(default_value = nil)
    return default_value if nil?

    block_given? ? yield(self) : self
  end

  # @return +yield+ if +self+ is nil, +self+ otherwise.
  def if_nil
    return yield if nil? && block_given?

    self
  end
end
