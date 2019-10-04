# frozen_string_literal: true

require 'eac_ruby_utils/console/speaker/node'

module EacRubyUtils
  module Console
    module Speaker
      class << self
        def current_node
          nodes_stack.last
        end

        def push
          nodes_stack << ::EacRubyUtils::Console::Speaker::Node.new
          current_node
        end

        def pop
          return nodes_stack.pop if nodes_stack.count > 1
          raise "Cannot remove first node (nodes_stack.count: #{nodes_stack.count})"
        end

        private

        def nodes_stack
          @nodes_stack ||= [::EacRubyUtils::Console::Speaker::Node.new]
        end
      end
    end
  end
end
