# frozen_string_literal: true

require 'eac_ruby_utils/console/configs/entry_reader'

module EacRubyUtils
  module Console
    class Configs
      class PasswordEntryReader < ::EacRubyUtils::Console::Configs::EntryReader
        ENTRY_KEY = 'core.store_passwords'

        def initialize(console_configs, entry_key, options = {})
          super(console_configs, entry_key, options.merge(noecho: true))
        end

        def read
          if console_configs.store_passwords?
            super
          else
            looped_entry_value_from_input
          end
        end
      end
    end
  end
end
