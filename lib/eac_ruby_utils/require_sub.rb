# frozen_string_literal: true

module EacRubyUtils
  class << self
    def require_sub(file, options = {})
      ::EacRubyUtils::RequireSub.new(file, options).apply
    end
  end

  class RequireSub
    BASE_OPTION_KEY = :base
    INCLUDE_MODULES_OPTION_KEY = :include_modules
    REQUIRE_DEPENDENCY_OPTION_KEY = :require_dependency

    attr_reader :file, :options

    def initialize(file, options = {})
      @file = file
      @options = options
    end

    def apply
      require_sub_files
      include_modules
    end

    private

    def include_modules
      return unless options[INCLUDE_MODULES_OPTION_KEY]

      base.constants.each do |constant_name|
        constant = base.const_get(constant_name)
        next unless constant.is_a?(::Module) && !constant.is_a?(::Class)

        base.include(constant)
      end
    end

    def base
      options[BASE_OPTION_KEY] || raise('Option :base not setted')
    end

    def require_sub_files
      Dir["#{File.dirname(file)}/#{::File.basename(file, '.*')}/*.rb"].sort.each do |path|
        if options[REQUIRE_DEPENDENCY_OPTION_KEY]
          require_dependency path
        else
          require path
        end
      end
    end
  end
end
