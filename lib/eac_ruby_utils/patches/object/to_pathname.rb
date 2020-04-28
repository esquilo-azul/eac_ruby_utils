# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'pathname'

class Object
  # Convert +self+ to String and then to Pathname. Return nil if +self+ is +blank?+.
  #
  # @return [Pathname]
  def to_pathname
    return self if is_a?(::Pathname)

    to_s.blank? ? nil : ::Pathname.new(to_s)
  end
end
