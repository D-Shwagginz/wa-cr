module A_Overview
  module D_Cheatsheet
    # - Writing: `WritingAdditions` - The module housing all of the write methods
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
    module B_WritingAdditions
    end
  end
end
