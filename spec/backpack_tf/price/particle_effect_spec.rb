require 'spec_helper'

describe BackpackTF::Price::ParticleEffect do
  let(:parsed_assets) do
    [
      {
        "system" => "foo",
        "id" => 1,
        "attach_to_rootbone" => true,
        "name" => "Foo"
      },
      {
        "system" => "bar",
        "id" => 2,
        "attach_to_rootbone" => false,
        "name" => "Bar"
      }
    ]
  end

  describe '.list' do
    context 'when @list is NOT nil' do
      before(:each) do
        described_class.class_eval { @list = :foo }
      end
      after(:each) do
        described_class.class_eval { @list = nil }
      end

      it 'returns the value of @list' do
        actual = described_class.list
        expect(actual).to eq(:foo)
      end
      it 'does not call .accumulate_assets' do
        expect(described_class).not_to receive(:accumulate_assets)
        described_class.list
      end
    end

    context 'when @list is nil' do
      before(:each) do
        allow(described_class).to receive(:accumulate_assets).and_return(:foo)
        described_class.class_eval { @list = nil }
      end
      after(:each) do
        described_class.list
      end

      it 'calls .accumulate_assets' do
        expect(described_class).to receive(:accumulate_assets)
      end
    end
  end

  describe '.accumulate_assets' do
    before(:each) do
      allow(described_class)
        .to receive(:parse_assets_file)
        .and_return(parsed_assets)
    end

    context 'reading a value at a known key' do
      it 'can read the value at this key' do
        actual = described_class.send(:accumulate_assets)[1]
        expect(actual).to eq 'Foo'
      end
      it 'can read the value at this key' do
        actual = described_class.send(:accumulate_assets)[2]
        expect(actual).to eq 'Bar'
      end
    end
    context 'when it cannot find the requested key' do
      it 'returns nil' do
        actual = described_class.send(:accumulate_assets)[3]
        expect(actual).to be_nil
      end
    end
  end

  describe '.parse_assets_file' do
    let(:path_to_dummy_file) do
      rel_path_to_dummy_file = '../../fixtures/particle_effects.json'
      current_dirname = File.dirname(__FILE__)
      File.expand_path(rel_path_to_dummy_file, current_dirname)
    end

    before(:each) do
      allow(described_class)
        .to receive(:absolute_path_to_assets_file)
        .and_return(path_to_dummy_file)
    end

    it 'returns these results' do
      expected = parsed_assets
      actual = described_class.send(:parse_assets_file)
      expect(actual).to eq expected
    end
  end

  describe '.absolute_path_to_assets_file' do
    it 'returns the absolute path to the assets file' do
      actual = described_class.send(:absolute_path_to_assets_file)
      expected = 'lib/backpack_tf/assets/particle_effects.json'
      expect(actual).to match(/.*\/#{expected}/)
    end
  end

  describe '.accumulate!' do
    let(:effect) { { 'id' => 2, 'name' => 'Rad Effect' } }
    let(:hash)   { { 1 => 'Cool Effect' } }

    it 'mutates the hash, like so:' do
      described_class.send(:accumulate!, effect, hash)
      expected = { 1 => 'Cool Effect', 2 => 'Rad Effect' }
      expect(hash).to eq expected
    end
  end
end
