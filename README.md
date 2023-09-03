![logo](logo/wa-cr.png)

# Where's all the Crystal? | wa-cr

Used to parse .wad files into usable Crystal code
as well as writing out a .wad or .lmp files

## Installation

1. Download the [code](https://github.com/sol-vin/wad-reader/archive/refs/heads/master.zip)
2. Unzip the file wherever you want

### Raylib

To use the wa-cr Raylib additions such as converting a graphic to a Raylib Image, you must have raylib downloaded:

- Install raylib from [github](https://github.com/raysan5/raylib/releases)

## Usage

* Use WAD.read(*wad location*)
* Run 'shards run' from the install directory to run the program

## Contributing

1. Fork it (<https://github.com/sol-vin/wad-reader/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Devin Shwagginz](https://github.com/D-Shwagginz) - creator and maintainer
- [Ian Rash](https://github.com/sol-vin) - co-creator

## Limitations

* Demos won't work properly because of how the doom engines psuedo-random number generator functions. If the wads are different at all, the demos won't function as intended
