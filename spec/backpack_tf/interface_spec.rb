require 'spec_helper'

describe BackpackTF::Interface do
  describe '::defaults' do
    after(:each) do
      described_class.class_eval do
        @format = 'json'
        @callback = nil
        @appid = '440'
      end
    end

    it 'has these attributes & values by default' do
      expect(described_class).to have_attributes(
        format: 'json',
        callback: nil,
        appid: '440'
      )
    end
    it 'can modify its values' do
      options = {
        format: 'foo',
        callback: 'bar',
        appid: '2'
      }
      described_class.defaults(options)
      expect(described_class).to have_attributes(
        format: 'foo',
        callback: 'bar',
        appid: '2'
      )
    end
  end

  describe '::url_name_and_version' do
    before(:each) do
      allow(described_class).to receive(:name).and_return('interface_name')
      allow(described_class).to receive(:version).and_return(1)
    end
    after(:each) do
      allow(described_class).to receive(:name).and_return(nil)
      allow(described_class).to receive(:version).and_return(nil)
    end

    it 'calls .name and .version' do
      expect(described_class).to receive(:name)
      expect(described_class).to receive(:version)
      described_class.url_name_and_version
    end
    it 'returns part of a url' do
      actual = described_class.url_name_and_version
      expected = '/interface_name/v1/?'
      expect(actual).to eq expected
    end
  end
end
