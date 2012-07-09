require 'nbtfile'
require 'chunky_png'
require 'fileutils'
require 'map_stitcher/minecraft_map'
require 'map_stitcher/map_collector'

class MapStitcher
  def self.stitch_maps(map_dir = '.')
    MapCollector.new(map_dir).stitch_maps
  end
end
