require 'spec_helper'

module BackpackTF

  class Dummy
    include BackpackTF::Response
  end

  shared_examples 'Response' do
    let(:dummy) { Dummy.new }

    context 'the class' do
      it 'responds to these inherited class methods' do
        expect(Dummy).to respond_to(:interface, :fetch, :response, :hash_keys_to_sym)
      end

      describe '::hash_keys_to_sym' do
        it 'changes the type of each key from String to Symbol' do
          metal = {'quality'=>6, 'priceindex'=>0, 'single'=>'ref', 'plural'=>'ref', 'round'=>2, 'blanket'=>0, 'craftable'=>'Craftable', 'tradable'=>'Tradable', 'defindex'=>5002}
          hashed_metal = {:quality=>6, :priceindex=>0, :single=>'ref', :plural=>'ref', :round=>2, :blanket=>0, :craftable=>'Craftable', :tradable=>'Tradable', :defindex=>5002}
          expect(Dummy.hash_keys_to_sym(metal)).to eq hashed_metal
        end
      end
    end

  end

  describe Prices do
    it_behaves_like 'Response'
  end

  describe Currencies do
    it_behaves_like 'Response'
  end

end
