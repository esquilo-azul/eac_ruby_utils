# frozen_string_literal: true

module EacRubyUtils
  module Fs
    module Extname
      common_concern
      class_methods do
        # A [File.extname] which find multiple extensions (Ex.: .tar.gz).
        def extname(path, limit = -1)
          recursive_extension(::File.basename(path), limit)
        end

        # Shortcut to +extname(2)+.
        def extname2(path)
          extname(path, 2)
        end

        private

        def recursive_extension(basename, limit)
          return '' if limit.zero?

          m = /\A(.+)(\.[a-z][a-z0-9]*)\z/i.match(basename)
          if m
            "#{recursive_extension(m[1], limit - 1)}#{m[2]}"
          else
            ''
          end
        end
      end
    end
  end
end
