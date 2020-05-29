# frozen_string_literal: true

require 'eac_ruby_utils/common_concern'

RSpec.describe ::EacRubyUtils::CommonConcern do
  let(:instance) do
    described_class.new do
      self.valor = 'changed'
    end
  end

  module MyModule
    module ClassMethods
      def my_class_method
        'class'
      end
    end

    module InstanceMethods
      def my_instance_method
        'instance'
      end
    end
  end

  class MyClass
    class << self
      attr_accessor :valor
    end
  end

  let(:subject) { MyClass.new }

  before do
    instance.setup(MyModule)
    MyClass.include MyModule
  end

  it { expect(subject.my_instance_method).to eq('instance') }
  it { expect(subject.class.my_class_method).to eq('class') }
  it { expect(subject.class.valor).to eq('changed') }
end
