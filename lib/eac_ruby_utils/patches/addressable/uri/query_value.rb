# frozen_string_literal: true

require 'addressable'

module Addressable
  class URI
    # @return [ActiveSupport:HashWithIndifferentAccess]
    def hash_query_values
      (query_values || {}).with_indifferent_access
    end

    def query_value(*args)
      if args.count == 1
        query_value_get(*args)
      elsif args.count == 2
        query_value_set(*args)
      else
        raise ::ArgumentError, "#{object.class}.#{__method__}: wrong number of arguments" \
          " (given #{args.count}, expected 1..2)"
      end
    end

    private

    def query_value_get(name)
      hash_query_values[name]
    end

    def query_value_set(name, value)
      new_query_values = hash_query_values
      new_query_values[name] = value
      self.query_values = new_query_values

      self
    end
  end
end
