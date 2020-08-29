# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class Object
  # @return +block.call(self.method_name)+ if +self+ responds to +method_name+, +default_value+
  # otherwise.
  def if_respond(method_name, default_value = nil)
    return default_value unless respond_to?(method_name)

    value = send(method_name)

    block_given? ? yield(value) : value
  end

  # @return +yield+ if +self+ is blank.
  def if_blank
    return yield if blank? && block_given?

    self
  end
end
