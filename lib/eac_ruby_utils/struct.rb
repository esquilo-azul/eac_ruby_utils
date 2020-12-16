# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'

module EacRubyUtils
  class Struct
    def initialize(initial_data = {})
      self.data = initial_data.symbolize_keys
    end

    def [](key)
      key, bool = parse_key(key)
      bool ? self[key].present? : data[key]
    end

    def fetch(key)
      key, bool = parse_key(key)
      bool ? fetch(key).present? : data.fetch(key)
    end

    def merge(other)
      other = self.class.new(other) unless other.is_a?(self.class)
      self.class.new(to_h.merge(other.to_h))
    end

    def method_missing(method_name, *arguments, &block)
      property_method?(method_name) ? fetch(method_name) : super
    end

    def respond_to_missing?(method_name, include_private = false)
      property_method?(method_name) || super
    end

    def slice_fetch(*keys)
      self.class.new(keys.map { |key| [key, fetch(key)] }.to_h)
    end

    def to_h
      data.dup
    end

    delegate :to_s, to: :data

    private

    attr_accessor :data

    def parse_key(key)
      m = /\A(.+)\?\z/.match(key.to_s)
      [(m ? m[1] : key.to_s).to_sym, m ? true : false]
    end

    def property_method?(key)
      property_methods.include?(key.to_sym)
    end

    def property_methods
      data.keys.flat_map { |k| [k.to_sym, "#{k}?".to_sym] }
    end
  end
end
