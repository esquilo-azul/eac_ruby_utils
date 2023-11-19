# frozen_string_literal: true

require 'eac_ruby_utils/envs/executable'
require 'eac_ruby_utils/envs/local_env'

RSpec.describe ::EacRubyUtils::Envs::Executable do
  let(:env) { ::EacRubyUtils::Envs::LocalEnv.new }

  context 'when program exist' do
    let(:instance) { described_class.new(env, 'cat', '--version') }

    it { expect(instance.exist?).to be(true) }
    it { expect { instance.validate! }.not_to raise_error }
    it { expect(instance.validate).to be_blank }
    it { expect(instance.command).to be_a(::EacRubyUtils::Envs::Command) }
  end

  context 'when program does not exist' do
    let(:instance) { described_class.new(env, 'this_cannot_exist', '--version') }

    it { expect(instance.exist?).to be(false) }

    it {
      expect { instance.validate! }.to raise_error(
        described_class.const_get('ProgramNotFoundError')
      )
    }

    it { expect(instance.validate).to be_present }

    it {
      expect { instance.command }.to raise_error(
        described_class.const_get('ProgramNotFoundError')
      )
    }
  end
end
