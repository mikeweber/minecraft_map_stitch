class MinecraftMap
  COLOR_MAP = File.open(File.join(File.dirname(__FILE__), 'colors.txt')).read.split("\n")
  
  def initialize(raw_map_data)
    @map_data = NBTFile.load(raw_map_data)[1]['data']
  end
  
  def draw(new_map, offsets)
    @map_data['colors'].split('').each_with_index do |pixel, i|
      next if pixel.ord <= 3
      
      image_pixels = world_coord(i).zip(offsets).collect { |coord, offset| coord - offset }
      
      8.times do |x_offset|
        8.times do |y_offset|
          new_map[(image_pixels[0] + x_offset), (image_pixels[1] + y_offset)] = color(pixel.ord)
        end
      end
    end
  end
  
  def world_coord(pixel)
    world_offset(pixel).zip(self.center).collect { |offset, center| offset + center }
  end
  
  def world_offset(pixel)
    map_pixel_coord(pixel).collect { |p| (p - 64) * 8 }
  end
  
  def map_pixel_coord(pixel)
    [pixel % 128, pixel / 128]
  end
  
  def center
    [rounded(@map_data['xCenter']), rounded(@map_data['zCenter'])]
  end
  
  def rounded(int)
    int / 8 * 8
  end
  
  def color(ord)
    rgb = (COLOR_MAP[ord] || '0,0,0').split(',').collect { |c| c.to_i }
    ChunkyPNG::Color.rgb(*rgb)
  end
end
