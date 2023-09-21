![logo](logo/wa-cr.png)

<!--
When adding a class:
* Add comments to the class and all its methods and variables
* Add to readme if needed
* Add the class to the cheatsheet
* Explain the class in the docs overview
-->

# Where's all the Crystal? | wa-cr

A Crystal library used to parse .wad and .lmp files into usable Crystal code,
write out to a .wad or .lmp file, and convert file types.

## Installation

1. Add `wa-cr` to your `shard.yml`:
```yml
dependencies:
  wa-cr:
    github: sol-vin/wa-cr
```

2. Run `shards install`

### Raylib Additions

To use the wa-cr's [Raylib](https://github.com/raysan5/raylib/releases)
additions, you must have [Raylib](https://github.com/raysan5/raylib/releases) installed:

- Install raylib by following the raylib-cr [installation instructions](https://github.com/sol-vin/raylib-cr#installation).
  - For Linux, follow step 1.
  - For Windows, follow steps 1-4.

## Usage

wa-cr includes many methods that make jumping into and out of a .wad or .lmp file very easy.<br>
Following is a brief overview of what wa-cr can do.<br>
For a complete overview see wa-cr's [docs](https://sol-vin.github.io/wad-reader/index.html)
and the [complete overview](https://sol-vin.github.io/wad-reader/Documentation.html).

### Wad Data

Reading in a .wad is easy by using `WAD.read(filepath or io)`
```crystal
# Reads in a wad and sets it to *my_wad*
my_wad = WAD.read("Path/To/Wad.WAD")
```
You can read in specific .lmp files too <sup> *.lmp* : an exported doom [Lump](https://doomwiki.org/wiki/Lump).</sup>
```crystal
# Reads in a sound lump file and sets it to *my_sound*
my_sound = WAD::Sound.parse("Path/To/Sound.lmp")
```
You can also add the data into the wad file with `WAD#add(name, type, file)`
```crystal
my_wad.add("MySound", "Sound", "Path/To/Sound.lmp")
```
And you can create entirely new wad files too with `WAD.new(type)`
```crystal
my_new_wad = WAD.new(WAD::Type::Internal)

# You can read data into that new WAD as well
my_new_wad.add("MySound", "Sound", "Path/To/Sound.lmp")
``` 

### Sound Converting

Converting doom-formatted sound data to a .wav file is just as simple by using `Sound#to_wav(filepath or io)`
```crystal
# Writes *my_sound* to a .wav file
my_sound.to_wav("Path/To/WriteSound.wav")
```

### Writing Additions

You can write out .wad and .lmp files from the parsed data as well by using `WAD#write(filepath or io)` and `ThingToWrite#write(filepath or io)`
```crystal
# Include the wa-cr write library
require "wa-cr/write"

# Write *my_wad* to *"MyWad.wad"*
my_wad.write("Path/To/MyWad.wad")


# Writes the *my_graphic* lump to a .lmp file
my_graphic.write("Path/To/MyLump.lmp")
```

### Raylib Additions

wa-cr takes advantage of [Raylib](https://github.com/raysan5/raylib/releases)
and [raylib-cr](https://github.com/sol-vin/raylib-cr) with ways to convert [.pngs](https://en.wikipedia.org/wiki/PNG)
or [Raylib Images](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
to doom graphics and doom graphics to
[Raylib Images](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
or [Raylib Colors](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
and draw said images or colors to the screen
```crystal
# Include the wa-cr raylib library
require "wa-cr/raylib"

palette = my_wad.playpal.palettes[0]

my_graphic_image = my_graphic.to_tex(palette)
my_flat_image = my_flat.to_tex(palette)
# You can also get textures from the texture maps
my_texture_image = my_wad.get_texture("texture_name_in_texturex", palette)

# Gets the pixel data in the graphic and the flat
my_graphic_pixel = my_graphic.get_pixel(20, 5, palette)
my_flat_pixel = my_flat.get_pixel(2, 10, palette)

# Gets a png as a doom graphic
my_graphic_png = WAD::Graphic.from_png("Path/To/MyGraphic.png", palette)
my_flat_png = WAD::Graphic.from_png("Path/To/MyFlat.png", palette)

# Png exports
my_wad.export_texture("MyTexture", "Path/To/MyTexture.png", palette)
my_graphic.to_png("Path/To/MyGraphic.png", palette)
my_flat.to_png("Path/To/MyFlat.png", palette)
```

### Apps

wa-cr provides useful apps that will help you with using `WAD` data.<br>
To access wa-cr's apps, just require `wa-cr/apps`
Here is a full list of all modules inside `Apps`:

- `Apps::MapViewer`
- `Apps::WadViewer` - WIP

## Limitations

* Demos won't work properly because of how the doom engine's psuedo-random number generator works. If the wads are different at all, the demos won't function as intended

## Contributing

1. Fork it (<https://github.com/sol-vin/wad-reader/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Devin Shwagginz](https://github.com/D-Shwagginz) - creator and maintainer
- [Ian Rash](https://github.com/sol-vin) - Code Review and DevOPS
