# frozen_string_literal: true

require 'zeitwerk'

module EacRubyUtils
  class RootModuleSetup
    class << self
      # @param root_module_file [String]
      def perform(root_module_file, &block)
        new(root_module_file, &block).perform
      end
    end

    attr_reader :block, :root_module_file

    # @param root_module_file [String]
    def initialize(root_module_file, &block)
      self.root_module_file = root_module_file
      self.block = block
    end

    # @return [void]
    def perform
      perform_block
      perform_zeitwerk
    end

    # @return [String]
    def root_module_directory
      ::File.expand_path(::File.basename(root_module_file, '.*'),
                         ::File.dirname(root_module_file))
    end

    protected

    attr_writer :block, :root_module_file

    def perform_block
      instance_eval(&block) if block
    end

    # @return [void]
    def perform_zeitwerk
      loader.setup
    end

    # @return [Zeitwerk::GemLoader]
    def loader
      @loader ||= ::Zeitwerk::Registry.loader_for_gem(
        root_module_file,
        namespace: Object,
        warn_on_extra_files: true
      )
    end
  end
end
