require 'spec_helper'

describe BackpackTF::Response do
  let(:response) do
    {
      'success' => 'success',
      'message' => 'message',
      'current_time' => 'current_time'
    }
  end

  context 'reader methods' do
    before(:each) do
      described_class.response = response
    end
    after(:each) do
      described_class.response = nil
    end

    describe '::success' do
      it 'returns success' do
        expect(described_class.success).to eq 'success'
      end
    end

    describe '::message' do
      it 'returns message' do
        expect(described_class.message).to eq 'message'
      end
    end

    describe '::current_time' do
      it 'returns current_time' do
        expect(described_class.current_time).to eq 'current_time'
      end
    end
  end
end
