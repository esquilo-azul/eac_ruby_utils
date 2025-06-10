# frozen_string_literal: true

RSpec.describe EacRubyUtils::Inflector do
  describe '#variableize' do
    {
      '_A_variableName' => 'a_variablename',
      'àéíöũ' => 'aeiou'
    }.each do |source, expected|
      context "when source is \"#{source}\"" do
        it { expect(described_class.variableize(source)).to eq(expected) }
      end
    end
  end
end
