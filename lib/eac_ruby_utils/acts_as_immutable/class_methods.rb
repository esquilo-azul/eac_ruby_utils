# frozen_string_literal: true

module EacRubyUtils
  module ActsAsImmutable
    module ClassMethods
      def immutable_accessor(*accessors)
        options = accessors.extract_options!
        options[:type] ||= const_get('TYPE_COMMON')
        accessors.each do |name|
          class_name = options.fetch(:type).to_s.camelize + 'Accessor'
          ::EacRubyUtils::ActsAsImmutable.const_get(class_name).new(name).apply(self)
        end
      end

      private

      def imutable_single_accessor(name, options); end
    end
  end
end
