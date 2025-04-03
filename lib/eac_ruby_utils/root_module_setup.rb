# frozen_string_literal: true

require 'zeitwerk'

module EacRubyUtils
  class RootModuleSetup
    class << self
      def perform; end
    end

    def perform
      loader = Zeitwerk::Loader.for_gem
      loader.setup
    end
  end
end
