# frozen_string_literal: true

module EacRubyUtils
  class StringDelimited
    attr_reader :string, :begin_delimiter, :end_delimiter

    def initialize(string, begin_delimiter, end_delimiter)
      @string = string
      @begin_delimiter = begin_delimiter
      @end_delimiter = end_delimiter
    end

    def inner
      between_indexes(content_index, end_index).to_s
    end

    def outer
      between_indexes(begin_index, after_end_index).to_s
    end

    def without_inner
      without_join(
        between_indexes(sos_index, content_index), between_indexes(end_index, eos_index)
      )
    end

    def without_outer
      without_join(
        between_indexes(sos_index, begin_index),
        between_indexes(after_end_index, eos_index)
      )
    end

    private

    def after_end_index
      end_index.if_present { |v| v + end_delimiter.length }
    end

    def begin_index
      string.index(begin_delimiter)
    end

    def between_indexes(a_begin_index, a_end_index)
      a_begin_index && a_end_index ? string[a_begin_index, a_end_index - a_begin_index] : nil
    end

    def content_index
      begin_index.if_present { |v| v + begin_delimiter.length }
    end

    def without_join(*strings)
      return string if strings.any?(&:nil?)

      strings.join('')
    end

    def end_index
      content_index.if_present { |_v| string.index(end_delimiter, content_index) }
    end

    def sos_index
      0
    end

    def eos_index
      string.length
    end
  end
end
