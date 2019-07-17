# Xxd

I put this Gem together one night to help make it easier to deal with binary blobs in Ruby specs/assertions.

I found some libraries that can dump hex into a nice table with offsets and the printable ASCII bytes, and some
which could parse the same, but nothing that could do both without pulling in a load of dependencies.

This takes the dumbest possible approach to natively, and naïvely implement the default functionality of `xxd` from GNU.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xxd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xxd

## Usage

There are two methods `Xxd.dump` and `Xxd.parse`. There are no configuration options. Given a string the gem will
print it as a hex table in this style:

    00000000: 2159 a651 f852 132c 5f83 1259 9acd d837  !Y.Q.R.,_..Y...7
    00000010: 0340 44d2 e08f 6979 46ee 40dc d6a0 bfa3  .@D...iyF.@.....
    00000020: 0c63 a246 1eae 5ddd 9a59 9fa2 f14d d57c  .c.F..]..Y...M.|
    00000030: f13f 8aa5 b7dd 7384 c620 133f f43c 190f  .?....s.. .?.<..
    00000040: a89a 3f85 f958 be10 f8dd d7b5 a5d6 907f  ..?..X..........
    00000050: 78ee 3b93 8fb5 5c51 51ed eb71 e23c 7c75  x.;...\QQ..q.<|u
    00000060: bde0 2e05                                ....

If the input is too large, all bets are off. The logic for the left column is weak.

Usage from Ruby looks like this:

    $ irb -Ilib -rxxd
    irb(main):004:0> message = "this is a message consisting only of printable ascii characters"
    => "this is a message consisting only of printable ascii characters"
    irb(main):005:0> puts Xxd.dump(message)
    00000000: 7468 6973 2069 7320 6120 6d65 7373 6167  this is a messag
    00000010: 6520 636f 6e73 6973 7469 6e67 206f 6e6c  e consisting onl
    00000020: 7920 6f66 2070 7269 6e74 6162 6c65 2061  y of printable a
    00000030: 7363 6969 2063 6861 7261 6374 6572 73    scii characters
    => nil

Printing pure ASCII isn't very interesting, so binary output is handled thusly:

    irb(main):006:0> message = File.open("/dev/urandom").read(200)
    => "\xD6-\xBD\xC9x\xFA4\x8Dxz\x1C\xC2,:\xDF\x1FFY&\xE4UV\x9A}\x9Dv\xB9\xE3\xF2\xAAz\xF5\x9Cg\x86\x1DX\x85\xD7caQ\xE0\xBC\xBA\x04\x154|\xE3\xBBXX\xFFi\x9Ah\x16Bl\xE6\x9D\xFA\f\b\x88skaH\xD1\xAC~a\x9D\x1E\xA9\x7F\xAA\x7F\x0Er\x8C\x05_\xEF\x9C\xAD<\x1CF\xC4\xF1\xE0\xDE\xE2\xB1\xC4H\x10M\"Mu\xCD\xCD\x18W\x03\xD0<j\xE3\x0Et5e\xD8d\xC7\xE7\xD6\xFCO\xA7\xDF\x18\xE8\xC5t:iKG`\xDAG\x157\xA1~\xA6\x95{\x97\x93t\xFC\x8Bz'Z\xC7\xDEH\x04\x1D\xD7\xB32>\xB0\xA3\xBB\xFB\xD2\x9E\xEA5\xAA\xDA\x8C\xEF\xF6B|\xF7JU5\xDE4\xB6$\xBB\x88\xBD|\x92\x8E?\x04\xAC\x8A\xE3\x1F \xF6\x99\r"
    irb(main):007:0> puts Xxd.dump(message)
    00000000: d62d bdc9 78fa 348d 787a 1cc2 2c3a df1f  .-..x.4.xz..,:..
    00000010: 4659 26e4 5556 9a7d 9d76 b9e3 f2aa 7af5  FY&.UV.}.v....z.
    00000020: 9c67 861d 5885 d763 6151 e0bc ba04 1534  .g..X..caQ.....4
    00000030: 7ce3 bb58 58ff 699a 6816 426c e69d fa0c  |..XX.i.h.Bl....
    00000040: 0888 736b 6148 d1ac 7e61 9d1e a97f aa7f  ..skaH..~a......
    00000050: 0e72 8c05 5fef 9cad 3c1c 46c4 f1e0 dee2  .r.._...<.F.....
    00000060: b1c4 4810 4d22 4d75 cdcd 1857 03d0 3c6a  ..H.M"Mu...W..<j
    00000070: e30e 7435 65d8 64c7 e7d6 fc4f a7df 18e8  ..t5e.d....O....
    00000080: c574 3a69 4b47 60da 4715 37a1 7ea6 957b  .t:iKG`.G.7.~..{
    00000090: 9793 74fc 8b7a 275a c7de 4804 1dd7 b332  ..t..z'Z..H....2
    000000a0: 3eb0 a3bb fbd2 9eea 35aa da8c eff6 427c  >.......5.....B|
    000000b0: f74a 5535 de34 b624 bb88 bd7c 928e 3f04  .JU5.4.$...|..?.
    000000c0: ac8a e31f 20f6 990d                      .... ...
    => nil

The original message can be recovered thusly:

    irb(main):012:0> Xxd.parse(Xxd.dump(message))
    => "\xD6-\xBD\xC9x\xFA4\x8Dxz\x1C\xC2,:\xDF\x1FFY&\xE4UV\x9A}\x9Dv\xB9\xE3\xF2\xAAz\xF5\x9Cg\x86\x1DX\x85\xD7caQ\xE0\xBC\xBA\x04\x154|\xE3\xBBXX\xFFi\x9Ah\x16Bl\xE6\x9D\xFA\f\b\x88skaH\xD1\xAC~a\x9D\x1E\xA9\x7F\xAA\x7F\x0Er\x8C\x05_\xEF\x9C\xAD<\x1CF\xC4\xF1\xE0\xDE\xE2\xB1\xC4H\x10M\"Mu\xCD\xCD\x18W\x03\xD0<j\xE3\x0Et5e\xD8d\xC7\xE7\xD6\xFCO\xA7\xDF\x18\xE8\xC5t:iKG`\xDAG\x157\xA1~\xA6\x95{\x97\x93t\xFC\x8Bz'Z\xC7\xDEH\x04\x1D\xD7\xB32>\xB0\xA3\xBB\xFB\xD2\x9E\xEA5\xAA\xDA\x8C\xEF\xF6B|\xF7JU5\xDE4\xB6$\xBB\x88\xBD|\x92\x8E?\x04\xAC\x8A\xE3\x1F \xF6\x99\r"


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xxd.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
