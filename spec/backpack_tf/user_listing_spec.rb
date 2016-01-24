require 'spec_helper'

describe BackpackTF::UserListing do
  let(:response_attr) do
    {
      "bump": 1453660379,
      "intent": 1,
      "currencies": {
        "keys": 58
      },
      "buyout": 1,
      "details": false,
      "item": {
        "id": 4224171036,
        "original_id": 4114938468,
        "defindex": 937,
        "level": 85,
        "quality": 5,
        "inventory": 3221225475,
        "quantity": 1,
        "origin": 8,
        "attributes": [
          {
            "defindex": 134,
            "value": 1088421888,
            "float_value": 7
          },
          {
            "defindex": 746,
            "value": 1065353216,
            "float_value": 1
          },
          {
            "defindex": 292,
            "value": 1115684864,
            "float_value": 64
          },
          {
            "defindex": 388,
            "value": 1115684864,
            "float_value": 64
          }
        ]
      },
      "flags": {
        "class": "pyro",
        "slot": "misc",
        "particle": 7,
        "craft_material_type": "hat",
        "priceindex": 7,
        "sku": "440_Unusual_Wraith Wrap_1_1_7"
      },
      "created": 1445205322,
      "id": "5624154aba8d884610a41c51"
    }
  end

  describe '#initialize' do
    it 'an instance has these attributes' do
      listing = described_class.new(response_attr)

      expected_item = {
        id: 4224171036,
        original_id: 4114938468,
        defindex: 937,
        level: 85,
        quality: 5,
        inventory: 3221225475,
        quantity: 1,
        origin: 8,
        attributes: [{
          defindex: 134,
          value: 1088421888,
          float_value: 7
        }, {
          defindex: 746,
          value: 1065353216,
          float_value: 1
        }, {
          defindex: 292,
          value: 1115684864,
          float_value: 64
        }, {
          defindex: 388,
          value: 1115684864,
          float_value: 64
        }]
      }
      expected_flag = {
        class: 'pyro',
        slot: 'misc',
        particle: 7,
        craft_material_type: 'hat',
        priceindex: 7,
        sku: '440_Unusual_Wraith Wrap_1_1_7',
      }

      expect(listing).to have_attributes(
        bump: 1453660379,
        intent: 1,
        currencies: { keys: 58 },
        buyout: 1,
        details: false,
        item: expected_item,
        flags: expected_flag,
        created: 1445205322,
        id: '5624154aba8d884610a41c51'
      )
    end
  end
end
