# frozen_string_literal: true

require 'eac_ruby_utils/gem/minitest_test'
require 'eac_ruby_utils/gem/rspec_test'

module EacRubyUtils
  class Gem
    class TestAll
      enable_console_speaker
      enable_simple_cache
      common_constructor :gems
      set_callback :initialize, :after, :run

      private

      def all_tests_uncached
        decorated_gems.flat_map(&:tests)
      end

      def bundle_all_gems
        infom 'Bundling all gems...'
        decorated_gems.each do |gem|
          next unless gem.gemfile_path.exist?
          infov 'Bundle install', gem
          gem.bundle.execute!
        end
      end

      def decorated_gems_uncached
        gems.map { |gem| DecoratedGem.new(gem) }
      end

      def failed_tests_uncached
        all_tests.select { |r| r.result == ::EacRubyUtils::Gem::Test::RESULT_FAILED }
      end

      def final_results_banner
        if failed_tests.any?
          warn 'Some test did not pass:'
          failed_tests.each do |test|
            infov '  * Test', test
            infov '    * STDOUT', test.stdout_cache.content_path
            infov '    * STDERR', test.stderr_cache.content_path
          end
        else
          success 'All tests passed'
        end
      end

      def run
        start_banner
        bundle_all_gems
        test_all_gems
        final_results_banner
      end

      def start_banner
        infov 'Gems to test', decorated_gems.count
      end

      def test_all_gems
        infom 'Running tests...'
        all_tests.each do |test|
          infov test, Result.new(test.result).tag
        end
      end

      class DecoratedGem < ::SimpleDelegator
        def tests
          [::EacRubyUtils::Gem::MinitestTest.new(__getobj__),
           ::EacRubyUtils::Gem::RspecTest.new(__getobj__)]
        end
      end

      class Result
        common_constructor :result

        COLORS = {
          ::EacRubyUtils::Gem::Test::RESULT_FAILED => :red,
          ::EacRubyUtils::Gem::Test::RESULT_NONEXISTENT => :white,
          ::EacRubyUtils::Gem::Test::RESULT_SUCCESSFUL => :green
        }.freeze

        def tag
          result.to_s.send(color)
        end

        def color
          COLORS.fetch(result)
        end
      end
    end
  end
end
