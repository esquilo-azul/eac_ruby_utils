# frozen_string_literal: true

require 'i18n'
require 'eac_ruby_utils/patches/class/common_constructor'
require 'eac_ruby_utils/patches/object/to_pathname'

module EacRubyUtils
  module Locales
    class FromGem
      class << self
        def include_all(i18n_obj = nil)
          ::Gem::Specification.each { |gemspec| new(gemspec, i18n_obj).include }
        end
      end

      LOCALES_DIR_SUBPATH = 'locale'
      LOCALES_FILES_GLOB_PATTERNS = %w[*.yaml *.yml].freeze

      common_constructor :gemspec, :i18n_obj, default: [nil] do
        self.i18n_obj ||= ::I18n
      end

      # @return [Boolean]
      delegate :exist?, to: :path

      # @return [Pathname, nil]
      def include
        return nil unless exist?

        ::I18n.load_path += paths_to_load.map(&:to_path)
        path
      end

      # @return [Pathname]
      def path
        gemspec.gem_dir.to_pathname.join(LOCALES_DIR_SUBPATH)
      end

      # @return [Pathname]
      def paths_to_load
        return [] unless exist?

        LOCALES_FILES_GLOB_PATTERNS.inject([]) { |a, e| a + path.glob(e) }
      end
    end
  end
end
