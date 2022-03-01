# frozen_string_literal: true

require 'eac_ruby_utils/fs/extname'
require 'pathname'

class Pathname
  def basename_noext(limit = 1)
    basename(::EacRubyUtils::Fs.extname(basename.to_path, limit))
  end
end
