# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class Hash
  # @return +block.call(fetch(key))+ if +self+ has the key +key+, +default_value+ otherwise.
  def if_key(key, default_value = nil)
    return default_value unless key?(key)

    block_given? ? yield(fetch(key)) : fetch(key)
  end
end
