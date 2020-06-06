# frozen_string_literal: true

require 'eac_ruby_utils/listable'

class Stub
  include ::EacRubyUtils::Listable

  attr_accessor :inteiro, :code, :cadeia, :type

  lists.add_integer :inteiro, :a, :b, :c
  lists.add_integer :code, 7 => :a, 13 => :b
  lists.add_string :cadeia, :a, :b, :c
  lists.add_string :type, 'Namespace::ClazzA' => :a, 'Namespace::ClazzB' => :b
  lists.add_symbol :simbolo, :a, :b, :c
  lists.add_symbol :tipado, :tipo_aaa => :a, 'tipo_bbb' => :b
end

RSpec.describe ::EacRubyUtils::Listable do
  context 'attribute values' do
    it { expect(Stub.lists.inteiro.values).to eq([1, 2, 3]) }
    it { expect(Stub.lists.code.values).to eq([7, 13]) }
    it { expect(Stub.lists.cadeia.values).to eq(%w[a b c]) }
    it { expect(Stub.lists.type.values).to eq(%w[Namespace::ClazzA Namespace::ClazzB]) }
    it { expect(Stub.lists.simbolo.values).to eq(%i[a b c]) }
    it { expect(Stub.lists.tipado.values).to eq(%i[tipo_aaa tipo_bbb]) }
  end

  context 'value instance options' do
    it {
      expect(Stub.lists.inteiro.options)
        .to eq([['Inteiro A', 1], ['Inteiro BB', 2], ['Inteiro CCC', 3]])
    }

    it {
      expect(Stub.lists.code.options)
        .to eq([['Código A', 7], ['Código B', 13]])
    }

    it {
      expect(Stub.lists.cadeia.options)
        .to eq([['Cadeia AAA', 'a'], ['Cadeia BB', 'b'], ['Cadeia C', 'c']])
    }

    it {
      expect(Stub.lists.type.options)
        .to eq([['Tipo A', 'Namespace::ClazzA'], ['Tipo B', 'Namespace::ClazzB']])
    }

    it {
      expect(Stub.lists.simbolo.options)
        .to eq([['Simbolo A', :a], ['Simbolo B', :b], ['Simbolo C', :c]])
    }

    it {
      expect(Stub.lists.tipado.options)
        .to eq([['Tipado A', :tipo_aaa], ['Tipado B', :tipo_bbb]])
    }
  end

  context 'constants' do
    it { expect(Stub::INTEIRO_A).to eq(1) }
    it { expect(Stub::INTEIRO_B).to eq(2) }
    it { expect(Stub::INTEIRO_C).to eq(3) }
    it { expect(Stub::CODE_A).to eq(7) }
    it { expect(Stub::CODE_B).to eq(13) }
    it { expect(Stub::CADEIA_A).to eq('a') }
    it { expect(Stub::CADEIA_C).to eq('c') }
    it { expect(Stub::TYPE_A).to eq('Namespace::ClazzA') }
    it { expect(Stub::TYPE_B).to eq('Namespace::ClazzB') }
    it { expect(Stub::SIMBOLO_A).to eq(:a) }
    it { expect(Stub::SIMBOLO_B).to eq(:b) }
    it { expect(Stub::SIMBOLO_C).to eq(:c) }
    it { expect(Stub::TIPADO_A).to eq(:tipo_aaa) }
    it { expect(Stub::TIPADO_B).to eq(:tipo_bbb) }
  end

  context 'values instances' do
    it { expect(Stub.lists.is_a?(::EacRubyUtils::Listable::Lists)).to eq(true) }
    it { expect(Stub.lists.inteiro.value_a.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.inteiro.value_b.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.inteiro.value_c.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.code.value_a.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.code.value_b.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.cadeia.value_a.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.cadeia.value_b.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.cadeia.value_c.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.type.value_a.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
    it { expect(Stub.lists.type.value_b.is_a?(::EacRubyUtils::Listable::Value)).to eq(true) }
  end

  context 'value instance label' do
    it { expect(Stub.lists.inteiro.value_a.label).to eq('Inteiro A') }
    it { expect(Stub.lists.inteiro.value_b.label).to eq('Inteiro BB') }
    it { expect(Stub.lists.inteiro.value_c.label).to eq('Inteiro CCC') }
    it { expect(Stub.lists.code.value_a.label).to eq('Código A') }
    it { expect(Stub.lists.code.value_b.label).to eq('Código B') }
    it { expect(Stub.lists.cadeia.value_a.label).to eq('Cadeia AAA') }
    it { expect(Stub.lists.cadeia.value_b.label).to eq('Cadeia BB') }
    it { expect(Stub.lists.cadeia.value_c.label).to eq('Cadeia C') }
    it { expect(Stub.lists.type.value_a.label).to eq('Tipo A') }
    it { expect(Stub.lists.type.value_b.label).to eq('Tipo B') }
  end

  context 'value instance description' do
    it { expect(Stub.lists.inteiro.value_a.description).to eq('Inteiro A Descr.') }
    it { expect(Stub.lists.inteiro.value_b.description).to eq('Inteiro BB Descr.') }
    it { expect(Stub.lists.inteiro.value_c.description).to eq('Inteiro CCC Descr.') }
    it { expect(Stub.lists.code.value_a.description).to eq('Código A Descr.') }
    it { expect(Stub.lists.code.value_b.description).to eq('Código B Descr.') }
    it { expect(Stub.lists.cadeia.value_a.description).to eq('Cadeia AAA Descr.') }
    it { expect(Stub.lists.cadeia.value_b.description).to eq('Cadeia BB Descr.') }
    it { expect(Stub.lists.cadeia.value_c.description).to eq('Cadeia C Descr.') }
    it { expect(Stub.lists.type.value_a.description).to eq('Tipo A Descr.') }
    it { expect(Stub.lists.type.value_b.description).to eq('Tipo B Descr.') }
  end

  context 'value instance constant name' do
    it { expect(Stub.lists.inteiro.value_a.constant_name).to eq('INTEIRO_A') }
    it { expect(Stub.lists.inteiro.value_b.constant_name).to eq('INTEIRO_B') }
    it { expect(Stub.lists.inteiro.value_c.constant_name).to eq('INTEIRO_C') }
    it { expect(Stub.lists.code.value_a.constant_name).to eq('CODE_A') }
    it { expect(Stub.lists.code.value_b.constant_name).to eq('CODE_B') }
    it { expect(Stub.lists.cadeia.value_a.constant_name).to eq('CADEIA_A') }
    it { expect(Stub.lists.cadeia.value_b.constant_name).to eq('CADEIA_B') }
    it { expect(Stub.lists.cadeia.value_c.constant_name).to eq('CADEIA_C') }
    it { expect(Stub.lists.type.value_a.constant_name).to eq('TYPE_A') }
    it { expect(Stub.lists.type.value_b.constant_name).to eq('TYPE_B') }
  end

  context 'instance label and descriptions' do
    let(:instance) { Stub.new }

    context 'when inteiro value is A' do
      before { instance.inteiro = Stub::INTEIRO_A }

      it { expect(instance.inteiro_label).to eq('Inteiro A') }
      it { expect(instance.inteiro_description).to eq('Inteiro A Descr.') }
    end

    context 'when inteiro value is A' do
      before { instance.inteiro = Stub::INTEIRO_B }

      it { expect(instance.inteiro_label).to eq('Inteiro BB') }
      it { expect(instance.inteiro_description).to eq('Inteiro BB Descr.') }
    end

    context 'when inteiro value is C' do
      before { instance.inteiro = Stub::INTEIRO_C }

      it { expect(instance.inteiro_label).to eq('Inteiro CCC') }
      it { expect(instance.inteiro_description).to eq('Inteiro CCC Descr.') }
    end

    context 'when code value is A' do
      before { instance.code = Stub::CODE_A }

      it { expect(instance.code_label).to eq('Código A') }
      it { expect(instance.code_description).to eq('Código A Descr.') }
    end

    context 'when code value is B' do
      before { instance.code = Stub::CODE_B }

      it { expect(instance.code_label).to eq('Código B') }
      it { expect(instance.code_description).to eq('Código B Descr.') }
    end

    context 'when cadeia value is A' do
      before { instance.cadeia = Stub::CADEIA_A }

      it { expect(instance.cadeia_label).to eq('Cadeia AAA') }
      it { expect(instance.cadeia_description).to eq('Cadeia AAA Descr.') }
    end

    context 'when cadeia value is B' do
      before { instance.cadeia = Stub::CADEIA_B }

      it { expect(instance.cadeia_label).to eq('Cadeia BB') }
      it { expect(instance.cadeia_description).to eq('Cadeia BB Descr.') }
    end

    context 'when cadeia value is C' do
      before { instance.cadeia = Stub::CADEIA_C }

      it { expect(instance.cadeia_label).to eq('Cadeia C') }
      it { expect(instance.cadeia_description).to eq('Cadeia C Descr.') }
    end

    context 'when type value is A' do
      before { instance.type = Stub::TYPE_A }

      it { expect(instance.type_label).to eq('Tipo A') }
      it { expect(instance.type_description).to eq('Tipo A Descr.') }
    end

    context 'when type value is B' do
      before { instance.type = Stub::TYPE_B }

      it { expect(instance.type_label).to eq('Tipo B') }
      it { expect(instance.type_description).to eq('Tipo B Descr.') }
    end
  end

  describe '#value_validate!' do
    it { expect { Stub.lists.inteiro.value_validate!(1) }.not_to raise_error }
    it { expect { Stub.lists.inteiro.value_validate!('1') }.to raise_error }
    it { expect { Stub.lists.inteiro.value_validate!(10) }.to raise_error(::StandardError) }
    it { expect { Stub.lists.cadeia.value_validate!(:a) }.to raise_error }
    it { expect { Stub.lists.cadeia.value_validate!('a') }.not_to raise_error }
    it { expect { Stub.lists.cadeia.value_validate!(:z) }.to raise_error(::StandardError) }
  end
end
