# frozen_string_literal: true

require 'eac_ruby_utils/options_consumer'

class Hash
  # Returns an <tt>EacRubyUtils::OptionsConsumer</tt> out of its receiver.
  def to_options_consumer
    ::EacRubyUtils::OptionsConsumer.new(self)
  end
end
