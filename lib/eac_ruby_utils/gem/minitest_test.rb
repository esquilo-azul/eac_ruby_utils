# frozen_string_literal: true

require 'eac_ruby_utils/gem/test'

module EacRubyUtils
  class Gem
    class MinitestTest < ::EacRubyUtils::Gem::Test
      def bundle_exec_args
        %w[rake test]
      end

      def dependency_gem
        'minitest'
      end

      def test_directory
        'test'
      end
    end
  end
end
