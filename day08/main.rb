module Day08
    class SpaceImage
        def self.load(width, height, data)
            layer_size = width * height
            SpaceImage.new(
                width,
                height,
                data.each_slice(layer_size).to_a)
        end

        def initialize(width, height, layers_data)
            @width = width
            @height = height
            @layers = layers_data
        end

        attr_reader :width
        attr_reader :height
        attr_reader :layers
    end

    def self.part1(width, height, image_data)
        image = SpaceImage.load(width, height, image_data)
        
        fewest_zeroes_layer = image.layers
            .min_by { |layer| layer.count(0) }
        fewest_zeroes_layer.count(1) * fewest_zeroes_layer.count(2)
    end

    def self.part2(image_data)
    end
end

image_data = File
    .readlines("input.txt")[0]
    .strip!
    .each_char
    .map(&:to_i)
    
puts "Part 1: " + Day08.part1(25, 6, image_data).to_s
puts "Part 2: " + Day08.part2(image_data).to_s
