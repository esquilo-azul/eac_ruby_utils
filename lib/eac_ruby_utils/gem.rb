# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs'

module EacRubyUtils
  class Gem
    enable_simple_cache

    common_constructor :root
    set_callback :initialize, :after do
      @root = ::Pathname.new(root).expand_path
    end

    def to_s
      root.basename.to_s
    end

    def bundle(*args)
      ::EacRubyUtils::Envs.local.command('bundle', *args)
                          .envvar('BUNDLE_GEMFILE', gemfile_path)
                          .chdir(root)
    end

    def gemfile_lock_gem_version(gem_name)
      gemfile_lock_content.specs.find { |gem| gem.name == gem_name }.if_present(&:version)
    end

    def gemfile_lock_content
      ::Bundler::LockfileParser.new(::Bundler.read_file(gemfile_lock_path))
    end

    private

    def gemfile_path_uncached
      root.join('Gemfile')
    end

    def gemfile_lock_path_uncached
      root.join('Gemfile.lock')
    end
  end
end
