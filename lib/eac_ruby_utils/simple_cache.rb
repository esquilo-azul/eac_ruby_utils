# frozen_string_literal: true

module EacRubyUtils
  module SimpleCache
    UNCACHED_METHOD_NAME_SUFFIX = '_uncached'
    UNCACHED_METHOD_PATTERN = /\A(\s+)_#{::Regexp.quote(UNCACHED_METHOD_NAME_SUFFIX)}\z/.freeze

    class << self
      def uncached_method_name(method_name)
        "#{method_name}#{UNCACHED_METHOD_NAME_SUFFIX}"
      end
    end

    def method_missing(method, *args, &block)
      uncached_method = ::EacRubyUtils::SimpleCache.uncached_method_name(method)
      if respond_to?(uncached_method, true)
        call_method_with_cache(uncached_method, args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_all = false)
      if method.to_s.end_with?('_uncached')
        super
      else
        respond_to?("#{method}_uncached", true) || super
      end
    end

    def reset_cache(*keys)
      if keys.any?
        keys.each { |key| cache_keys.delete(key) }
      else
        @cache_keys = nil
      end
    end

    private

    def call_method_with_cache(method, args, &block)
      raise 'Não é possível realizar o cache de métodos com bloco' if block

      key = ([method] + args).join('@@@')
      cache_keys[key] = send(method, *args) unless cache_keys.key?(key)
      cache_keys[key]
    end

    def cache_keys
      @cache_keys ||= {}
    end
  end
end
