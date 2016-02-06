module BackpackTF
  module Price
    # For ItemPrice objects with attached particle effects
    class ParticleEffect
      class << self
        # @return [Hash] possible particle effects for an item
        attr_reader :list
      end

      @key = 'attribute_controlled_attached_particles'
      @file = './lib/backpack_tf/assets/particle_effects.json'

      def self.read_stored_effects_info
        file = File.open(@file).read
        effects = JSON.parse(file)[@key]

        effects.each_with_object({}) do |effect, hash|
          id = effect['id']
          name = effect['name']
          hash[id] = name
        end
      end

      @list = read_stored_effects_info
    end
  end
end
