# frozen_string_literal: true

module EacRubyUtils
  module Console
    # https://github.com/fazibear/colorize
    module Speaker
      def puts(string = '')
        STDERR.puts(string)
      end

      def out(string = '')
        STDOUT.write(string)
      end

      def fatal_error(string)
        puts "ERROR: #{string}".white.on_red
        Kernel.exit 1
      end

      def title(string)
        puts(('-' * (8 + string.length)).green)
        puts("--- #{string} ---".green)
        puts(('-' * (8 + string.length)).green)
        puts
      end

      def info(string)
        puts string.white
      end

      def warn(string)
        puts string.yellow
      end

      def infov(*args)
        r = []
        args.each_with_index do |v, i|
          if i.even?
            r << "#{v}: ".cyan
          else
            r.last << v.to_s
          end
        end
        puts r.join(', ')
      end

      def success(string)
        puts string.green
      end
    end
  end
end
