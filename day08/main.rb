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

        attr_reader :layers

        def decode
            DecodedSpaceImage.new(
                @width,
                @height,
                @layers.reduce(&method(:apply_layer)))
        end

        protected
        
        Black = 0
        White = 1
        Transparent = 2
        
        private
        
        def apply_layer(top, bottom)
            top
                .zip(bottom)
                .map(&method(:resolve_layer_color))
        end

        def resolve_layer_color(pixels)
            top_pixel = pixels[0]
            bottom_pixel = pixels[1]

            top_pixel == Transparent ? bottom_pixel : top_pixel
        end
    end

    class DecodedSpaceImage < SpaceImage
        def initialize(width, height, decoded_data)
            super(width, height, decoded_data)

            if decoded_data.length != (width * height)
                raise "Space image appears to be encoded (length mismatch)"
            end
        end

        def rows
            @layers.each_slice(@width)
        end

        def pretty_print
            rows
                .map(&method(:pretty_print_row))
                .join("\n")
        end

        private

        def pretty_print_row row
            row
                .map {|c| c == Black ? 	"\u2588" : " "}
                .join
        end
    end

    def self.part1(width, height, image_data)
        image = SpaceImage.load(width, height, image_data)
        
        fewest_zeroes_layer = image.layers
            .min_by { |layer| layer.count(0) }
        fewest_zeroes_layer.count(1) * fewest_zeroes_layer.count(2)
    end

    def self.part2(width, height, image_data)
        encoded_image = SpaceImage.load(width, height, image_data)
        decoded_image = encoded_image.decode

        decoded_image.pretty_print
    end
end

image_data = File
    .readlines("input.txt")[0]
    .strip!
    .each_char
    .map(&:to_i)

puts "Part 1: " + Day08.part1(25, 6, image_data).to_s
puts "Part 2:\n" + Day08.part2(25, 6, image_data).to_s
