# frozen_string_literal: true

require 'eac_ruby_utils/fs/temp'

RSpec.describe EacRubyUtils::Fs::Temp do
  describe '#on_file' do
    it do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      temp_path = nil
      described_class.on_file do |path|
        temp_path = path
        expect(temp_path).not_to exist
        temp_path.write('StubText')
        expect(temp_path).to exist
      end
      expect(temp_path).not_to exist
    end

    it 'not fail if already removed' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      temp_path = nil
      described_class.on_file do |path|
        temp_path = path
        expect(temp_path).not_to exist
        temp_path.write('StubText')
        expect(temp_path).to exist
        temp_path.unlink
      end
      expect(temp_path).not_to exist
    end
  end

  describe '#on_directory' do
    it do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      temp_path = nil
      described_class.on_directory do |path|
        temp_path = path
        expect(temp_path).to be_directory
      end
      expect(temp_path).not_to exist
    end

    it 'not fail if already removed' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      temp_path = nil
      described_class.on_directory do |path|
        temp_path = path
        expect(temp_path).to be_directory
        temp_path.rmtree
        expect(temp_path).not_to exist
      end
      expect(temp_path).not_to exist
    end
  end
end
