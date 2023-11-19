# frozen_string_literal: true

class Regexp
  # If +self+ matches +string+ returns +block.call(Match result) or only Match result if block is
  # not provided.
  # If +self+ does not match +string+ raises a +ArgumentError+ if +required+ is truthy or return
  # +nil+ otherwise.
  def if_match(string, required = true, &block) # rubocop:disable Style/OptionalBooleanParameter
    m = match(string)
    if m
      block ? block.call(m) : m
    elsif required
      raise(::ArgumentError, "Pattern \"#{self}\" does not match string \"#{string}\"")
    end
  end
end
