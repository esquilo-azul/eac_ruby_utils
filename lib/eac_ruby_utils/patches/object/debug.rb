# frozen_string_literal: true

require 'eac_ruby_utils/compact'
require 'eac_ruby_utils/patches/object/if_present'
require 'pp'

class Object
  # @param attributes [Enumerable<Symbol>] Attributes for +EacRubyUtils::Compact.new+.
  # @return [void]
  def compact_debug(*attributes)
    ::EacRubyUtils::Compact.new(self, attributes).to_h.each do |name, value|
      value.print_debug(label: name)
    end
  end

  def pretty_debug(options = {})
    print_debug_options(options)

    $stderr.write(pretty_inspect)

    self
  end

  def print_debug(options = {})
    print_debug_options(options)
    $stderr.write("#{to_debug}\n")

    self
  end

  def print_debug_label(label)
    $stderr.write("#{label}: ")
  end

  def print_debug_options(options)
    options[:title].if_present { |v| print_debug_title(v) }
    options[:label].if_present { |v| print_debug_label(v) }
  end

  def print_debug_title(title)
    char = '='
    $stderr.write("#{char * (4 + title.length)}\n")
    $stderr.write("#{char} #{title} #{char}\n")
    $stderr.write("#{char * (4 + title.length)}\n")
  end

  def to_debug
    "|#{::Object.instance_method(:to_s).bind(self).call}|#{self}|"
  end

  def raise_debug
    raise to_debug
  end
end
