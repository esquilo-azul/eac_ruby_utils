# frozen_string_literal: true

class Pathname
  # @return +block.call(self)+ if +self+ exists, +default_value+ otherwise.
  def if_exist(default_value = nil)
    return default_value unless exist?

    block_given? ? yield(self) : self
  end
end
