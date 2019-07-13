# frozen_string_literal: true

require 'eac_ruby_utils/console/docopt_runner'

RSpec.describe ::EacRubyUtils::Console::DocoptRunner do
  context 'runner without DOC constant' do
    class RunnerWithoutDocConstant < ::EacRubyUtils::Console::DocoptRunner
      def run
        # Do nothing
      end
    end

    let(:options) { { argv: [] } }

    it 'raises exception if doc argument is not supplied' do
      expect { RunnerWithoutDocConstant.new(options) }.to raise_error(::StandardError)
    end

    context 'doc argument is supplied' do
      let(:doc) do
        <<~DOCUMENT
          Runner without doc constant.

          Usage:
            __PROGRAM__
          DOCUMENT
      end

      let(:options_with_doc) { options.merge(doc: doc) }

      it 'reads doc from arguments' do
        expect { RunnerWithoutDocConstant.new(options_with_doc) }.not_to raise_error
      end
    end
  end

  context 'doc with subcommands' do
    class RunnerWithSubcommands < ::EacRubyUtils::Console::DocoptRunner
      attr_accessor :subarg_value, :suboption_value

      DOC = <<~DOCUMENT
        A root runner with subcommands.

        Usage:
          __PROGRAM__ <parent-arg> __SUBCOMMANDS__
DOCUMENT

      def parent_arg
        options.fetch('<parent-arg>')
      end

      class MySubCommand < ::EacRubyUtils::Console::DocoptRunner
        DOC = <<~DOCUMENT
          A root runner with subcommands.

          Usage:
            __PROGRAM__ [--suboption=<suboption-value] <subarg-value>
DOCUMENT

        def run
          parent.suboption_value = options.fetch('--suboption')
          parent.subarg_value = options.fetch('<subarg-value>')
        end
      end
    end

    let(:argv) { %w[value0 my-sub-command value1 --suboption value2] }
    let(:instance) { RunnerWithSubcommands.new(program: 'runner_with_subcommands', argv: argv) }

    context '#subcommands?' do
      it 'returns true' do
        expect(instance.subcommands?).to eq(true)
      end
    end

    context '#subcommand' do
      it 'is of subcommand class' do
        expect(instance.subcommand).to be_a(RunnerWithSubcommands::MySubCommand)
      end
    end

    context '#context' do
      it 'accesses instance methods by subcommand' do
        expect(instance.subcommand.context(:parent_arg)).to eq('value0')
      end
    end

    context '#run' do
      it 'calls subcommand' do
        instance.run
        expect(instance.subarg_value).to eq('value1')
        expect(instance.suboption_value).to eq('value2')
      end
    end
  end
end
