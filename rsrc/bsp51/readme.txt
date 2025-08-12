   This is v5.1 of BSP, one of the best node builders for Doom.

   BSP is currently maintained by Colin Phipps. Please see the BSP homepage
   for news about BSP, the latest releases, and other resources.

What are Nodes?

   Doom uses a rendering algorithm based on a binary space partition,
   otherwise known as a BSP tree. This is stored in a data lump called NODES
   in the WAD file. So tools to build the BSP tree are known as node
   builders.

   Before you can play a level that you have created, you must use a node
   builder to create the data that Doom will use to render the level. BSP is
   one of several node builders that can do this.

Features

     * Fast Doom node builder.
     * Supports a number of special effects.
     * Supports multi-level WADs. Preserves non-level data in WADs.
     * Includes an optional alternative algorithm for choosing the nodes
       which reduces the chance of visplane overflows.
     * Optional support for compressing the blockmap.
     * Compiles on DOS, Win32, Linux, UNIX.
     * Supports big endian systems.

Getting BSP

   For Linux and UNIX systems, you can download and compile the BSP source
   code. bsp-5.1.tar.gz contains complete source code. See the included file
   INSTALL for instructions.

   For DOS and Win32 systems, download bsp51.zip, which contains binaries for
   DOS and Win32 (that is, Windows 95/98/NT/ME/2000/XP). bsp.exe is the
   version for DOS (note: it requires the accompanying dos4gw.exe).
   bsp-w32.exe is the version for Win32.

   The latest version of these files can be downloaded at the download page
   on the BSP site.

Usage

   bsp [ -noreject ] [-factor nn ] [ -q ] [ -picknode { traditional |
   visplane } ] [ -blockmap { old | comp } ] inwad [ [ -o ] outwad ]

   Where:

   -noreject
           Causes any existing REJECT lump in the WAD file not to be
           replaced.

   -factor nn
           Used for tuning the node builder. The number supplied is the
           weighting applied when a choice of nodeline requires other lines
           to be split. Increasing this value from the default of 17 will
           reduce the number of extra line splits, but this will generally
           cause a less balanced node tree. The default is usually fine.

   -q
           Causes BSP to run quietly, only printing output if there are
           errors or warnings.

   -picknode
           Determines the nodeline selection algorithm. The "traditional"
           option is best for most Doom levels. For levels which are intended
           for the original doom2.exe and suffer from some marginal visplane
           overflows, the "visplane" algorithm is designed to minimise these
           and may help in some cases. See the included visplane.txt for more
           information.

   -blockmap
           Selects the blockmap generation algorithm. The default "old"
           algorithm generates a simple and correct blockmap. The newer
           "comp" version produces a compressed blockmap, by reusing
           identical blocks which should be equivalent in actual use. The
           "comp" version is therefore better but it relatively untested so
           is not yet enabled by default.

   inwad is the input WAD file. This may contain any number of levels and
   other lumps. The nodes and associated data resources will be built for
   every level in this WAD. Any other data present in the WAD will be copied
   to the output WAD unchanged.

   outwad is the output WAD file. If the output file already exists, BSP will
   write it's output to a temporary file while it is working, and will only
   overwrite the output file once it is finished. In particular, it is safe
   for outwad to be the same as inwad, although this is not recommended
   unless you keep other backups :-).

   Either inwad or outwad can be pipes or special files. On most UNIX
   systems, you can have BSP read from STDIN and write to STDOUT by using it
   as follows: bsp -q /dev/stdin /dev/stdout

Special Effects

     * HOM-free transparent doors:

       Simply make the sector referenced by the doortracks have a sector tag
       of >= 900. No need to remember sector numbers and type them in on a
       command line -- just use any sector tag >= 900 to permanently mark the
       sector special.

       See TRANSDOR.WAD for an example of sector tags in the 900's being used
       to create HOM-free transparent door effects.

     * Precious lines:

       If a linedef has a sector tag >= 900, then it is treated as "precious"
       and will not be split unless absolutely necessary. This is good to use
       around borders of deep water, invisible stairs, etc.

       Furthermore, just for grins, if the linedef's tag is 999, then the
       sidedefs' x-offsets set an angle adjustment in degrees to be applied
       -- you can look straight at a wall, but it might come right at you on
       both sides and "stretch".

Copyright

 Node builder for DOOM levels (c) 1998 Colin Reed, Lee Killough
                              (c) 2001 Simon Howard
                              (c) 2000,2001,2002 Colin Phipps

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the Free
   Software Foundation; either version 2 of the License, or (at your option)
   any later version. See the file COPYING for details.

   See the included file AUTHORS for a complete list of contributors.
