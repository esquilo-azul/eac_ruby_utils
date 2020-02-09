# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/options_consumer'

module EacRubyUtils
  # Provide a option by constant, method or options object.
  module SettingsProvider
    def setting_constant_name(key, fullname = false)
      name = key.to_s.underscore.upcase
      name = "#{self.class.name}::#{name}" if fullname
      name
    end

    def setting_search_order
      %w[settings_object method constant]
    end

    def settings_object
      respond_to?(settings_object_name) ? send(settings_object_name) : {}
    end

    def settings_object_name
      'settings'
    end

    def setting_value(key, options = {})
      options = parse_setting_value_options(options)
      options.order.each do |method|
        value = send("setting_value_by_#{method}", key)
        return value if value
      end
      return nil unless options.required

      raise "Setting \"#{key}\" not found. Supply in #{settings_object_name}, implement a " \
        "\"#{key}\" method or declare a #{setting_constant_name(key, true)} constant."
    end

    def setting_value_by_constant(key)
      constant_name = setting_constant_name(key)
      begin
        self.class.const_get(constant_name)
      rescue NameError
        nil
      end
    end

    def setting_value_by_method(key)
      respond_to?(key) ? send(key) : nil
    end

    def setting_value_by_settings_object(key)
      settings_object[key.to_s] || settings_object[key.to_sym]
    end

    private

    def parse_setting_value_options(options)
      r = ::EacRubyUtils::OptionsConsumer.new(options).consume_all(:required, :order, ostruct: true)
      r.required = true if r.required.nil?
      r.order = setting_search_order if r.order.nil?
      r
    end
  end
end
