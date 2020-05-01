# frozen_string_literal: true

require 'pathname'
require 'tempfile'

module EacRubyUtils
  module Fs
    module Temp
      class File < Pathname
        # Temporary file
        def initialize(*tempfile_args)
          file = Tempfile.new(*tempfile_args)
          path = file.path
          file.close
          file.unlink
          super(path)
        end

        def remove
          if directory?
            rmtree
          elsif file?
            unlink
          end
        end

        def remove!
          remove
          raise "Tried to remove \"#{self}\", but it yet exists" if exist?
        end
      end
    end
  end
end
