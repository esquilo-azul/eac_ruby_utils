# frozen_string_literal: true

require 'zeitwerk'

module EacRubyUtils
  class RootModuleSetup
    class << self
      # @param root_module_file [String]
      def perform(root_module_file)
        new(root_module_file).perform
      end
    end

    attr_reader :root_module_file

    # @param root_module_file [String]
    def initialize(root_module_file)
      self.root_module_file = root_module_file
    end

    # @return [void]
    def perform
      loader = Zeitwerk::Loader.for_gem
      loader.setup
    end

    protected

    attr_writer :root_module_file
  end
end
