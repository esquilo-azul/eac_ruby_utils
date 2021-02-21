# frozen_string_literal: true

require 'eac_ruby_utils/local_time_zone'

class Time
  class << self
    def required_zone
      zone || ::EacRubyUtils::LocalTimeZone.auto || raise('No zone set or discovered')
    end
  end
end
