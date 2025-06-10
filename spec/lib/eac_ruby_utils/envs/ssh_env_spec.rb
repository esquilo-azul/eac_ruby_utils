# frozen_string_literal: true

RSpec.describe EacRubyUtils::Envs::SshEnv do
  describe '#ssh_command_line' do
    {
      'eduardo@localhost' => 'ssh eduardo@localhost',
      'ssh://eduardo@localhost' => 'ssh eduardo@localhost',
      'ssh://eduardo@localhost:2222' => 'ssh -p 2222 eduardo@localhost',
      'localhost' => 'ssh localhost'
    }.each do |input, expected|
      it "convert \"#{input}\" to \"#{expected}\"" do
        env = described_class.new(input)
        expect(env.send('ssh_command_line')).to eq(expected)
      end
    end

    ['my user@hostname', 'http://hostname', 'ssh:/invalid-test', 'Fulano de tal'].each do |input|
      it "\"#{input}\" raise error" do
        expect { described_class.new(input) }.to raise_error(StandardError)
      end
    end
  end
end
