# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/options_consumer'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  module SettingsProvider
    class SettingValue
      include ::EacRubyUtils::SimpleCache

      attr_reader :source, :key, :options

      def initialize(source, key, options)
        @source = source
        @key = key
        @options = options
      end

      def constant_name(fullname = false)
        name = key.to_s.underscore.upcase
        name = "#{source.class.name}::#{name}" if fullname
        name
      end

      def value
        parsed_options.order.each do |method|
          value = send("value_by_#{method}")
          return value if value
        end
        return nil unless parsed_options.required

        raise_key_not_found
      end

      def value_by_constant
        source.class.const_get(constant_name)
      rescue NameError
        nil
      end

      def value_by_method
        source.respond_to?(key, true) ? source.send(key) : nil
      end

      def value_by_settings_object
        source.settings_object[key.to_s] || source.settings_object[key.to_sym]
      end

      private

      def parsed_options_uncached
        r = ::EacRubyUtils::OptionsConsumer.new(options).consume_all(:required, :order,
                                                                     ostruct: true)
        r.required = true if r.required.nil?
        r.order = source.setting_search_order if r.order.nil?
        r
      end

      def raise_key_not_found
        raise "Setting \"#{key}\" not found. Supply in #{source.settings_object_name}, implement "\
          "a \"#{key}\" method or declare a #{constant_name(true)} constant."
      end
    end
  end
end
