# frozen_string_literal: true

RSpec.describe EacRubyUtils::Fs::Temp::Directory do
  describe '#remove!' do
    let(:instance) { described_class.new }

    it { expect(instance).to be_directory }
    it { expect { instance.remove! }.not_to raise_error }
  end

  describe 'derived pathnames' do
    let(:instance) { described_class.new }

    before { instance.join('child').write('') }

    after { instance.remove }

    {
      basename: [], children: [], cleanpath: [], dirname: [], each_child: [], entries: [],
      expand_path: [], realdirpath: [], realpath: [], sub: %w[x y], sub_ext: ['.ext']
    }.each do |method_name, args|
      it "##{method_name} returns only plain Pathname instances" do
        expect(Array(instance.send(method_name, *args)).map(&:class).uniq).to eq([Pathname])
      end
    end
  end
end
