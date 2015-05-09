require 'spec_helper'

module BackpackTF
  describe Price do

    let(:bp) { Client.new }

    let(:json_obj) {
      fixture = file_fixture('prices.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    it 'responds to these inherited class methods' do
      expect(described_class).to respond_to :responses, :to_sym, :interface, :hash_keys_to_sym    
    end

    it 'has these default attributes' do
      expect(described_class.interface).to eq :IGetPrices
    end

    it 'raises an error when trying to instantiate this class' do
      expect{described_class.new}.to raise_error RuntimeError
    end

    describe '::responses' do
      it "Responses class can access Price response by calling Price key" do
        stub_http_response_with('prices.json')
        fetched_prices = bp.fetch(:prices)
        Response.responses(described_class.to_sym => fetched_prices)
        expect(Response.responses[described_class.to_sym]).to eq json_obj
      end
    end

    describe '::response' do
      before :each do
        stub_http_response_with('prices.json')
        fetched_prices = bp.fetch(:prices)
        Response.responses(described_class.to_sym => fetched_prices)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
      end

      it 'can access response information' do
        expect(described_class.response).to eq json_obj
      end
      it "returns same info as the Response class calling Price key" do
        expect(described_class.response).to eq Response.responses[described_class.to_sym]
      end
      it 'the response attribute should have these keys' do
        expect(described_class.response.keys).to match_array [:success, :current_time, :raw_usd_value, :usd_currency, :usd_currency_index, :items]
      end
      it 'the keys of the response attribute should have these values' do
        response = described_class.response
        expect(response[:success]).to eq 1
        expect(response[:message]).to eq nil
        expect(response[:current_time]).to eq 1430785805
        expect(response[:raw_usd_value]).to eq 0.115
        expect(response[:usd_currency]).to eq 'metal'
        expect(response[:usd_currency_index]).to eq 5002
      end
    end

    describe '::generate_items' do
      before :each do
        stub_http_response_with('prices.json')
        fetched_prices = bp.fetch(:prices)
        bp.update(described_class, fetched_prices)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
      end

      it 'each key of hash is a String' do
        expect(described_class.generate_items.keys).to all be_a String
      end
      it 'each value of hash is an Item object' do
        expect(described_class.generate_items.values).to all be_an Item
      end
      it 'if an item does not have a valid `defindex`, then it is ignored' do
        expect(described_class.generate_items['Random Craft Hat']).to be_nil
        expect(described_class.generate_items[':weed:']).to be_nil
      end
    end

    describe '::items' do
      before :each do
        stub_http_response_with('prices.json')
        fetched_prices = bp.fetch(:prices)
        bp.update(described_class, fetched_prices)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
      end

      it 'returns the fixture and sets to @@items variable' do
        expect(described_class.items).not_to be_nil
      end

      context '@@items attribute' do
        it 'should be a Hash object' do
          expect(described_class.items).to be_instance_of Hash
        end
        xit 'should have this many keys' do
          expect(described_class.items.keys.length).to be 1661
        end
        it 'each key should be a String' do
          expect(described_class.items.keys).to all be_a String
        end
        it 'each value should be an Item' do
          expect(described_class.items.values).to all be_an Item
        end
      end

      context 'using keys to generate Item objects' do
        let(:random_key) { described_class.items.keys.sample }
        let(:item) { described_class.items[random_key] }

        it 'generates an Item object' do
          expect(item).to be_instance_of Item
        end
        it 'the Item object responds to these methods' do
          expect(item).to respond_to :item_name, :defindex, :prices
        end
        it 'uses the key to assign a value to the @item_name property of the Item' do
          expect(random_key).to eq item.item_name
        end
        it 'passes itself to be stored in the @prices attribute of the Item object' do
          expect(described_class.items[random_key].prices).to eq item.prices
        end
      end
    end

    describe '::find_item_by_name' do
      let(:item) { described_class.items['Kritzkrieg'] }

      before :each do
        stub_http_response_with('prices.json')
        fetched_prices = bp.fetch(:prices)
        bp.update(described_class, fetched_prices)
      end

      after :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @items = nil }
      end

      it 'returns Item object for the item matching the name' do
        expect(described_class.find_item_by_name('Kritzkrieg')).to eq item
      end
      it 'can return picked attributes' do
        expect(described_class.find_item_by_name('Kritzkrieg', :defindex)).to eq 35
      end
      it 'raises a KeyError if you ask for attribute it does not have' do
        expect{described_class.find_item_by_name('Kritzkrieg', :foo)}.to raise_error KeyError
      end
    end

    describe '::random_item' do
      before :each do
        stub_http_response_with('prices.json')
        fetched_prices = bp.fetch(:prices)
        bp.update(described_class, fetched_prices)
      end

      after :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @items = nil }
      end

      it 'returns a name of an Item object' do
        item = described_class.random_item
        expect(described_class.items.keys.include? item).to be_truthy
      end

      context 'asking for prices property' do
        let(:item_prices) { described_class.random_item :price }

        it 'returns a Hash object where keys are String objects' do
          expect(item_prices.keys).to all be_a String
        end
        it 'returns a Hash object where values are ItemPrice objects' do
          expect(item_prices.values).to all be_an ItemPrice
        end
      end
    end

  end
end
