# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'yaml'
require 'eac_ruby_utils/patches/hash/sym_keys_hash'
require 'eac_ruby_utils/paths_hash'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class Configs
    include ::EacRubyUtils::SimpleCache

    attr_reader :configs_key, :options

    # Valid options: [:storage_path]
    def initialize(configs_key, options = {})
      @configs_key = configs_key
      @options = options.to_sym_keys_hash.freeze
      load
    end

    def clear
      self.data = ::EacRubyUtils::PathsHash.new({})
    end

    def save
      ::File.write(storage_path, data.to_h.to_yaml)
    end

    def load
      self.data = ::EacRubyUtils::PathsHash.new(YAML.load_file(storage_path))
    end

    def []=(entry_key, entry_value)
      write_entry(entry_key, entry_value)
    end

    def write_entry(entry_key, entry_value)
      data[entry_key] = entry_value
      save if autosave?
    end

    def [](entry_key)
      read_entry(entry_key)
    end

    def read_entry(entry_key)
      data[entry_key]
    end

    def autosave?
      options[:autosave] ? true : false
    end

    private

    attr_accessor :data

    def storage_path_uncached
      path = options[:storage_path] || default_storage_path
      return path if ::File.exist?(path) && ::File.size(path).positive?

      ::FileUtils.mkdir_p(::File.dirname(path))
      ::File.write(path, {}.to_yaml)
      path
    end

    def options_storage_path
      options[:storage_path]
    end

    def default_storage_path
      ::File.join(ENV['HOME'], '.config', configs_key, 'settings.yml')
    end
  end
end
