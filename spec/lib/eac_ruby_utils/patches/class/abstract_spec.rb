# frozen_string_literal: true

require 'eac_ruby_utils/patches/class/abstract'

RSpec.describe ::Class do
  let(:abstract_class) do
    described_class.new do
      enable_abstract_methods
    end
  end

  let(:concrect_class) do
    described_class.new(abstract_class)
  end

  describe '#abstract' do
    it do
      expect(abstract_class).to be_abstract
    end

    it do
      expect(concrect_class).not_to be_abstract
    end
  end
end
