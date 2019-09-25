# frozen_string_literal: true

module EacRubyUtils
  class FilesystemCache
    CONTENT_FILE_NAME = '__content__'

    attr_reader :path

    def initialize(*path_parts)
      raise ArgumentError, "\"#{path_parts}\" is empty" if path_parts.empty?

      @path = ::File.expand_path(::File.join(*path_parts.map(&:to_s)))
    end

    def clear
      return unless cached?

      ::File.unlink(content_path)
    end

    def read
      return nil unless cached?

      ::File.read(content_path)
    end

    def write(value)
      assert_directory_on_path
      ::File.write(content_path, value)
      value
    end

    def child(*child_path_parts)
      self.class.new(path, *child_path_parts)
    end

    def cached?
      ::File.exist?(content_path)
    end

    def content_path
      ::File.join(path, CONTENT_FILE_NAME)
    end

    private

    def assert_directory_on_path
      raise "#{path} is a file" if ::File.file?(path)

      ::FileUtils.mkdir_p(path)
    end
  end
end
