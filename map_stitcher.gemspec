Gem::Specification.new do |s|
  s.name        = 'map_stitcher'
  s.version     = '0.1'
  s.date        = '2012-07-09'
  s.summary     = "Stitch together Minecraft maps"
  s.description = "This gem takes in the directory of your Minecraft map_*.dat files and combines them all into a single image."
  s.authors     = ["Mike Weber"]
  s.email       = 'mike@weberapps.com'
  s.files       = [
    "lib/map_stitcher.rb", 
    "lib/map_stitcher/minecraft_map.rb",
    "lib/map_stitcher/map_collector.rb",
    "lib/map_stitcher/colors.rb"
  ]
end
