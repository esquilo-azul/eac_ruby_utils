# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'eac_ruby_utils/require_sub'

module EacRubyUtils
  # Provide a option by constant, method or options object.
  module SettingsProvider
    ::EacRubyUtils.require_sub __FILE__, base: self

    def setting_constant_name(key, fullname = false) # rubocop:disable Style/OptionalBooleanParameter
      setting_value_instance(key).constant_name(fullname)
    end

    def setting_search_order
      %w[settings_object method constant]
    end

    # return [ActiveSupport::HashWithIndifferentAccess]
    def settings_object
      ActiveSupport::HashWithIndifferentAccess.new(
        respond_to?(settings_object_name) ? send(settings_object_name) : {}
      )
    end

    def settings_object_name
      'settings'
    end

    def setting_value(key, options = {})
      setting_value_instance(key, options).value
    end

    def setting_value_by_constant(key)
      setting_value_instance(key).value_by_constant
    end

    def setting_value_by_method(key)
      setting_value_instance(key).value_by_method
    end

    def setting_value_by_settings_object(key)
      setting_value_instance(key).value_by_settings_object
    end

    def setting_value_instance(key, options = {})
      ::EacRubyUtils::SettingsProvider::SettingValue.new(self, key, options)
    end
  end
end
