![logo](logo/wa-cr.png)

# Where's all the Crystal? | wa-cr

A Crystal library used to parse .wad or .lmp files into usable Crystal code
as well as writing out to a .wad or .lmp file or converting files.

## Installation

1. Add `wa-cr` to your `shard.yml`:
```yml
dependencies:
  wa-cr:
    github: sol-vin/wa-cr
```

2. Run `shards install`

### Raylib Additions

To use the wa-cr [Raylib](https://github.com/raysan5/raylib/releases)
additions you must have [raylib](https://github.com/raysan5/raylib/releases) installed:

- Install raylib from [github](https://github.com/raysan5/raylib/releases).

## Usage

wa-cr includes many methods that make jumping into and out of a .wad or .lmp file very easy.<br>
Following is a brief overview of what wa-cr can do.<br>
For a complete overview visit wa-cr's [docs](https://sol-vin.github.io/wad-reader/index.html)
and the [complete overview](https://sol-vin.github.io/wad-reader/A_Overview.html).
### Wad Data

Reading in a .wad is easy by using `WAD.read(file : Path | String | IO)`
```crystal
# Reads in a wad and sets it to *my_wad*
my_wad = WAD.read("Path/To/Wad.wad")
```
You can read in specific .lmp files too. <sup> *.lmp* : an exported doom lump.</sup>
```crystal
# Reads in a sound lump file and sets it to *my_sound*
my_sound = WAD::Sound.parse("Path/To/Sound.lmp")
```
You can also add the data into the wad file with `WAD#parse(name, type, file)`
```crystal
my_wad.parse("MySound", "Sound", "Path/To/Sound.lmp")
```
And you can create entirely new wad files too with `WAD.new(type)`
```crystal
my_new_wad = WAD.new(WAD::Type::Internal)

# And you can read data into that new wad too
my_new_wad.parse("MySound", "Sound", "Path/To/Sound.lmp")
``` 
### Writing

You can write out .wad and .lmp files from the parsed data as well by using `WAD#write(file : String | Path | IO)`
and `ThingToWrite#write(file : String | Path | IO)`.
```crystal
# Include the wa-cr write library
require "wa-cr/write"

# Write *my_wad* to *"MyWad.wad"*
my_wad.write("Path/To/MyWad.wad")


# Writes the lump *my_graphic* to a .lmp file
my_graphic.write("Path/To/MyLump.lmp")
```
### Sound Converting

Converting doom-formatted sound data to a .wav file is just as simple by using `Sound#to_wav(file : String | Path | IO)`.
```crystal
# Writes *my_sound* to a .wav file
my_sound.to_wav("Path/To/WriteSound.wav")
```
### Raylib Additions

wa-cr takes advantage of [Raylib](https://github.com/raysan5/raylib/releases)
and [raylib-cr](https://github.com/sol-vin/raylib-cr) with ways to convert doom<br>
graphics to
[Raylib Images](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
or [Raylib Colors](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
and draw said images or pixels to the screen<br>
by using `WAD#get_texture(name : String, palette : Playpal::Palette)`<br>
or `Graphic|Flat#to_tex(palette : Playpal::Palette)`
```crystal
# Include the wa-cr raylib library
require "wa-cr/raylib"

palette = my_wad.playpal.palettes[0]
my_graphic_image = my_graphic.to_tex(palette)
my_flat_image = my_flat.to_tex(palette)
# You can also get textures from the texture maps
my_texture_image = my_wad.get_texture("texture_name_in_texturex", palette)
```

## Limitations

* Demos won't work properly because of how the doom engines psuedo-random number generator functions. If the wads are different at all, the demos won't function as intended

## Contributing

1. Fork it (<https://github.com/sol-vin/wad-reader/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Devin Shwagginz](https://github.com/D-Shwagginz) - creator and maintainer
- [Ian Rash](https://github.com/sol-vin) - co-creator
