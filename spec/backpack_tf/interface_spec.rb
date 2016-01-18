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
end
