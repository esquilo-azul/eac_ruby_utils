# frozen_string_literal: true

class Object
  def pretty_debug(options = {})
    print_debug_options(options)

    STDERR.write(pretty_inspect)

    self
  end

  def print_debug(options = {})
    print_debug_options(options)
    STDERR.write(to_debug + "\n")

    self
  end

  def print_debug_options(options)
    options[:title].if_present { |v| print_debug_title(v) }
  end

  def print_debug_title(title)
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
