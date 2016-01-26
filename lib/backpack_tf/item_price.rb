module BackpackTF
  # A price of an individual item.
  # This lives inside the `@prices` hash of a BackpackTF::Item object.
  class ItemPrice
    KEYNAME_DELIMITER = '_'.freeze

    # mapping official API quality integers to quality names
    # https://wiki.teamfortress.com/wiki/WebAPI/GetSchema#Result_Data
    @qualities = [
      :Normal,
      :Genuine,
      nil,
      :Vintage,
      nil,
      :Unusual,
      :Unique,
      :Community,
      :Valve,
      :"Self-Made",
      nil,
      :Strange,
      nil,
      :Haunted,
      :"Collector's"
    ]

    @particle_effects_key = 'attribute_controlled_attached_particles'
    @tradabilities = [:Tradable, :'Non-Tradable']
    @craftabilities = [:Craftable, :'Non-Craftable']
    @required_keys = %w(currency value last_update difference)

    def self.particle_effects_file
      "./lib/backpack_tf/assets/#{@particle_effects_key}.json"
    end

    def self.qualities
      @qualities
    end

    def self.tradabilities
      @tradabilities
    end

    def self.craftabilities
      @craftabilities
    end

    def self.required_keys
      @required_keys
    end

    def self.quality_name_to_index(q)
      @qualities.index(q.to_sym) unless q.nil?
    end

    def self.hash_particle_effects
      file = File.open(particle_effects_file).read
      effects = JSON.parse(file)[@particle_effects_key]

      effects.each_with_object({}) do |effect, hash|
        id = effect['id']
        name = effect['name']
        hash[id] = name
        hash
      end
    end

    @particle_effects = hash_particle_effects

    def self.particle_effects
      @particle_effects
    end

    def self.ins_sp(str)
      str = str.split('')
      new_str = ''

      str.each_with_index do |c, i|
        return new_str += c if i == 0

        unless c == c.upcase && str[i - 1] == str[i - 1].upcase
          new_str += c
        else
          new_str += (' ' + c)
        end
      end

      new_str
    end

    # @return [String] the quality of the item being priced, converted to String
    attr_reader :quality
    # @return [Symbol] either :Tradable or :'Non-Tradable'
    attr_reader :tradability
    # @return [Symbol] either :Craftable or :'Non-Craftable'
    attr_reader :craftability
    # @return [NilClass or Fixnum] May signify crate series or unusual effect
    attr_reader :priceindex
    # @return [Symbol] The currency that the item's price is based on
    attr_reader :currency
    # @return [Float] The value of the item in said currency
    attr_reader :value
    # @return [Float] The item's upper value in said currency.
    # Only set if the item has a price range
    attr_reader :value_high
    # @return [Float] The item's value in the lowest currency without rounding.
    # If raw is set to 2, this is the lower value if a high value exists.
    # Otherwise, this is the average between the high and low value.
    # Requires raw to be enabled.
    attr_reader :value_raw
    # @return [Float] The item's value in the lowest currency without rounding.
    # Requires for 'raw' to be enabled & set to 2.
    attr_reader :value_high_raw
    # @return [Fixnum] A timestamp of when the price was last updated
    attr_reader :last_update
    # @return [Fixnum] A relative difference between the former price & the
    # current price. If 0, assume new price.
    attr_reader :difference
    # @return [String] Result of @particle_effects[@priceindex]
    attr_reader :effect

    def initialize(key, attr, priceindex = nil)
      attr = JSON.parse(attr) unless attr.class == Hash

      key = key.split(KEYNAME_DELIMITER)
      key = process_key(key)

      validate_attributes(attr)

      @quality        = key[0]
      @tradability    = key[1]
      @craftability   = key[2]
      @currency       = attr['currency'].to_sym
      @value          = attr['value']
      @value_high     = attr['value_high']
      @value_raw      = attr['value_raw']
      @value_high_raw = attr['value_high_raw']
      @last_update    = attr['last_update']
      @difference     = attr['difference']
      @priceindex     = priceindex
      @effect         = self.class.particle_effects[priceindex.to_i]
    end

    private

    # requires the key to an Array with length of 3 or more
    # converts each element to a Symbol object
    # 3 bits of info are subject to a NameError if any one of them is invalid
    # @return [Array] an Array of Symbol objects
    # @raises NameError, ArgumentError
    def process_key(key)
      unless key.length >= 3
        fail ArgumentError, 'This key must have a length of 3 or greater'
      end

      key.map!(&:to_sym)

      unless self.class.qualities.include? key[0]
        fail NameError, 'Must include a valid Quality'
      end
      unless self.class.tradabilities.include? key[1]
        fail NameError, 'Must include a valid Tradability'
      end
      unless self.class.craftabilities.include? key[2]
        fail NameError, 'Must include a valid Craftability'
      end

      key
    end

    def validate_attributes(attributes)
      fail TypeError unless attributes.class == Hash

      all_keys_present = self.class.required_keys.all? do |k|
        attributes.keys.member?(k)
      end

      unless all_keys_present
        msg = 'The passed-in hash is required to have at least these 4 keys: '
        msg += self.class.required_keys.join(', ')
        fail KeyError, msg
      end

      attributes
    end
  end
end
