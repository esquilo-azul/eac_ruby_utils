# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/listable'
require 'eac_ruby_utils/simple_cache'
require 'eac_ruby_utils/struct'

module EacRubyUtils
  module SettingsProvider
    class SettingValue
      include ::EacRubyUtils::Listable
      include ::EacRubyUtils::SimpleCache

      attr_reader :source, :key, :options

      lists.add_symbol :option, :default, :order, :required

      def initialize(source, key, options)
        @source = source
        @key = key
        @options = options
      end

      def constant_name(fullname = false) # rubocop:disable Style/OptionalBooleanParameter
        name = key.to_s.underscore.upcase
        name = "#{source.class.name}::#{name}" if fullname
        name
      end

      def value
        parsed_options.order.each do |method|
          return send("value_by_#{method}") if send("value_by_#{method}?")
        end
        return parsed_options.default if parsed_options.respond_to?(OPTION_DEFAULT)
        return nil unless parsed_options.required

        raise_key_not_found
      end

      def value_by_constant
        source.class.const_get(constant_name)
      end

      def value_by_constant?
        source.class.const_defined?(constant_name)
      end

      def value_by_method
        source.send(key)
      end

      def value_by_method?
        source.respond_to?(key, true)
      end

      def value_by_settings_object
        source.settings_object.fetch(key)
      end

      def value_by_settings_object?
        source.settings_object.key?(key)
      end

      private

      def parsed_options_uncached
        r = self.class.lists.option.hash_keys_validate!(options.symbolize_keys)
        r[:required] = true unless r.key?(OPTION_REQUIRED)
        r[:order] = source.setting_search_order if r[OPTION_ORDER].nil?
        ::EacRubyUtils::Struct.new(r)
      end

      def raise_key_not_found
        raise "Setting \"#{key}\" not found. Supply in #{source.settings_object_name}, implement " \
              "a \"#{key}\" method or declare a #{constant_name(true)} constant."
      end
    end
  end
end
