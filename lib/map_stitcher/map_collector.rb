class MapCollector
  attr_reader :full_map, :west_border, :east_border, :north_border, :south_border
  
  def initialize(map_dir = '.')
    @map_dir = map_dir
    
    east_west   = self.minecraft_maps.collect { |map| rounded(map.center[0]) }
    north_south = self.minecraft_maps.collect { |map| rounded(map.center[1]) }
    
    # Determine the edges of our maps
    @west_border  = east_west.min - 512
    @east_border  = east_west.max + 512
    @north_border = north_south.min - 512
    @south_border = north_south.max + 512
    
    @full_map = ChunkyPNG::Image.new(self.width, self.height, ChunkyPNG::Color::TRANSPARENT)
  end
  
  def stitch_maps
    self.minecraft_maps.each do |mc_map|
      mc_map.draw(self.full_map, [self.west_border, self.north_border])
    end
    
    overlay_grid
    
    new_filename = File.join(@map_dir, 'full_map.png')
    if File.exists?(new_filename)
      timestamp = Time.now.strftime('%Y%m%d%H%M')
      FileUtils.mv(new_filename, File.join(@map_dir, "full_map_#{timestamp}.png"))
    end
    
    full_map.save(new_filename)
  end
  
  def minecraft_maps(reload = false)
    @minecraft_maps = nil if reload
    
    if @minecraft_maps.nil?
      @minecraft_maps = []
      Dir.foreach(@map_dir) do |f|
        next unless f =~ /\.dat$/
        
        @minecraft_maps << MinecraftMap.new(File.read(File.join(@map_dir, f)))
      end
      raise "Could not find any map data files in this folder" if @minecraft_maps.empty?
    end
    
    return @minecraft_maps
  end
  
  def width
    self.east_border - self.west_border
  end
  
  def height
    self.south_border - self.north_border
  end
  
  def overlay_grid
    grid_offsets = self.minecraft_maps.first.center.collect { |c| grid_interval - (c % grid_interval) }
    
    x_offset = grid_offsets[0]
    while x_offset <= self.width
      self.full_map.line(x_offset, 0, x_offset, self.height, ChunkyPNG::Color.rgba(0, 0, 0, 128))
      x_offset += grid_interval
    end
    
    y_offset = grid_offsets[1]
    while y_offset <= self.height
      self.full_map.line(0, y_offset, self.width, y_offset, ChunkyPNG::Color.rgba(0, 0, 0, 128))
      y_offset += grid_interval
    end
  end
  
  def grid_interval
    100
  end
  
  def rounded(int)
    int / 8 * 8
  end
end
