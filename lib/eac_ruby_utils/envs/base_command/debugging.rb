# frozen_string_literal: true

module EacRubyUtils
  module Envs
    module BaseCommand
      module Debugging
        def debug?
          ENV['DEBUG'].to_s.strip != ''
        end

        # Print a message if debugging is enabled.
        def debug_print(message)
          message = message.to_s
          puts message.if_respond(:light_red, message) if debug?
        end
      end
    end
  end
end
