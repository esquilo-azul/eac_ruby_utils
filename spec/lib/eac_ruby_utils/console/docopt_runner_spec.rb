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
          Faz backup de arquivos.

          Usage:
            __PROGRAM__
            __PROGRAM__ -h | --help

          Options:
            -h --help             Show this screen.
            -d --delete           Delete after package.
DOCUMENT
      end

      let(:options_with_doc) { options.merge(doc: doc) }

      it 'reads doc from arguments' do
        expect { RunnerWithoutDocConstant.new(options_with_doc) }.not_to raise_error
      end
    end
  end
end
