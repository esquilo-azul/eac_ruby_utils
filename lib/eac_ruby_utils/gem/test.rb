# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/fs_cache'
require 'eac_ruby_utils/listable'
require 'eac_ruby_utils/on_clean_ruby_environment'

module EacRubyUtils
  class Gem
    class Test
      include ::EacRubyUtils::Listable

      enable_simple_cache
      lists.add_string :result, :failed, :nonexistent, :successful

      common_constructor :gem

      def elegible?
        dependency_present? && gem.root.join(test_directory).exist?
      end

      def dependency_present?
        gem.gemfile_path.exist? && gem.gemfile_lock_gem_version(dependency_gem).present?
      end

      def name
        self.class.name.demodulize.gsub(/Test\z/, '')
      end

      def stdout_cache
        root_cache.child('stdout')
      end

      def stderr_cache
        root_cache.child('stderr')
      end

      def to_s
        "#{gem}[#{name}]"
      end

      private

      def result_uncached
        return RESULT_NONEXISTENT unless elegible?
        bundle_run ? RESULT_SUCCESSFUL : RESULT_FAILED
      end

      def bundle_run
        r = ::EacRubyUtils.on_clean_ruby_environment do
          gem.bundle('exec', *bundle_exec_args).execute
        end
        stdout_cache.write(r[:stdout])
        stderr_cache.write(r[:stderr])
        r[:exit_code].zero?
      end

      def root_cache
        ::EacRubyUtils.fs_cache.child(gem.root.to_s.parameterize, self.class.name.parameterize)
      end
    end
  end
end
