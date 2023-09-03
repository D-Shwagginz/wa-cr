![logo](logo/wa-cr.png)
# Where's all the Crystal? | wa-cr

Used to parse .wad files into usable Crystal code
as well as writing out to a .wad or .lmp file or converting files.

## Installation

1. Add `wa-cr` to your `shard.yml`:
```yml
dependencies:
  raylib-cr:
    github: sol-vin/wa-cr
```

2. Run `shards install`

### Raylib Additions

To use the wa-cr Raylib additions you must perform some extra steps

1. Install raylib from [github](https://github.com/raysan5/raylib/releases).

2. Add `raylib-cr` to your `shard.yml`:
```yml
dependencies:
  raylib-cr:
    github: sol-vin/raylib-cr
```

## Usage

wa-cr includes many methods that make jumping into and out of a .wad file very easy.<br>
Following is a brief overview of what wa-cr can do.<br>
For a complete overview visit wa-cr's [docs](https://sol-vin.github.io/wad-reader/index.html).
### Wad Data

Reading in a .wad is as easy as
```crystal
# Reads in a wad and sets it to *my_wad*
my_wad = WAD.read("Path/To/Wad.wad")
```
You can read in specific .lmp files too. <sup> *.lmp* : an exported doom lump.</sup>
```crystal
# Reads in a sound lump file and sets it to *my_sound*
File.open("Path/To/Sound.lmp") do |file|
  my_sound = WAD::Sound.parse(file)
end
```
You can also add the data into the wad file.
```crystal
my_wad.sounds["MYSOUND"] = my_sound
# You have to create a new directory with the same name as the data you inserted. 
mywad.new_dir("MYSOUND")
```
### Lump Writing

You can write out .lmp files from the parsed data as well.
```crystal
# Writes the lump *my_graphic* to a .lmp file
File.open("Path/To/MyLump.lmp", "w+") do |file|
  my_graphic.write(file)
end
```
### Sound Converting

Converting doom-formatted sound data to a .wav file is just as simple.
```crystal
# Writes *my_sound* to a .wav file
File.open("Path/To/WriteSound.wav") do |file|
  my_sound.to_wav(file)
end
```
### Raylib Additions

wa-cr takes advantage of [raylib-cr](https://github.com/sol-vin/raylib-cr) with ways to convert doom<br>
graphics to raylib images and draw said images to the screen
```crystal
# You'll need to require the wa-cr raylib additions as well as wa-cr
require "wa-cr/raylib"

palette = mywad.playpal.palettes[0]
my_graphic_image = my_graphic.to_tex(palette)
my_flat_image = my_flat.to_tex(palette)
# You can also get textures from the texture maps
my_texture_image = mywad.get_texture("texture_name_in_texturex", palette)
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
