module BackpackTF
  module Price
    # For ItemPrice objects with attached particle effects
    class ParticleEffect
      RELATIVE_PATH_TO_ASSETS_FILE = '../assets/particle_effects.json'
      KEY_TO_PARSE_IN_ASSETS_FILE  = 'attribute_controlled_attached_particles'

      class << self
        # @return [Hash] possible particle effects for an item
        def list
          @list ||= accumulate_assets
        end

        private

        def accumulate_assets
          effects = parse_assets_file

          effects.each_with_object({}) do |effect, hash|
            accumulate!(effect, hash)
          end
        end

        def parse_assets_file
          file = File.open(absolute_path_to_assets_file).read
          JSON.parse(file)[KEY_TO_PARSE_IN_ASSETS_FILE]
        end

        def absolute_path_to_assets_file
          current_dirname = File.dirname(__FILE__)
          File.expand_path(RELATIVE_PATH_TO_ASSETS_FILE, current_dirname)
        end

        def accumulate!(effect, hash)
          id = effect['id']
          name = effect['name']
          hash[id] = name
        end
      end
    end
  end
end
