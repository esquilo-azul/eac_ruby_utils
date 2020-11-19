# frozen_string_literal: true

require 'eac_ruby_utils/console/configs/entry_reader'

module EacRubyUtils
  module Console
    class Configs
      class PasswordEntryReader < ::EacRubyUtils::Console::Configs::EntryReader
        ENTRY_KEY = 'core.store_passwords'

        def initialize(console_configs, entry_key, options = {})
          super(console_configs, entry_key, options.merge(noecho: true,
                                                          store: console_configs.store_passwords?))
        end
      end
    end
  end
end
