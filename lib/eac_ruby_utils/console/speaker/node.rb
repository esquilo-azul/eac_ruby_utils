# frozen_string_literal: true

require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  module Console
    module Speaker
      class Node
        attr_accessor :stdin, :stdout, :stderr

        def initialize(parent = nil)
          self.stdin = parent.if_present(STDIN, &:stdin)
          self.stdout = parent.if_present(STDOUT, &:stdout)
          self.stderr = parent.if_present(STDERR, &:stderr)
        end

        def configure
          yield(self)
          self
        end
      end
    end
  end
end
