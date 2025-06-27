# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/patches/module/require_sub'
require 'zeitwerk'

module EacRubyUtils
  class RootModuleSetup
    require_sub __FILE__, require_mode: :kernel

    DEFAULT_NAMESPACE = ::Object
    LIB_DIRECTORY_BASENAME = 'lib'

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

    # @return [Module, nil]
    def extension_for
      dirname = ::File.dirname(relative_root_module_file)
      return nil if ['.', '/', ''].include?(dirname)

      require dirname
      ::ActiveSupport::Inflector.constantize(dirname.camelize)
    end

    # @return [Zeitwerk::GemLoader]
    def loader
      @loader ||= ::Zeitwerk::Registry.loader_for_gem(
        root_module_file,
        namespace: namespace,
        warn_on_extra_files: true
      )
    end

    # @return [Module]
    def namespace
      extension_for || DEFAULT_NAMESPACE
    end

    # @return [void]
    def perform
      perform_block
      perform_zeitwerk
    end

    # @return [String]
    def relative_root_module_file
      count = 0
      current = ::File.basename(root_module_file, '.*')
      dirname = ::File.dirname(root_module_file)
      loop do
        ibr if dirname == '/'

        break current if ::File.basename(dirname) == LIB_DIRECTORY_BASENAME

        current = ::File.join(::File.basename(dirname), current)
        dirname = ::File.dirname(dirname)

        count += 1
      end
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
  end
end
