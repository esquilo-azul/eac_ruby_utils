# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'addressable/uri'

class Object
  # Convert +self+ to String and then to Addressable::URI. Return nil if +self+ is +blank?+.
  #
  # @return [Addressable::URI]
  def to_uri
    return self if is_a?(::Addressable::URI)

    to_s.blank? ? nil : ::Addressable::URI.parse(to_s)
  end
end
