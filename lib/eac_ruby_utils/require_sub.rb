# frozen_string_literal: true

module EacRubyUtils
  class << self
    def require_sub(file)
      ::EacRubyUtils::RequireSub.new(file).apply
    end
  end

  class RequireSub
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def apply
      require_sub_files
    end

    private

    def require_sub_files
      Dir["#{File.dirname(file)}/#{::File.basename(file, '.*')}/*.rb"].sort.each do |path|
        require path
      end
    end
  end
end
