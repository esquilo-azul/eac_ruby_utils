# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/acts_as_instance_method'
require 'eac_ruby_utils/patches/object/to_pathname'
require 'eac_ruby_utils/patches/pathname/basename_sub'

module EacRubyUtils
  class RootModuleSetup
    class Ignore
      acts_as_instance_method
      enable_simple_cache
      common_constructor :setup, :path do
        self.path = path.to_pathname
      end
      delegate :loader, :root_module_directory, to: :setup

      # @return [Set]
      def result
        count_before = loader.send(:ignored_paths).count
        result = loader.ignore target_path
        target_path = absolute_path.basename_sub { |b| "#{b.basename('.*')}.rb" }
        return result if result.count > count_before

        raise ::ArgumentError, [
          "Trying to ignore path \"#{path}\" did not increase the ignored paths.",
          "Argument path: \"#{path}\"", "Target path: \"#{target_path}\"",
          "Ignored paths: #{result}"
        ].join("\n")
      end

      protected

      # @return [Pathname]
      def absolute_path_uncached
        path.expand_path(root_module_directory)
      end
    end
  end
end
