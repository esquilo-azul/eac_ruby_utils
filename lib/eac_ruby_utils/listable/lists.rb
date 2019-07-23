# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/string/inflections'
require_relative 'integer_list'
require_relative 'string_list'

module EacRubyUtils
  module Listable
    class Lists
      attr_reader :source

      def initialize(source)
        @source = source
      end

      def add_integer(item, *labels)
        check_acts_as_listable_new_item(item)
        acts_as_listable_items[item] = ::EacRubyUtils::Listable::IntegerList.new(
          self, item, labels
        )
      end

      def add_string(item, *labels)
        check_acts_as_listable_new_item(item)
        acts_as_listable_items[item] = ::EacRubyUtils::Listable::StringList.new(
          self, item, labels
        )
      end

      def method_missing(name, *args, &block)
        list = find_list_by_method(name)
        list ? list : super
      end

      def respond_to_missing?(name, include_all = false)
        find_list_by_method(name) || super
      end

      def acts_as_listable_items
        @acts_as_listable_items ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      private

      def check_acts_as_listable_new_item(item)
        return unless acts_as_listable_items.key?(item)
        raise "Item já adicionado anteriormente: #{item} em #{self} " \
          "(#{acts_as_listable_items.keys})"
      end

      def find_list_by_method(method)
        acts_as_listable_items.each do |item, list|
          return list if method.to_sym == item.to_sym
        end
        nil
      end
    end
  end
end
