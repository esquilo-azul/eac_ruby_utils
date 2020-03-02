# frozen_string_literal: true

module EacRubyUtils
  class FilesystemTraverser
    attr_accessor :check_directory, :check_file, :recursive, :hidden_directories

    def check_path(path)
      path = ::Pathname.new(path.to_s) unless path.is_a?(::Pathname)
      internal_check_path(path, 0)
    end

    def hidden_directories?
      hidden_directories ? true : false
    end

    def recursive?
      recursive ? true : false
    end

    private

    def process_directory?(level)
      level.zero? || recursive?
    end

    def inner_check_directory(dir, level)
      return unless process_directory?(level)

      user_check_directory(dir)
      dir.each_entry do |e|
        next if %(. ..).include?(e.basename.to_s)
        next unless !e.basename.to_s.start_with?('.') || hidden_directories?

        internal_check_path(dir.join(e), level + 1)
      end
    end

    def internal_check_path(path, level)
      if path.file?
        user_check_file(path)
      elsif path.directory?
        inner_check_directory(path, level)
      else
        raise "Unknown filesystem object: #{path}"
      end
    end

    def user_check_file(path)
      check_file&.call(path)
    end

    def user_check_directory(path)
      check_directory&.call(path)
    end
  end
end
