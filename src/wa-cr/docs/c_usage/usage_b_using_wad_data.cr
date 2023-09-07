module Documentation
  module C_Usage
    # Getting data from a `WAD` is fairly simple.<br>
    # Everything in a `WAD` is stored in either a hash or
    # just as the object it is storing:
    #
    # ```
    # my_wad.sounds  # => A hash of all sounds in the WAD
    # my_wad.playpal # => A variable assigned to the playpal in the WAD
    # ```
    #
    # Here is a list of every variable in the `WAD` class
    # with a link to its full explanation on the doom wiki
    #
    # `WAD#type : WAD::Type` - The type of the `WAD` - [Wiki](https://doomwiki.org/wiki/WAD#:~:text=4-,identification,-The%20ASCII%20characters)<br>
    # `WAD#directories_count : UInt32` - The amount of lumps in the `WAD` - [Wiki](https://doomwiki.org/wiki/WAD#:~:text=4-,numlumps,-An%20integer%20specifying)<br>
    # `WAD#directory_pointer : UInt32` - The location of the start of the directories in bytes - [Wiki](https://doomwiki.org/wiki/WAD#:~:text=4-,infotableofs,-An%20integer%20holding)<br>
    # `WAD#maps : Hash(String, Map)` - A hash that maps a name to a `WAD::Map` - [Wiki](https://doomwiki.org/wiki/WAD#:~:text=location%20is%20crucial.-,Map%20data%20lumps,-%5Bedit%5D)<br>
    # `WAD#pcsounds : Hash(String, PcSound)` - A hash that maps a name to a `WAD::PcSound` - [Wiki](https://doomwiki.org/wiki/PC_speaker_sound_effects)<br>
    # `WAD#sounds : Hash(String, Sound)` - A hash that maps a name to a `WAD::Sound` - [Wiki](https://doomwiki.org/wiki/Sound)<br>
    # `WAD#music : Hash(String, Music)` - A hash that maps a name to a `WAD::Music` - [Wiki](https://doomwiki.org/wiki/MUS)<br>
    # `WAD#genmidi : WAD::Genmidi` - The genmidi of the `WAD` - [Wiki](https://doomwiki.org/wiki/GENMIDI)<br>
    # `WAD#dmxgus : WAD::Dmxgus` - The dmxgus of the `WAD` - [Wiki](https://doomwiki.org/wiki/DMXGUS)<br>
    # `WAD#playpal : WAD::Playpal` - The playpal of the `WAD` - [Wiki](https://doomwiki.org/wiki/PLAYPAL)<br>
    # `WAD#colormap : WAD::Colormap` - The colormap of the `WAD` - [Wiki](https://doomwiki.org/wiki/COLORMAP)<br>
    # `WAD#endoom : WAD::EnDoom` - The EnDoom of the `WAD` - [Wiki](https://doomwiki.org/wiki/ENDOOM)<br>
    # `WAD#texmaps : Hash(String, TextureX)` - A hash that maps a name to a `WAD::TextureX` - [Wiki](https://doomwiki.org/wiki/TEXTURE1_and_TEXTURE2)<br>
    # `WAD#pnames : WAD::Pnames` - The pnames of the `WAD` - [Wiki](https://doomwiki.org/wiki/PNAMES)<br>
    # `WAD#graphics : Hash(String, Graphic)` - A hash that maps a name to a `WAD::Graphic` - [Wiki](https://doomwiki.org/wiki/Graphics)<br>
    # `WAD#sprites : Hash(String, Graphic)` - A hash that maps a name to a `WAD::Graphic` - [Wiki](https://doomwiki.org/wiki/Sprite)<br>
    # `WAD#flats : Hash(String, Flat)` - A hash that maps a name to a `WAD::Flat` - [Wiki](https://doomwiki.org/wiki/Flat)<br>
    # `WAD#demos : Hash(String, Demo)` - A hash that maps a name to a `WAD::Demo` - [Wiki](https://doomwiki.org/wiki/Demo)<br>
    # `WAD#directories : Array(Directory)` - An array of all the `WAD::Directory`'s in the `WAD` - [Wiki](https://doomwiki.org/wiki/WAD#:~:text=serving%20as%20IWADs.-,Directory,-%5Bedit%5D)
    #
    # NOTE: `WAD#texmaps` maps a name to a `WAD::TextureX`, not a "`WAD::TexMap`".
    #
    # The reason for this class name is because a texture map's file name will always
    # have the format "TextureX" where X is a number, which the class' name reflects.<br>
    # It also helps to prevent confusion when talking about a texture map, since
    # the data inside a texture map/TextureX are called texture maps - [Wiki](https://doomwiki.org/wiki/TEXTURE1_and_TEXTURE2#:~:text=equal%20to%20integers.-,Map%20textures%20structure%2C%20binary%20data,-%5Bedit%5D)
    #
    # Here are a few examples of how to access `WAD`'s data:
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad") # => Reads in the wad
    #
    # my_sound = my_wad.sounds["MySound"] # => Returns the sound "MySound" out of *my_wad*
    #
    # my_map = my_wad.maps["MyMap"]                 # => Returns the map "MyMap" out of *my_wad*
    # my_linedef = my_map.linedefs[0]               # => Returns the first linedef out of *my_map*
    # my_linedef_sector_tag = my_linedef.sector_tag # => Returns the sector tag of the linedef
    # ```
    module B_UsingWadData
    end
  end
end
