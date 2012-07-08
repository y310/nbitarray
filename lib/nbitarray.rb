require 'nbitarray/version'

class NBitArray
  MARSHAL_SPLIT_SIZE = 512
  attr_reader :bit
  include Enumerable

  def initialize(bit)
    @bit = bit
    @bit_array = 0
    @mask = (1 << @bit) - 1
  end

  def size
    if @bit_array == 0
      1
    else
      num_of_bits = Math.log2(@bit_array)
      if num_of_bits == Float::INFINITY
        # FIXME: this algorithm is too slow
        count = 1
        value = @bit_array
        while (value = value >> 1) != 0
          count += 1
        end
        num_of_bits = count
      else
        num_of_bits = num_of_bits.floor + 1
      end
      (num_of_bits - 1) / @bit + 1
    end
  end
  alias length size

  def each(&block)
    size.times {|index| yield self[index] }
  end

  def []=(index, value)
    raise ArgumentError, 'too large value' if value >= 1 << @bit
    raise ArgumentError, 'value must be positive' if value < 0
    bit_index = index * @bit

    # 00 00 00 10 << 4 shift
    # 00 10 00 00
    assign_value = value << bit_index

    # 00 00 00 11 mask
    # 00 11 00 00 move to masking position
    # 11 00 11 11 reverse mask
    reverse_mask = ~(@mask << bit_index)

    # 10 01 11 00 & 11 00 11 11 erase current value by reverse mask
    # 10 00 11 00 | 00 10 00 00 assign new value
    # 10 10 11 00
    @bit_array = (@bit_array & reverse_mask) | assign_value
    value
  end

  def [](index)
    bit_index = index * @bit

    # 10 10 11 00 >> 4          shift
    # 00 00 10 10 | 00 00 00 11 mask
    # 00 00 00 10               value
    (@bit_array >> bit_index) & @mask
  end

  def marshal_dump
    [@bit, @mask, splitted_bit_array(@bit_array, MARSHAL_SPLIT_SIZE), MARSHAL_SPLIT_SIZE]
  end

  def marshal_load(array)
    @bit, @mask, splitted_array, split_size = array
    @bit_array = joined_bit_array(splitted_array, split_size)
  end

  def splitted_bit_array(bit_array, split_size = 32)
    mask = (1 << split_size) - 1
    array = []
    while bit_array > 0
      array << (bit_array & mask)
      bit_array = bit_array >> split_size
    end
    array
  end
  private :splitted_bit_array

  def joined_bit_array(splitted_array, split_size)
    value = 0
    splitted_array.each_with_index do |splitted_value, index|
      value += splitted_value << (split_size * index)
    end
    value
  end
  private :joined_bit_array
end
