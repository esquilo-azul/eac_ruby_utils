module EacRubyUtils
  module Console
    # https://github.com/fazibear/colorize
    module Speaker
      def puts(s = '')
        STDERR.puts(s)
      end

      def out(s = '')
        STDOUT.write(s)
      end

      def fatal_error(s)
        puts "ERROR: #{s}".white.on_red
        Kernel.exit 1
      end

      def title(s)
        puts(('-' * (8 + s.length)).green)
        puts("--- #{s} ---".green)
        puts(('-' * (8 + s.length)).green)
        puts
      end

      def info(s)
        puts s.white
      end

      def warn(s)
        puts s.yellow
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

      def success(s)
        puts s.green
      end
    end
  end
end
