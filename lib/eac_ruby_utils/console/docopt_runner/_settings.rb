# frozen_string_literal: true

module EacRubyUtils
  module Console
    class DocoptRunner
      attr_reader :settings

      private

      def setting_value(key, required = true)
        %i[setting_from_argument setting_from_constant].each do |method|
          value = send(method, key)
          return value if value
        end
        return nil unless required

        raise "Setting \"#{key}\" not found. Declare #{setting_constant(key, true)} constant, " \
          "pass #{key.to_sym} option to #{self.class.name}.new() method."
      end

      def setting_from_argument(key)
        settings[key]
      end

      def setting_from_constant(key)
        constant_name = setting_constant(key)
        begin
          self.class.const_get(constant_name)
        rescue NameError
          nil
        end
      end

      def setting_constant(key, fullname = false)
        name = key.to_s.underscore.upcase
        name = "#{self.class.name}::#{name}" if fullname
        name
      end
    end
  end
end
