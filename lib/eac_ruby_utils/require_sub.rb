# frozen_string_literal: true

module EacRubyUtils
  class << self
    def require_sub(file)
      Dir["#{File.dirname(file)}/#{::File.basename(file, '.*')}/*.rb"].sort.each do |path|
        require path
      end
    end
  end
end
