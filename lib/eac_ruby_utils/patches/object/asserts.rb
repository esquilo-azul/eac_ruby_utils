# frozen_string_literal: true

class Object
  # Raises a ArgumentError if +self+ is not a +klass+.
  #
  # @return +self+
  def assert_argument(klass, argument_name = 'unknown_argument_name')
    return self if is_a?(klass)

    raise ::ArgumentError,
          "Argument \"#{argument_name}\" is not a #{klass}" \
          "(Actual class: #{self.class}, actual value: #{self})"
  end

  # Raises a ArgumentError if +self.count+ is not equal to +count+.
  #
  # @return +self+
  def assert_count(count, argument_name = 'unknown_argument_name')
    return self if self.count == count

    raise ::ArgumentError,
          "Argument \"#{argument_name}\" has wrong elements count" \
          "(Actual: #{self.count}, Required: #{count})"
  end
end
