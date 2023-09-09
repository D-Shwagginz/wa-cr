module Documentation
  module D_Cheatsheet
    # - Reading
    #   - `WAD` - Stores all of the information relating to a WAD
    #     - `WAD.new(type)` - Creates a new `WAD` with `WAD.type`
    #     - `WAD.read(wad_file)` - Read in file in WAD format
    #     - `WAD#add(name, type, filename)` - Reads in *filename* as format *type*<br>
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
    #       - `WAD::Map::Thing` - A thing
    #       - `WAD::Map::Linedef` - A linedef
    #       - `WAD::Map::Sidedef` - A sidedef
    #       - `WAD::Map::Vertex` - A vertex
    #       - `WAD::Map::Seg` - A seg
    #       - `WAD::Map::Ssector` - A sub sector
    #       - `WAD::Map::Node` - A node
    #       - `WAD::Map::Sector` - A sector
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
    #     - `WAD::Sound.from_wav(io) ` Converts a .wav to a `WAD::Sound`
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
    #     - `WAD::Graphic.parse(io, file_offset, file_size)` - Reads in the io in graphic format.<br>
    #       Returns `nil` if *io* is not a valid graphic.
    #     - `WAD::Graphic.is_sprite_mark_start?(name)` - Checks if *name* is a sprite start marker
    #     - `WAD::Graphic.is_sprite_mark_end?(name)` - Checks if *name* is a sprite end marker
    #     - `WAD::Graphic#set_pixel(x, y, value)` - Sets the pixel at (x, y) to be *value*
    #     - `WAD::Graphic#[](x, y)` - Returns the  *x*, *y* pixel index in the palette for the graphic
    #
    #   - `WAD::Flat` - Stores the information of a flat
    #     - `WAD::Flat.parse(io)` - Reads in the io in flat format.<br>
    #     - `WAD::Flat.is_flat_mark_start?(name)` - Checks if *name* is a flat start marker
    #     - `WAD::Flat.is_flat_mark_end?(name)` - Checks if *name* is a flat end marker
    #     - `WAD::Flat#set_pixel(x, y, value)` - Sets the pixel at (x, y) to be *value*
    #     - `WAD::Flat#[](x, y)` - Returns the  *x*, *y* pixel index in the palette for the graphic
    #
    #   - `WAD::Demo` - Stores the information of a demo
    #     - `WAD::Demo.parse(io)` - Reads in the io in demo format
    #     - `WAD::Demo.is_demo?(io)` - Checks if the io is of demo format
    #
    module A_Reading
    end
  end
end
