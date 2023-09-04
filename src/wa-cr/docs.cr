# ### This is an overview of how to install and use wa-cr to it's fullest
module A_Overview
  # # Where's all the Crystal? | wa-cr
  #
  # wa-cr, or "Where's all the Crystal?," is a Crystal library used to read in and write
  # out [.WAD](https://doomwiki.org/wiki/WAD) files and [lump](https://doomwiki.org/wiki/Lump) data.<br>
  # It uses the `WritingAdditions` module to make writing lump and wad data seamless.<br>
  # It also has the `RaylibAdditions` module which combines [Raylib](https://github.com/raysan5/raylib/tree/master)
  # and [Raylib-cr](https://github.com/sol-vin/raylib-cr) to allow converting from a wad graphic, flat, or sprite to
  # a [Raylib Image](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
  # or a [Raylib Pixel](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
  #
  # Reading in and writing out a wad is as easy:
  # ```
  # require "wa-cr"
  # require "wa-cr/write"
  #
  # my_wad = WAD.read("Path/To/Wad")
  #
  # my_wad.write("Path/To/my_wad.WAD")
  # ```
  #
  # Reading in and writing out a lump is just as easy:
  #
  # ```
  # require "wa-cr"
  # require "wa-cr/write"
  #
  # my_sound_lump = my_wad.sounds.values[0]
  #
  # my_sound_lump.write("Path/To/my_sound.lmp")
  # ```
  #
  # And you can read that lump back into a new WAD:
  #
  # ```
  # require "wa-cr"
  #
  # my_wad = WAD.new
  #
  # my_wad.sounds["MyTest"] = WAD::Sound.read_file
  # ```
  #
  module A_Introduction
  end

  module B_Installation
  end

  module C_Usage
  end

  # #### A cheatsheet that has links to useful methods and variables
  module D_Cheatsheet
    # - Reading
    #   - `WAD` - Stores all of the information relating to a WAD
    #     - `WAD.read(wad_file)` - Read in file in WAD format
    #     - `WAD#parse(name, type, filename)` - Reads in *filename* as format *type*<br>
    #       and puts it into the `WAD` with *name*
    #     - `WAD#type` - The type of a `WAD`
    #     - `WAD#maps` - The maps in the `WAD`
    #     - `WAD#pcsounds` - The pc sounds in the `WAD`
    #     - `WAD#sounds` - The sounds in the `WAD`
    #     - `WAD#music` - The music in the `WAD`
    #     - `WAD#genmidi` - The genmidi of the `WAD`
    #     - `WAD#dmxgus` - The dmxgus of the `WAD`
    #     - `WAD#playpal` - The playpal of the `WAD`
    #     - `WAD#colormap` - The colormap of the `WAD`
    #     - `WAD#endoom` - The EnDoom of the `WAD`
    #     - `WAD#texmaps` - The texture maps of the `WAD`
    #     - `WAD#pnames` - The Pnames of the `WAD`
    #     - `WAD#graphics` - The graphics in the `WAD`
    #     - `WAD#sprites` - The sprites in the `WAD`
    #     - `WAD#flats` - The flats in the `WAD`
    #     - `WAD#demos` - The demos in the `WAD`
    #     - `WAD#directories` - The directories in the `WAD`
    #
    #   - `WAD::Directory` - Stores the information about a lump
    #     - `WAD::Directory.read(io, file_offset)` - Reads the io in directory format
    #
    #   - `WAD::Map` - Stores all of the information relating to a map
    #     - `WAD::Map.is_map?(name)` - Check if *name* is of map name format
    #     - `WAD::Map#things` - All things in the map
    #     - `WAD::Map#linedefs` - All linedefs in the map
    #     - `WAD::Map#sidedefs` - All sidedefs in the map
    #     - `WAD::Map#vertexes` - All vertexes in the map
    #     - `WAD::Map#segs` - All segs in the map
    #     - `WAD::Map#ssectors` - All ssectors in the map
    #     - `WAD::Map#nodes` - All nodes in the map
    #     - `WAD::Map#sectors` - All sectors in the map
    #     - `WAD::Map#reject` - The reject table of the map
    #     - `WAD::Map#blockmap` - The blockmap of the map
    #       - `WAD::Map::Things` - A thing
    #       - `WAD::Map::Linedefs` - A linedef
    #       - `WAD::Map::Sidedefs` - A sidedef
    #       - `WAD::Map::Vertexes` - A vertex
    #       - `WAD::Map::Segs` - A seg
    #       - `WAD::Map::Ssectors` - A sub sector
    #       - `WAD::Map::Nodes` - A node
    #       - `WAD::Map::Sectors` - A sector
    #       - `WAD::Map::Reject` - The reject table
    #       - `WAD::Map::Blockmap` - The blockmap
    #
    #   - `WAD::PcSound` - Stores the information of a pc sound
    #     - `WAD::PcSound.parse(io)` - Reads in the io in pcsound format
    #     - `WAD::PcSound.is_pcsound?(name)` - Checks if *name* is of pcsound name format
    #
    #   - `WAD::Sound` - Stores the information of a sound
    #     - `WAD::Sound.parse(io)` - Reads in the io in sound format
    #     - `WAD::Sound.is_sound?(name)` - Checks if *name* is of sound name format
    #     - `WAD::Sound#to_wav(io)` - Outputs the sound to *io* in .wav format
    #
    #   - `WAD::Music` - Stores the information of a music
    #     - `WAD::Music.parse(io)` - Reads in the io in music format
    #     - `WAD::Musicis_music?(name)` Checks if *name* is of music name format
    #
    #   - `WAD::Genmidi` - Stores the information of the genmidi
    #     - `WAD::Genmidi.parse(io)` - Reads in the io in genmidi format
    #     - `WAD::Genmidi.is_genmidi?(name)` Checks if *name* is of genmidi name format
    #
    #   - `WAD::Dmxgus` - Stores the information of the dmxgus
    #     - `WAD::Dmxgus.parse(io)` - Reads in the io in dmxgus format
    #     - `WAD::Dmxgus.is_dmxgus?(name)` - Checks if *name* is of dmxgus name format
    #
    #   - `WAD::Playpal` - Stores the information of the playpal
    #     - `WAD::Playpal.parse(io)` -  Reads in the io in playpal format
    #     - `WAD::Playpal.is_playpal?(name)` - Checks if *name* is of playpal name format
    #     - `WAD::Playpal#palettes` - The color palettes in the playpal
    #
    #   - `WAD::Colormap` - Stores the information of the colormap
    #     - `WAD::Colormap.parse(io)` - Reads in the io in colormap format
    #     - `WAD::Colormap.is_colormap?(name)` - Checks if *name* is of colormap name format
    #
    #   - `WAD::EnDoom` - Stores the information of the endoom
    #     - `WAD::EnDoom.parse(io)` - Reads in the io in endoom format
    #     - `WAD::EnDoom.is_endoom?(name)` - Checks if *name* is of endoom name format
    #
    #   - `WAD::TextureX` - Stores the information of a texture map
    #     - `WAD::TextureX.parse(io)` - Reads in the io in texture map format
    #     - `WAD::TextureX.is_texturex?(name)` - Checks if *name* is of texture map name format
    #
    #   - `WAD::Pnames` - Stores the information of the pnames
    #     - `WAD::Pnames.parse(io)` - Reads in the io in pnames format
    #     - `WAD::Pnames.is_pnames?(name)` - Checks if *name* is of pnames name format
    #
    #   - `WAD::Graphic` - Stores the information of a graphic
    #     - `WAD::Graphic.parse(io, file_offset)` - Reads in the io in graphic format.<br>
    #       Returns `nil` if *io* is not a valid graphic.
    #     - `WAD::Graphic.is_sprite_mark_start?(name)` - Checks if *name* is a sprite start marker
    #     - `WAD::Graphic.is_sprite_mark_end?(name)` - Checks if *name* is a sprite end marker
    #     - `WAD::Graphic#[](x, y)` - Returns the  *x*, *y* pixel index in the palette for the graphic
    #
    #   - `WAD::Flat` - Stores the information of a flat
    #     - `WAD::Flat.parse(io)` - Reads in the io in flat format.<br>
    #     - `WAD::Flat.is_flat_mark_start?(name)` - Checks if *name* is a flat start marker
    #     - `WAD::Flat.is_flat_mark_end?(name)` - Checks if *name* is a flat end marker
    #     - `WAD::Flat#[](x, y)` - Returns the  *x*, *y* pixel index in the palette for the graphic
    #
    #   - `WAD::Demo` - Stores the information of a demo
    #     - `WAD::Demo.parse(io)` - Reads in the io in demo format
    #     - `WAD::Demo.is_demo?(io)` - Checks if the io is of demo format
    #
    module A_Reading
    end

    # - Writing - `WritingAdditions` - The module housing all of the write methods
    #   - `WritingAdditions.file_write(object, file)` - Writes the object to a file. Condenses file writing down to one line
    #   - `WritingAdditions::WAD#write(io)` - Writes a `WAD` to *io* and returns the size of data written
    #   - `WritingAdditions::Map#write(io)` - Writes a `WAD::Map` to *io* and returns all the directories for the data written
    #     - `WritingAdditions::Map::Things.write(io, things)` - Writes an array of *things* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Linedefs.write(io, linedefs)` - Writes an array of *linedefs* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Sidedefs.write(io, sidedefs)` - Writes an array of *sidedefs* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Vertexes.write(io, vertexes)` - Writes an array of *vertexes* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Segs.write(io, segs)` - Writes an array of *segs* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Ssectors.write(io, ssectors)` - Writes an array of *ssectors* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Nodes.write(io, nodes)` - Writes an array of *nodes* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Sectors.write(io, sectors)` - Writes an array of *sectors* to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Reject#write(io)` - Writes a reject to *io* and returns the directory for the data written
    #     - `WritingAdditions::Map::Blockmap#write(io)` - Writes a blockmap to *io* and returns the directory for the data written
    #   - `WritingAdditions::PcSound#write(io)` - Writes a `WAD::PcSound` to *io* and returns the size of data written
    #   - `WritingAdditions::Sound#write(io)` - Writes a `WAD::Sound` to *io* and returns the size of data written
    #   - `WritingAdditions::Music#write(io)` - Writes a `WAD::Music` to *io* and returns the size of data written
    #   - `WritingAdditions::Genmidi#write(io)` - Writes a `WAD::Genmidi` to *io* and returns the size of data written
    #   - `WritingAdditions::Dmxgus#write(io)` - Writes a `WAD::Dmxgus` to *io* and returns the size of data written
    #   - `WritingAdditions::Playpal#write(io)` - Writes a `WAD::Playpal` to *io* and returns the size of data written
    #   - `WritingAdditions::Colormap#write(io)` - Writes a `WAD::Colormap` to *io* and returns the size of data written
    #   - `WritingAdditions::EnDoom#write(io)` - Writes a `WAD::EnDoom` to *io* and returns the size of data written
    #   - `WritingAdditions::TextureX#write(io)` - Writes a `WAD::TextureX` to *io* and returns the size of data written
    #   - `WritingAdditions::Pnames#write(io)` - Writes a `WAD::Pnames` to *io* and returns the size of data written
    #   - `WritingAdditions::Graphic#write(io)` - Writes a `WAD::Graphic` to *io* and returns the size of data written
    #   - `WritingAdditions::Flat#write(io)` - Writes a `WAD::Flat` to *io* and returns the size of data written
    #   - `WritingAdditions::Demo#write(io)` - Writes a `WAD::Demo` to *io* and returns the size of data written
    #
    module B_WritingAdditions
    end

    # - Raylib: `RaylibAdditions` - The module housing all of the raylib methods
    #   - `RaylibAdditions::WAD#get_texture(name, palette)` - Gets a texture from a the `WAD`'s<br>
    #     texture map and creates a `Raylib::Image` by using the palette
    #   - `RaylibAdditions::Graphic#to_tex(palette)` - Converts a graphic to a `Raylib::Image` by using the palette
    #     - `RaylibAdditions::Graphic#get_color(x, y)` - Gets a *Raylib::Color* at the graphic pixel *x*, *y*
    #   - `RaylibAdditions::Flat#to_tex(palette)` - Converts a flat to a `Raylib::Image` by using the palette
    #     - `RaylibAdditions::Flat#get_color(x, y)` - Gets a *Raylib::Color* at the flat pixel *x*, *y*
    #
    module C_RaylibAdditions
    end

    # - Extras
    #   - Cut a string down to a max length: `WAD.string_cut(string, len)`
    #   - Cut a slice down to a max length: `WAD.slice_cut(slice, len)`
    #
    module D_Extras
    end
  end
end
