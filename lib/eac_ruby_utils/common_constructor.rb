# frozen_string_literal: true

module EacRubyUtils
  class CommonConstructor
    attr_reader :args, :options

    def initialize(*args)
      @args = args
    end

    def setup_class(klass)
      setup_class_attr_readers(klass)
      setup_class_attr_writers(klass)
      setup_class_initialize(klass)
    end

    def setup_class_attr_readers(klass)
      klass.send(:attr_reader, *args)
      klass.send(:public, *args)
    end

    def setup_class_attr_writers(klass)
      klass.send(:attr_writer, *args)
      klass.send(:private, *args.map { |a| "#{a}=" })
    end

    def setup_class_initialize(klass)
      klass.class_eval initialize_method_code, __FILE__, __LINE__
    end

    def initialize_method_code
      b = "def initialize(#{initialize_method_args_code})\n"
      initialize_method_args.each do |arg|
        b += "  self.#{arg} = #{arg}\n"
      end
      b += "end\n"
      b
    end

    def initialize_method_args_code
      initialize_method_args.join(', ')
    end

    def initialize_method_args
      args
    end
  end
end
