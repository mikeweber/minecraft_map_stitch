minecraft_map_stitch
====================

This gem takes in the directory of your Minecraft map_*.dat files and combines them all into a single image

How to use
==========

Install the gem and call the following code, passing in the directory with all of your Minecraft map .dat files.

  require 'map_stitch'
  
  MapStitcher.stitch_maps("/Path/to/maps_dir")
