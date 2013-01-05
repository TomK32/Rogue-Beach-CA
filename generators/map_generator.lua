SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")

MapGenerator = class("MapGenerator")

function MapGenerator:initialize(seed, map)
  self.seed = seed
  self.map = map
  SimplexNoise.seedP(self.seed)
end

-- fill a whole map
function MapGenerator:randomize()
  self:newBeach()
end

-- int, int, 0..1, 0..1, int, int
function MapGenerator:seedPosition(seed_x,seed_y, scale_x, scale_y, offset_x, offset_y)
  scale_x = scale_x or 1
  scale_y = scale_y or 1
  offset_x = offset_x or 0
  offset_y = offset_y or 0
  return {
    x = math.floor(((SimplexNoise.Noise2D(seed_x*0.1, seed_x*0.1)) * 120) % math.floor(scale_x * self.map.width-1) + offset_x) + 1,
    y = math.floor(((SimplexNoise.Noise2D(seed_y*0.1, seed_y*0.1)) * 120) % math.floor(scale_x * self.map.height-1) + offset_y) + 1
  }
end

function MapGenerator:newBeach()
  local tiles = {}
  for x=1, self.map.width do
    tiles[x] = {}
    for y=1, self.map.height/4 do
      tiles[x][y] = math.floor((SimplexNoise.Noise2D(x*0.1, y*0.1) + 1) * 120) % 255
    end
  end
  local beach = Beach({x = 1, y = 1, z = 1}, tiles)
  beach.map = self.map
  return map:addEntity(beach)
end

function MapGenerator:randomizeBeach()
end

