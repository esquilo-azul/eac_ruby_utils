# frozen_string_literal: true

require 'eac_ruby_utils/patches/object/debug'

module EacRubyUtils
  module EnumerablesMethods
    class << self
      WRITE_METHOD_PATTERNS = [/\A[a-z].*[\!\=]\z/i] +
                              %i[\[\]= <<].map { |m| /\A#{::Regexp.quote(m)}\z/ } +
                              %i[add clear delete divide keep reset shift subtract]
                                .map { |m| /\A#{::Regexp.quote(m)}.*\z/ }

      # @param klass [Klass]
      # @return [Enumerable<Symbol>]
      def self_methods_names(klass)
        (klass.public_instance_methods - klass.superclass.public_instance_methods).sort
      end

      # @param method_name [Symbol]
      # @return [Boolean]
      def write_method?(method_name)
        WRITE_METHOD_PATTERNS.any? { |pattern| pattern.match?(method_name.to_s) }
      end
    end

    ARRAY_METHODS = self_methods_names(::Array)
    ARRAY_WRITE_METHODS = ARRAY_METHODS.select { |m| write_method?(m) }
    ARRAY_READ_METHODS = ARRAY_METHODS - ARRAY_WRITE_METHODS

    ENUMERABLE_METHODS = ::Enumerable.public_instance_methods.sort
    ENUMERABLE_WRITE_METHODS = ENUMERABLE_METHODS.select { |m| write_method?(m) }
    ENUMERABLE_READ_METHODS = ENUMERABLE_METHODS - ENUMERABLE_WRITE_METHODS

    HASH_METHODS = self_methods_names(::Hash)
    HASH_WRITE_METHODS = HASH_METHODS.select { |m| write_method?(m) }
    HASH_READ_METHODS = HASH_METHODS - HASH_WRITE_METHODS

    SET_METHODS = self_methods_names(::Set)
    SET_WRITE_METHODS = SET_METHODS.select { |m| write_method?(m) } + [:merge]
    SET_READ_METHODS = SET_METHODS - SET_WRITE_METHODS
  end
end
