# frozen_string_literal: true

require 'eac_ruby_utils/patches/pathname'
require 'eac_ruby_utils/patches/object/to_pathname'
require 'zeitwerk'

module EacRubyUtils
  class RootModuleSetup
    DEFAULT_NAMESPACE = ::Object

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

    # @param path [String] Relative path to root module's directory.
    def ignore(path)
      count_before = loader.send(:ignored_paths).count
      target_path = path.to_pathname.basename_sub { |b| "#{b.basename('.*')}.rb" }
                      .expand_path(root_module_directory)
      result = loader.ignore target_path
      return result if result.count > count_before

      raise ::ArgumentError, [
        "Trying to ignore path \"#{path}\" did not increase the ignored paths.",
        "Argument path: \"#{path}\"", "Target path: \"#{target_path}\"", "Ignored paths: #{result}"
      ].join("\n")
    end

    # @return [Module]
    def namespace
      DEFAULT_NAMESPACE
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
        namespace: namespace,
        warn_on_extra_files: true
      )
    end
  end
end
