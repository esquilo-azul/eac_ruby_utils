# frozen_string_literal: true

require 'eac_ruby_utils/configs'
require 'eac_ruby_utils/core_ext'

module EacRubyUtils
  module Console
    class Configs
      require_sub __FILE__
      enable_console_speaker

      class << self
        def entry_key_to_envvar_name(entry_key)
          ::EacRubyUtils::Console::Configs::EntryReader.entry_key_to_envvar_name(entry_key)
        end
      end

      STORE_PASSWORDS_KEY = 'core.store_passwords'

      attr_reader :configs

      def initialize(configs_key, options = {})
        options.assert_argument(::Hash, 'options')
        @configs = ::EacRubyUtils::Configs.new(configs_key, options.merge(autosave: true))
      end

      def read_password(entry_key, options = {})
        options = ReadEntryOptions.new(options.merge(noecho: true))
        if store_passwords?
          read_entry(entry_key, options)
        else
          looped_entry_value_from_input(entry_key, options)
        end
      end

      def read_entry(entry_key, options = {})
        ::EacRubyUtils::Console::Configs::EntryReader.new(self, entry_key, options).read
      end

      def store_passwords?
        read_entry(
          STORE_PASSWORDS_KEY,
          before_input: -> { store_password_banner },
          validator: ->(entry_value) { %w[yes no].include?(entry_value) }
        ) == 'yes'
      end

      protected

      def store_password_banner
        infom 'Do you wanna to store passwords?'
        infom "Warning: the passwords will be store in clear text in \"#{configs.storage_path}\""
        infom 'Enter "yes" or "no"'
      end
    end
  end
end
