# frozen_string_literal: true

module EacRubyUtils
  module Envs
    class Command
      module Concat
        def pipe(other_command)
          duplicate_by_extra_options(pipe: other_command)
        end

        private

        def append_pipe(command)
          extra_options[:pipe].present? ? "#{command} | #{extra_options[:pipe].command}" : command
        end
      end
    end
  end
end
