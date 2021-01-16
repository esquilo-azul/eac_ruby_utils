# frozen_string_literal: true

require 'active_support/core_ext/time/zones'
require 'eac_ruby_utils/local_time_zone'

::Time.zone = ::EacRubyUtils::LocalTimeZone.local_time_zone
