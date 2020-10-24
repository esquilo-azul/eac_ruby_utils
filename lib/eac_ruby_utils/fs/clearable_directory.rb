# frozen_string_literal: true

require 'fileutils'
require 'pathname'

module EacRubyUtils
  module Fs
    class ClearableDirectory < ::Pathname
      CLEARABLE_BASENAME = '.clearable_directory'

      def clear
        validate_clearable
        directory? ? clear_directory : clear_no_directory
        mkpath
        ::FileUtils.touch(clearable_note_file.to_path)
        self
      end

      def clearable?
        clearable_negate_message ? true : false
      end

      def clearable_negate_message
        return if !exist? || empty?
        return "Path \"#{self}\" exists, is not empty and is not a directory" unless directory?
        return if clearable_note_file.exist?

        "Directory \"#{self}\" is not empty and does not have a #{CLEARABLE_BASENAME} file"
      end

      def clearable_note_file
        join(CLEARABLE_BASENAME)
      end

      def validate_clearable
        message = clearable_negate_message
        raise message if message
      end

      private

      def clear_directory
        children.each do |child|
          if child.directory?
            child.rmtree
          elsif child.file?
            child.unlink
          end
        end
      end

      def clear_no_directory
        ::FileUtils.rm_rf(to_path)
      end
    end
  end
end
