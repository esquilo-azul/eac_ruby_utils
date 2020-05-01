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

        # Shortcut to +EacRubyUtils::Fs::Temp::Directory.new(*tempfile_args)+.
        #
        # @return [Pathname]
        def directory(*tempfile_args)
          ::EacRubyUtils::Fs::Temp::Directory.new(*tempfile_args)
        end

        # Shortcut to +EacRubyUtils::Fs::Temp::File.new(*tempfile_args)+.
        #
        # @return [Pathname]
        def file(*tempfile_args)
          ::EacRubyUtils::Fs::Temp::File.new(*tempfile_args)
        end

        # Run a block while a temporary file pathname is providade. The file is deleted when block
        # is finished.
        def on_file(*tempfile_args)
          temp_file = file(*tempfile_args)
          begin
            yield(temp_file)
          ensure
            temp_file.remove
          end
        end
      end
    end
  end
end
