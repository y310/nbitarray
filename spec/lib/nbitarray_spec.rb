require 'nbitarray'

describe NBitArray do
  describe '#new' do
    it 'should initialized by bit' do
      array = NBitArray.new(8)
      expect { array[1] = 1 }.to change { array.size }.from(1).to(2)
      array = NBitArray.new(33)
      expect { array[1] = 1 }.to change { array.size }.from(1).to(2)
    end
  end

  describe '#size' do
    shared_examples_for 'return correct array size for any bit' do
      let(:bit_array) { NBitArray.new(bit) }

      it 'should return correct size' do
        expect { bit_array[1] = 1 }.to change { bit_array.size }.from(1).to(2)
        expect { bit_array[10] = 1 }.to change { bit_array.size }.from(2).to(11)
        expect { bit_array[100] = 1 }.to change { bit_array.size }.from(11).to(101)
      end
    end

    it 'can be called by #length' do
      expect { NBitArray.new(1).length }.to_not raise_error
    end

    context 'small bit' do
      let(:bit) { 1 }
      it_should_behave_like 'return correct array size for any bit'
    end

    context 'large bit' do
      let(:bit) { 100 }
      it_should_behave_like 'return correct array size for any bit'
    end
  end

  describe '#each' do
    let(:bit_array) { NBitArray.new(3) }
    let(:assign_values) { [0, 1, 2, 3, 4, 5, 6, 7] }

    before do
      assign_values.each_with_index do |v, i|
        bit_array[i] = v
      end
    end

    it 'should iterate all items' do
      bit_array.each do |v|
        v.should eq assign_values.shift
      end
    end

    it 'can use Enumerablue method' do
      bit_array.map{|v| v * 2}.inject(0) {|v, sum| sum += v}.should eq 56
    end
  end

  describe '#[]=, #[]' do
    shared_examples_for 'manage value correctly for any bit' do
      let(:bit_array) { NBitArray.new(bit) }
      let(:max_value) { (1 << bit) - 1 }

      it 'should assign value' do
        expect { bit_array[0] = 0 }.to change { bit_array[0] }.by(0)
        expect { bit_array[1] = max_value }.to change { bit_array[1] }.from(0).to(max_value)
      end

      it 'should raise error' do
        expect { bit_array[0] = 1 << bit }.to raise_error(ArgumentError)
        expect { bit_array[0] = -1 }.to raise_error(ArgumentError)
      end
    end

    context 'under 32bit array' do
      let(:bit) { 1 }
      it_should_behave_like 'manage value correctly for any bit'
    end

    context 'over 32bit array' do
      let(:bit) { 34 }
      it_should_behave_like 'manage value correctly for any bit'
    end

    context 'too large bit array' do
      let(:bit) { 100  }
      it_should_behave_like 'manage value correctly for any bit'
    end
  end

  describe 'marshaling' do
    let(:bit_array) { NBitArray.new(8) }
    it 'can marshal' do
      bit_array[0] = 1
      bit_array[1] = 2
      restored_bit_array = Marshal.load(Marshal.dump(bit_array))
      restored_bit_array.bit.should eql bit_array.bit
      restored_bit_array[0].should eql bit_array[0]
      restored_bit_array[1].should eql bit_array[1]
    end
  end

  describe 'marshaling benchmark' do
    shared_examples_for 'benchmark bit array with array' do
      let(:max_value) { (1 << bit) - 1 }
      let(:bit_array) { NBitArray.new(bit) }
      let(:array) { Array.new }
      let(:bit_array_size) { Marshal.dump(bit_array).size }
      let(:array_size) { Marshal.dump(array).size }

      it 'sparse array' do
        index = 100
        bit_array[index] = 1
        array[index] = 1
        (bit_array_size < array_size).should == sparse_won
      end

      it 'filled array' do
        1000.times do |i|
          value = rand(max_value)
          bit_array[i] = value
          array[i] = value
        end
        (bit_array_size < array_size).should == filled_won
      end
    end

    context '1 bit' do
      let(:bit) { 1 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '4 bit' do
      let(:bit) { 4 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '8 bit' do
      let(:bit) { 8 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '12 bit' do
      let(:bit) { 12 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '16 bit' do
      let(:bit) { 16 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '24 bit' do
      let(:bit) { 24 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '32 bit' do
      let(:bit) { 32 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '64 bit' do
      let(:bit) { 64 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end

    context '128 bit' do
      let(:bit) { 128 }
      let(:sparse_won) { true }
      let(:filled_won) { true }
      it_should_behave_like 'benchmark bit array with array'
    end
  end
end
