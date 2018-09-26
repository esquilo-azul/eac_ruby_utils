# frozen_string_literal: true

module EacRubyUtils
  module Console
    class DocoptRunner
      attr_reader :options

      def initialize
        @options = Docopt.docopt(doc)
        run
      rescue Docopt::Exit => e
        puts e.message
      end

      private

      def doc
        self.class.const_get('DOC').gsub('__PROGRAM__', program)
      end

      def program
        ENV['MYSELF_PROGRAM'] || $PROGRAM_NAME
      end
    end
  end
end
