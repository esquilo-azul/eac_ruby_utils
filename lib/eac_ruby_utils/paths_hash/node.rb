# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/paths_hash/entry_key_error'

module EacRubyUtils
  class PathsHash
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

        raise(::EacRubyUtils::PathsHash::EntryKeyError,
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
        raise ::EacRubyUtils::PathsHash::EntryKeyError, 'Path is empty' if path.empty?
      end

      attr_reader :data
    end
  end
end
