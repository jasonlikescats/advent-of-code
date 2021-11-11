module ShipComputer
    class VirtualMemory
        def initialize
            @blocks = Hash.new { |hash, key| hash[key] = Array.new(BlockSize, 0) }
        end

        def memcpy(start_address, data)
            data.each_with_index { |datum, index| self[start_address + index] = datum }
        end

        def [](address)
            get_block(address)[get_address_in_block(address)]
        end

        def []=(address, value)
            get_block(address)[get_address_in_block(address)] = value
        end

        private

        BlockSize = 128

        def get_block(address)
            block_address = address / BlockSize
            @blocks[block_address]
        end

        def get_address_in_block(address)
            address % BlockSize
        end
    end
end