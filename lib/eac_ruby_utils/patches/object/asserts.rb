# frozen_string_literal: true

class Object
  def assert_argument(klass, argument_name)
    return if is_a?(klass)
    raise ::ArgumentError,
          "Argument \"#{argument_name}\" is not a #{klass}" \
          "(Actual class: #{self.class}, actual value: #{self})"
  end
end
