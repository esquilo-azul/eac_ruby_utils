# frozen_string_literal: true

class Object
  def pretty_debug(options = {})
    print_debug_title(options)

    STDERR.write(pretty_inspect)

    self
  end

  def print_debug(options = {})
    print_debug_title(options)
    STDERR.write(to_debug + "\n")

    self
  end

  def print_debug_title(title)
    if title.is_a?(::Hash)
      return unless title[:title]

      title = title[:title]
    end
    char = '='
    STDERR.write(char * (4 + title.length) + "\n")
    STDERR.write("#{char} #{title} #{char}\n")
    STDERR.write(char * (4 + title.length) + "\n")
  end

  def to_debug
    "|#{::Object.instance_method(:to_s).bind(self).call}|#{self}|"
  end

  def raise_debug
    raise to_debug
  end
end
