# frozen_string_literal: true

require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class RecursiveBuilder
    include ::EacRubyUtils::SimpleCache

    attr_reader :root, :neighbors_block

    def initialize(root, &neighbors_block)
      @root = root
      @neighbors_block = neighbors_block
    end

    private

    attr_reader :added, :to_check

    def result_uncached
      @added = []
      @to_check = []
      item_try_add_to_check(root)
      while check_next_item
        # Do nothing
      end
      added
    end

    def item_try_add_to_check(item)
      to_check << item unless item_added?(item)
    end

    def item_added?(item)
      added.include?(item) || to_check.include?(item)
    end

    def check_next_item # rubocop:disable Naming/PredicateMethod
      return false unless to_check.any?

      item = to_check.shift
      added << item
      item_neighborhs(item).each { |sub_item| item_try_add_to_check(sub_item) }
      true
    end

    def item_neighborhs(item)
      neighbors_block.call(item)
    end
  end
end
