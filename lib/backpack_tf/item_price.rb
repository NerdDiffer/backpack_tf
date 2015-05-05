module BackpackTF

  class ItemPrice

    include BackpackTF::Finder

    attr_reader :quality, :tradability, :craftability, :priceindex,
      :currency, :value, :value_high, :value_raw, :value_high_raw,
      :last_update, :difference

    def initialize
    end

    # mapping official API quality integers to quality names
    # https://wiki.teamfortress.com/wiki/WebAPI/GetSchema#Result_Data
    @@qualities = [
      'Normal',
      'Genuine',
      nil,
      'Vintage',
      nil,
      'Unusual',
      'Unique',
      'Community',
      'Valve',
      'Self-Made',
      nil,
      'Strange',
      nil,
      'Haunted',
      "Collector's"
    ]

    def self.qualities; @@qualities; end

    @@tradabilities = [:Tradable, :Untradable]
    @@craftabilities = [:Craftable, :Uncraftable]
    
  end

end
