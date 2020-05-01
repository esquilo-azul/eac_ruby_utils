# frozen_string_literal: true

require 'eac_ruby_utils/require_sub'
require 'pathname'
require 'tempfile'

module EacRubyUtils
  module Fs
    # Utilities for temporary files.
    module Temp
      class << self
        ::EacRubyUtils.require_sub __FILE__

        # @return [Pathname]
        def file(*tempfile_args)
          file = Tempfile.new(*tempfile_args)
          r = ::Pathname.new(file.path)
          file.close
          file.unlink
          r
        end

        # Run a block while a temporary file pathname is providade. The file is deleted when block
        # is finished.
        def on_file(*tempfile_args)
          pathname = file(*tempfile_args)
          begin
            yield(pathname)
          ensure
            pathname.unlink if pathname.exist?
          end
        end
      end
    end
  end
end
