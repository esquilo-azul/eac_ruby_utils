# frozen_string_literal: true

module EacRubyUtils
  module SimpleCache
    UNCACHED_METHOD_PATTERN = /\A(\s+)_uncached\z/

    def method_missing(method, *args, &block)
      uncached_method = "#{method}_uncached"
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

    def reset_cache
      @cache_keys = nil
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
