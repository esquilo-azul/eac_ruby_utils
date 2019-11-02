# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'
require 'eac_ruby_utils/configs'
require 'eac_ruby_utils/console/speaker'
require 'eac_ruby_utils/options_consumer'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  module Console
    class Configs
      include ::EacRubyUtils::Console::Speaker

      class << self
        def entry_key_to_envvar_name(entry_key)
          path = if entry_key.is_a?(::Array)
                   entry_key
                 else
                   ::EacRubyUtils::PathsHash.parse_entry_key(entry_key)
                 end
          path.join('_').gsub(/[^a-z0-9_]/i, '').gsub(/\A_+/, '').gsub(/_+\z/, '')
              .gsub(/_{2,}/, '_').upcase
        end
      end

      STORE_PASSWORDS_KEY = 'core.store_passwords'

      attr_reader :configs

      def initialize(configs_key)
        @configs = ::EacRubyUtils::Configs.new(configs_key, autosave: true)
      end

      def read_password(entry_key, options = {})
        options = options.merge(noecho: true)
        if store_passwords?
          read_entry(entry_key, options)
        else
          looped_entry_value_from_input(entry_key, options)
        end
      end

      def read_entry(entry_key, options = {})
        options = ReadEntryOptions.new(options)
        unless options[:noenv]
          envvar_value = envvar_read_entry(entry_key)
          return envvar_value if envvar_value.present?
        end
        stored_value = configs.read_entry(entry_key)
        return stored_value if stored_value
        return read_entry_from_console(entry_key, options) unless options[:noinput]

        raise "No value found for entry \"#{entry_key}\"" if options[:required]
      end

      def store_passwords?
        read_entry(
          STORE_PASSWORDS_KEY,
          before_input: -> { store_password_banner },
          validator: ->(entry_value) { %w[yes no].include?(entry_value) }
        ) == 'yes'
      end

      protected

      def envvar_read_entry(entry_key)
        ENV[self.class.entry_key_to_envvar_name(entry_key)]
      end

      def read_entry_from_console(entry_key, options)
        options[:before_input].call if options[:before_input].present?
        entry_value = looped_entry_value_from_input(entry_key, options)
        configs.write_entry(entry_key, entry_value)
        entry_value
      end

      def store_password_banner
        infom 'Do you wanna to store passwords?'
        infom "Warning: the passwords will be store in clear text in \"#{configs.storage_path}\""
        infom 'Enter "yes" or "no"'
      end

      def looped_entry_value_from_input(entry_key, options)
        loop do
          entry_value = entry_value_from_input(entry_key, options)
          next unless entry_value.present?
          next if options[:validator] && !options[:validator].call(entry_value)

          return entry_value
        end
      end

      def entry_value_from_input(entry_key, options)
        entry_value = request_input("Value for entry \"#{entry_key}\"",
                                    options.request_input_options)
        warn('Entered value is blank') if entry_value.blank?
        entry_value
      end

      class ReadEntryOptions
        include ::EacRubyUtils::SimpleCache
        ::EacRubyUtils::CommonConstructor.new(:options).setup_class(self)

        DEFAULT_VALUES = {
          before_input: nil, bool: false, list: false, noecho: false, noenv: false, noinput: false,
          required: true, validator: nil
        }.freeze

        def [](key)
          values.fetch(key.to_sym)
        end

        def request_input_options
          values.slice(:bool, :list, :noecho)
        end

        private

        def values_uncached
          consumer = ::EacRubyUtils::OptionsConsumer.new(options)
          r = {}
          DEFAULT_VALUES.each do |key, default_value|
            value = consumer.consume(key)
            value = default_value if value.nil?
            r[key] = value
          end
          consumer.validate
          r
        end
      end
    end
  end
end
