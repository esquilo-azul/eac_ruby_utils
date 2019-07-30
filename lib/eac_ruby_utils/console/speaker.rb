# frozen_string_literal: true

require 'colorize'

module EacRubyUtils
  module Console
    # https://github.com/fazibear/colorize
    module Speaker
      def puts(string = '')
        STDERR.puts(string.to_s)
      end

      def out(string = '')
        STDOUT.write(string.to_s)
      end

      def fatal_error(string)
        puts "ERROR: #{string}".white.on_red
        Kernel.exit 1
      end

      def title(string)
        string = string.to_s
        puts(('-' * (8 + string.length)).green)
        puts("--- #{string} ---".green)
        puts(('-' * (8 + string.length)).green)
        puts
      end

      def info(string)
        puts string.to_s.white
      end

      def infom(string)
        puts string.to_s.light_yellow
      end

      def warn(string)
        puts string.to_s.yellow
      end

      def request_input(question, options = {})
        STDERR.write "#{question}: ".to_s.yellow
        if options[:noecho]
          r = STDIN.noecho(&:gets).chomp.strip
          STDERR.write("\n")
          r
        else
          gets.chomp.strip
        end
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
        puts string.to_s.green
      end
    end
  end
end
