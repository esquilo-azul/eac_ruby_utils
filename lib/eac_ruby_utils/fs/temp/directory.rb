# frozen_string_literal: true

require 'eac_ruby_utils/fs/temp/file'

module EacRubyUtils
  module Fs
    module Temp
      class Directory < ::EacRubyUtils::Fs::Temp::File
        def initialize(*tempfile_args)
          super
          mkpath
        end
      end
    end
  end
end
