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
        ::EacRubyUtils::Console::Configs::StorePasswordsEntryReader.new(self) == 'yes'
      end
    end
  end
end
