# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'

RSpec.describe ::EacRubyUtils::CommonConstructor do
  let(:instance) { described_class.new(:a, :b) }

  class MyClass
  end

  let(:subject) { MyClass.new('Va', 'Vb') }

  before do
    instance.setup_class(::MyClass)
  end

  it { expect(subject.a).to eq('Va') }
  it { expect(subject.b).to eq('Vb') }

  %w[a b].each do |attr|
    [false, true].each do |include_all|
      it { expect(subject.respond_to?("#{attr}=", include_all)).to eq(include_all) }
    end
  end
end
