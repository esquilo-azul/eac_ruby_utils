# frozen_string_literal: true

require 'eac_ruby_utils/listable'

RSpec.describe EacRubyUtils::Listable do
  let(:stub_class) do
    the_described_class = described_class
    Class.new do
      class << self
        def name
          'Stub'
        end
      end

      include the_described_class

      attr_accessor :inteiro, :code, :cadeia, :type

      lists.add_integer :inteiro, :a, :b, :c
      lists.add_integer :code, 7 => :a, 13 => :b
      lists.add_string :cadeia, :a, :b, :c
      lists.add_string :type, 'Namespace::ClazzA' => :a, 'Namespace::ClazzB' => :b
      lists.add_symbol :simbolo, :a, :b, :c
      lists.add_symbol :tipado, :tipo_aaa => :a, 'tipo_bbb' => :b
    end
  end

  describe 'attribute values' do
    it { expect(stub_class.lists.inteiro.values).to eq([1, 2, 3]) }
    it { expect(stub_class.lists.code.values).to eq([7, 13]) }
    it { expect(stub_class.lists.cadeia.values).to eq(%w[a b c]) }
    it { expect(stub_class.lists.type.values).to eq(%w[Namespace::ClazzA Namespace::ClazzB]) }
    it { expect(stub_class.lists.simbolo.values).to eq(%i[a b c]) }
    it { expect(stub_class.lists.tipado.values).to eq(%i[tipo_aaa tipo_bbb]) }
  end

  describe 'value instance options' do
    it {
      expect(stub_class.lists.inteiro.options)
        .to eq([['Inteiro A', 1], ['Inteiro BB', 2], ['Inteiro CCC', 3]])
    }

    it {
      expect(stub_class.lists.code.options)
        .to eq([['Código A', 7], ['Código B', 13]])
    }

    it {
      expect(stub_class.lists.cadeia.options)
        .to eq([['Cadeia AAA', 'a'], ['Cadeia BB', 'b'], ['Cadeia C', 'c']])
    }

    it {
      expect(stub_class.lists.type.options)
        .to eq([['Tipo A', 'Namespace::ClazzA'], ['Tipo B', 'Namespace::ClazzB']])
    }

    it {
      expect(stub_class.lists.simbolo.options)
        .to eq([['Simbolo A', :a], ['Simbolo B', :b], ['Simbolo C', :c]])
    }

    it {
      expect(stub_class.lists.tipado.options)
        .to eq([['Tipado A', :tipo_aaa], ['Tipado B', :tipo_bbb]])
    }
  end

  describe 'constants' do
    it { expect(stub_class::INTEIRO_A).to eq(1) }
    it { expect(stub_class::INTEIRO_B).to eq(2) }
    it { expect(stub_class::INTEIRO_C).to eq(3) }
    it { expect(stub_class::CODE_A).to eq(7) }
    it { expect(stub_class::CODE_B).to eq(13) }
    it { expect(stub_class::CADEIA_A).to eq('a') }
    it { expect(stub_class::CADEIA_C).to eq('c') }
    it { expect(stub_class::TYPE_A).to eq('Namespace::ClazzA') }
    it { expect(stub_class::TYPE_B).to eq('Namespace::ClazzB') }
    it { expect(stub_class::SIMBOLO_A).to eq(:a) }
    it { expect(stub_class::SIMBOLO_B).to eq(:b) }
    it { expect(stub_class::SIMBOLO_C).to eq(:c) }
    it { expect(stub_class::TIPADO_A).to eq(:tipo_aaa) }
    it { expect(stub_class::TIPADO_B).to eq(:tipo_bbb) }
  end

  describe 'values instances' do
    it { expect(stub_class.lists.is_a?(EacRubyUtils::Listable::Lists)).to be(true) }

    it {
      expect(stub_class.lists.inteiro.value_a.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.inteiro.value_b.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.inteiro.value_c.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.code.value_a.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.code.value_b.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.cadeia.value_a.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.cadeia.value_b.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.cadeia.value_c.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.type.value_a.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }

    it {
      expect(stub_class.lists.type.value_b.is_a?(EacRubyUtils::Listable::Item))
        .to be(true)
    }
  end

  describe 'value instance label' do
    it { expect(stub_class.lists.inteiro.value_a.label).to eq('Inteiro A') }
    it { expect(stub_class.lists.inteiro.value_b.label).to eq('Inteiro BB') }
    it { expect(stub_class.lists.inteiro.value_c.label).to eq('Inteiro CCC') }
    it { expect(stub_class.lists.code.value_a.label).to eq('Código A') }
    it { expect(stub_class.lists.code.value_b.label).to eq('Código B') }
    it { expect(stub_class.lists.cadeia.value_a.label).to eq('Cadeia AAA') }
    it { expect(stub_class.lists.cadeia.value_b.label).to eq('Cadeia BB') }
    it { expect(stub_class.lists.cadeia.value_c.label).to eq('Cadeia C') }
    it { expect(stub_class.lists.type.value_a.label).to eq('Tipo A') }
    it { expect(stub_class.lists.type.value_b.label).to eq('Tipo B') }
  end

  describe 'value instance description' do
    it { expect(stub_class.lists.inteiro.value_a.description).to eq('Inteiro A Descr.') }
    it { expect(stub_class.lists.inteiro.value_b.description).to eq('Inteiro BB Descr.') }
    it { expect(stub_class.lists.inteiro.value_c.description).to eq('Inteiro CCC Descr.') }
    it { expect(stub_class.lists.code.value_a.description).to eq('Código A Descr.') }
    it { expect(stub_class.lists.code.value_b.description).to eq('Código B Descr.') }
    it { expect(stub_class.lists.cadeia.value_a.description).to eq('Cadeia AAA Descr.') }
    it { expect(stub_class.lists.cadeia.value_b.description).to eq('Cadeia BB Descr.') }
    it { expect(stub_class.lists.cadeia.value_c.description).to eq('Cadeia C Descr.') }
    it { expect(stub_class.lists.type.value_a.description).to eq('Tipo A Descr.') }
    it { expect(stub_class.lists.type.value_b.description).to eq('Tipo B Descr.') }
  end

  describe 'value instance constant name' do
    it { expect(stub_class.lists.inteiro.value_a.constant_name).to eq('INTEIRO_A') }
    it { expect(stub_class.lists.inteiro.value_b.constant_name).to eq('INTEIRO_B') }
    it { expect(stub_class.lists.inteiro.value_c.constant_name).to eq('INTEIRO_C') }
    it { expect(stub_class.lists.code.value_a.constant_name).to eq('CODE_A') }
    it { expect(stub_class.lists.code.value_b.constant_name).to eq('CODE_B') }
    it { expect(stub_class.lists.cadeia.value_a.constant_name).to eq('CADEIA_A') }
    it { expect(stub_class.lists.cadeia.value_b.constant_name).to eq('CADEIA_B') }
    it { expect(stub_class.lists.cadeia.value_c.constant_name).to eq('CADEIA_C') }
    it { expect(stub_class.lists.type.value_a.constant_name).to eq('TYPE_A') }
    it { expect(stub_class.lists.type.value_b.constant_name).to eq('TYPE_B') }
  end

  describe 'instance label and descriptions' do
    let(:instance) { stub_class.new }

    {
      inteiro: {
        INTEIRO_A: ['Inteiro A', 'Inteiro A Descr.'],
        INTEIRO_B: ['Inteiro BB', 'Inteiro BB Descr.'],
        INTEIRO_C: ['Inteiro CCC', 'Inteiro CCC Descr.'],
        nil => ['Inteiro em branco', 'Inteiro em branco Descr.']
      },
      code: {
        CODE_A: ['Código A', 'Código A Descr.'],
        CODE_B: ['Código B', 'Código B Descr.'],
        nil => ['', '']
      },
      cadeia: {
        CADEIA_A: ['Cadeia AAA', 'Cadeia AAA Descr.'],
        CADEIA_B: ['Cadeia BB', 'Cadeia BB Descr.'],
        CADEIA_C: ['Cadeia C', 'Cadeia C Descr.']
      },
      type: {
        TYPE_A: ['Tipo A', 'Tipo A Descr.'],
        TYPE_B: ['Tipo B', 'Tipo B Descr.']
      }
    }.each do |attr, attr_values|
      attr_values.each do |attr_value_const, expected_values|
        context "when #{attr} value is #{attr_value_const}" do
          let(:attr_value) { attr_value_const ? stub_class.const_get(attr_value_const) : nil }

          before { instance.send("#{attr}=", attr_value) }

          it { expect(instance.send("#{attr}_label")).to eq(expected_values[0]) }
          it { expect(instance.send("#{attr}_description")).to eq(expected_values[1]) }
        end
      end
    end
  end

  describe '#value_validate!' do
    it { expect { stub_class.lists.inteiro.value_validate!(1) }.not_to raise_error }
    it { expect { stub_class.lists.inteiro.value_validate!('1') }.to raise_error(StandardError) }
    it { expect { stub_class.lists.inteiro.value_validate!(10) }.to raise_error(StandardError) }
    it { expect { stub_class.lists.cadeia.value_validate!(:a) }.to raise_error(StandardError)  }
    it { expect { stub_class.lists.cadeia.value_validate!('a') }.not_to raise_error }
    it { expect { stub_class.lists.cadeia.value_validate!(:z) }.to raise_error(StandardError) }
  end
end
