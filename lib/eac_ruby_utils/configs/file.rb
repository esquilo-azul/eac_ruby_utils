# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'yaml'
require 'eac_ruby_utils/patches/hash/sym_keys_hash'
require 'eac_ruby_utils/paths_hash'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class Configs
    class File
      include ::EacRubyUtils::SimpleCache

      attr_reader :path, :options

      # Valid options: [:autosave]
      def initialize(path, options = {})
        @path = path
        @options = options.to_sym_keys_hash.freeze
        load
      end

      def clear
        self.data = ::EacRubyUtils::PathsHash.new({})
      end

      def save
        ::FileUtils.mkdir_p(::File.dirname(path))
        ::File.write(path, data.to_h.to_yaml)
      end

      def load
        self.data = if ::File.exist?(path) && ::File.size(path).positive?
                      ::EacRubyUtils::PathsHash.new(YAML.load_file(path))
                    else
                      {}
                    end
      end

      def []=(entry_key, entry_value)
        write(entry_key, entry_value)
      end

      def write(entry_key, entry_value)
        data[entry_key] = entry_value
        save if autosave?
      end

      def [](entry_key)
        read(entry_key)
      end

      def read(entry_key)
        data[entry_key]
      end

      def autosave?
        options[:autosave] ? true : false
      end

      private

      attr_accessor :data
    end
  end
end
