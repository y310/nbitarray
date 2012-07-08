# NBitArray

This is bitarray implementation which can assign arbitrary bit size per item.

## Installation

Add this line to your application's Gemfile:

    gem 'nbitarray'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nbitarray

## Usage

```ruby
bitarray = NBitArray.new(3) # 3-bit array
bitarray[0] = 7
puts bitarray[0] #=> 7
bitarray[3] = 1
bitarray.size #=> 4

bitarray[1] = 8 #=> raise error
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
