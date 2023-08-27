require "./wad-reader/**"
require "raylib-cr"
require "bit_array"
require "debug"

{% if flag?(:debug) %}
  Debug.enabled = true
{% end %}

# mywad = WAD.read("./rsrc/DOOM.WAD")
