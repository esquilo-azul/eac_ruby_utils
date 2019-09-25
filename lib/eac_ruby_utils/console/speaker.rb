# frozen_string_literal: true

require 'colorize'
require 'io/console'
require 'eac_ruby_utils/options_consumer'
require 'eac_ruby_utils/console/speaker/list'

module EacRubyUtils
  module Console
    # https://github.com/fazibear/colorize
    module Speaker
      def puts(string = '')
        STDERR.puts(string.to_s) # rubocop:disable Style/StderrPuts
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
        options = ::EacRubyUtils::OptionsConsumer.new(options)
        bool, list, noecho = options.consume_all(:bool, :list, :noecho)
        options.validate
        if list
          request_from_list(question, list, noecho)
        elsif bool
          request_from_bool(question, noecho)
        else
          request_string(question, noecho)
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

      private

      def list_value(list, input)
        values = list_values(list)
        return input, true unless values
        return input, false unless values.include?(input)
      end

      def list_values(list)
        if list.is_a?(::Hash)
          list.keys.map(&:to_s)
        elsif list.is_a?(::Array)
          list.map(&:to_s)
        end
      end

      def request_from_bool(question, noecho)
        request_from_list(question, { yes: true, y: true, no: false, n: false }, noecho)
      end

      def request_from_list(question, list, noecho)
        list = ::EacRubyUtils::Console::Speaker::List.build(list)
        loop do
          input = request_string("#{question} [#{list.valid_labels.join('/')}]", noecho)
          return list.build_value(input) if list.valid_value?(input)

          warn "Invalid input: \"#{input}\" (Valid: #{list.valid_labels.join(', ')})"
        end
      end

      def request_string(question, noecho)
        STDERR.write "#{question}: ".to_s.yellow
        if noecho
          r = STDIN.noecho(&:gets).chomp.strip
          STDERR.write("\n")
          r
        else
          STDIN.gets.chomp.strip
        end
      end
    end
  end
end
