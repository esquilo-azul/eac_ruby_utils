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
      if respond_to?(::EacRubyUtils::SimpleCache.uncached_method_name(method), true)
        call_method_with_cache(method, args, &block)
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
      unless cache_keys.key?(key)
        uncached_value = call_uncached_method(method, args)
        cache_keys[key] = uncached_value
      end
      cache_keys[key]
    end

    def call_uncached_method(method, args)
      send(::EacRubyUtils::SimpleCache.uncached_method_name(method), *args)
    end

    def cache_keys
      @cache_keys ||= {}
    end
  end
end
