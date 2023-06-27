# frozen_string_literal: true

module EacRubyUtils
  # The `Wildcards` class provides pattern matching with wildcards using regular expressions.
  class Wildcards
    # Initializes a new instance of the `Wildcards` class with the specified pattern.
    #
    # @param pattern [String] The pattern to match against.
    def initialize(pattern)
      @pattern = pattern
    end

    # Matches the given string against the pattern.
    #
    # @param string [String] The string to match.
    # @return [Boolean] Returns `true` if the string matches the pattern, otherwise `false`.
    delegate :match?, to: :regex

    private

    # @return [Regexp]
    def regex
      ::Regexp.new("^#{::Regexp.escape(@pattern).gsub('\*', '.*').gsub('\?', '.?')}$")
    end
  end
end
