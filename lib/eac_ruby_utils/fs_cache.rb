# frozen_string_literal: true

require 'eac_ruby_utils/filesystem_cache'
require 'tmpdir'

module EacRubyUtils
  class << self
    def fs_cache
      @fs_cache ||= ::EacRubyUtils::FilesystemCache.new(::Dir.tmpdir, 'eac_ruby_utils_fs_cache')
    end
  end
end
