# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class Object
  # @return +block.call(self)+ if +self+ is present, +default_value+ otherwise.
  def if_present(default_value = nil)
    return default_value unless present?

    block_given? ? yield(self) : self
  end

  # @return +yield+ if +self+ is blank.
  def if_blank
    return yield if blank? && block_given?

    self
  end
end
