require 'spec_helper'

describe BackpackTF::Helpers do
  module BackpackTF
    class DummyClass # :nodoc:
      include BackpackTF::Helpers

      class Response < BackpackTF::Response # :nodoc:
        self.response = { foo: 'bar' }
      end
    end
  end

  let(:dummy) { BackpackTF::DummyClass.new }

  # TODO: these tests can be written more succinctly by expecting messages to
  # be called or to have been called on the DummyClass::Response class.
  describe '::response' do
    context 'demonstrating how it normally works' do
      context 'reading' do
        it 'the inner Response class has this value for .response' do
          expected = { foo: 'bar' }
          expect(BackpackTF::DummyClass::Response.response).to eq(expected)
        end
      end

      context 'writing' do
        before(:each) do
          BackpackTF::DummyClass::Response.response = { bar: 'foo' }
        end
        after(:each) do
          BackpackTF::DummyClass::Response.class_eval do
            self.response = { foo: 'bar' }
          end
        end
        it 'can write .response of its own Response class (compare by value)' do
          expected = { bar: 'foo' }
          expect(BackpackTF::DummyClass::Response.response).to eq(expected)
        end
      end
    end

    context 'demonstrating how it works with the shortcut' do
      context 'reading' do
        it 'can read .response of its own Response class' do
          expected = BackpackTF::DummyClass::Response.response
          expect(BackpackTF::DummyClass.response).to eq(expected)
        end
      end

      context 'writing' do
        before(:each) do
          BackpackTF::DummyClass.response = { bar: 'foo' }
        end
        after(:each) do
          BackpackTF::DummyClass.class_eval { self.response = { foo: 'bar' } }
        end

        it 'can write to its own Response class (compare by value)' do
          expected = { bar: 'foo' }
          expect(BackpackTF::DummyClass.response).to eq(expected)
        end
        it 'can write to its own Response class (compare by reference)' do
          expected = BackpackTF::DummyClass::Response.response
          expect(BackpackTF::DummyClass.response).to eq(expected)
        end
      end
    end
  end

  describe '#hash_keys_to_sym' do
    it 'changes each key from a String to a Symbol' do
      metal = {
        'quality' => 6,
        'single' => 'ref'
      }
      hashed_metal = {
        quality: 6,
        single: 'ref'
      }
      actual = dummy.send(:hash_keys_to_sym, metal)
      expect(actual).to eq hashed_metal
    end
  end
end
