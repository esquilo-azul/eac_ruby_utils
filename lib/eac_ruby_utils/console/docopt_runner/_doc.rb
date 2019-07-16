# frozen_string_literal: true

module EacRubyUtils
  module Console
    class DocoptRunner
      PROGRAM_MACRO = '__PROGRAM__'

      def source_doc
        setting_value(:doc)
      end

      def target_doc
        source_doc.gsub(PROGRAM_MACRO, program_name).strip + "\n"
      end

      def program_name
        setting_value(:program_name, false) || ENV['PROGRAM_NAME'] || $PROGRAM_NAME
      end
    end
  end
end
