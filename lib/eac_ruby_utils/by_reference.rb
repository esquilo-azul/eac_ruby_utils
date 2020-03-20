module EacRubyUtils
  class ByReference
    def initialize(&object_provider)
      @object_provider = object_provider
    end
        
    def method_missing(method_name, *arguments, &block)
      return object.send(method_name, *arguments) if object.respond_to?(method_name)
      super
    end
    
    def object
      @object_provider.call
    end

    def respond_to_missing?(method_name, include_private = false)
      object.respond_to?(method_name, include_private)
    end
  end
end
