# frozen_string_literal: true

require 'active_support/core_ext/object'
require 'eac_ruby_utils/patches/object/asserts'

module EacRubyUtils
  class PathsHash
    class << self
      def parse_entry_key(entry_key)
        r = entry_key.to_s.strip
        raise EntryKeyError, 'Entry key cannot start or end with dot' if
        r.start_with?('.') || r.end_with?('.')

        r = r.split('.').map(&:strip)
        raise EntryKeyError, "Entry key \"#{entry_key}\" is empty" if r.empty?
        return r.map(&:to_sym) unless r.any?(&:blank?)

        raise EntryKeyError, "Entry key \"#{entry_key}\" has at least one blank part"
      end
    end

    attr_reader :root

    def initialize(source_hash = {})
      @root = Node.new(source_hash)
    end

    def [](entry_key)
      root.read_entry(self.class.parse_entry_key(entry_key), [])
    end

    def []=(entry_key, entry_value)
      root.write_entry(self.class.parse_entry_key(entry_key), entry_value, [])
    end

    def to_h
      root.to_h
    end

    private

    attr_reader :data

    class EntryKeyError < StandardError
    end

    class Node
      def initialize(source_hash)
        source_hash.assert_argument(Hash, 'source_hash')
        @data = source_hash.map { |k, v| [k.to_sym, v.is_a?(Hash) ? Node.new(v) : v] }.to_h
      end

      def to_h
        data.map { |k, v| [k, v.is_a?(Node) ? v.to_h : v] }.to_h
      end

      def read_entry(path, current)
        validate_path(path, current)
        node_key = path.shift
        node = data[node_key]
        return (node.is_a?(Node) ? node.to_h : node) if path.empty?
        return nil if node.blank?
        return node.read_entry(path, current + [node_key]) if node.is_a?(Node)

        raise(EntryKeyError,
              "Path #{current.join(',')} is not a Node and path continues (#{current + path})")
      end

      def write_entry(path, value, current)
        validate_path(path, current)
        node_key = path.shift
        write_entry_value(path, node_key, value, current)
      end

      private

      def write_entry_value(path, node_key, value, current)
        if path.empty?
          data[node_key] = value.is_a?(Hash) ? Node.new(value) : value
        else
          data[node_key] = Node.new({}) unless data[node_key].is_a?(Node)
          data[node_key].write_entry(path, value, current + [node_key])
        end
      end

      def validate_path(path, current)
        path.assert_argument(Array, 'path')
        current.assert_argument(Array, 'current')
        raise EntryKeyError, 'Path is empty' if path.empty?
      end

      attr_reader :data
    end
  end
end
