SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")

MapGenerator = class("MapGenerator")

function MapGenerator:initialize(seed)
  self.seed = seed
  self:incrementSeed(0)
  self.dt = { wave = 0 }
end

function MapGenerator:incrementSeed(dt)
  self.seed = self.seed + dt
  SimplexNoise.seedP(self.seed)
end

-- fill a whole map
function MapGenerator:randomize()
  self:newSea() -- layer 4
  self:newBeach(5, 1/4) -- layer 5
  self:newWave(1) -- waves are layer 10
  self:newWave(2)
  self:newWave(3)
  self:newBeach(20, 1/7)
end

function MapGenerator:update(dt)
  self.dt.wave = self.dt.wave + dt
  if self.dt.wave > 0.7 then
    self:incrementSeed(1)
    self.dt.wave = 0
    self:newWave(1)
  end
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

function MapGenerator:newWave(offset_y)
  print('Add wave')
  wave_factor = 6

  local tiles = self:fillTiles(1, 1, self.map.width, wave_factor,
    function(x,y)
      local w = math.floor(SimplexNoise.Noise2D(x*0.002, y*0.03)*200) % (60+offset_y)
      if y == wave_factor / 2 then
        return w * 3
      else
        return w
      end
    end
  )
  return self.map:addEntity(Wave({x = 0, y = self.map.height - offset_y + wave_factor, z = 2, speed = 1 }, tiles))
end

function MapGenerator:newSea()
  -- tiles are all colour values
  local tiles = self:fillTiles(1, 1, self.map.width, self.map.height,
    function(x,y) return {
      50,
      50,
      100 + math.floor((SimplexNoise.Noise2D(x*0.005, y*0.1) + 1) * 50) % 50,
      255 } end
  )
  return self.map:addEntity(Plane({x = 0, y = 0, z = 4}, tiles))
end

function MapGenerator:newBeach(z, depth)
  local tiles = self:fillTiles(1, 1, self.map.width, self.map.height * depth,
    function(x,y) return { 250, 250, 240 - math.floor((SimplexNoise.Noise2D(x*0.1, y*0.1) + 1) * 130) % 100,255} end
  )
  return self.map:addEntity(Plane({x = 0, y = 0, z = z}, tiles))
end

function MapGenerator:fillTiles(x1, y1, x2, y2, callback)
  local tiles = {}
  for x=math.floor(x1), math.floor(x2-x1+1) do
    tiles[x] = {}
    for y=math.floor(y1), math.abs(math.floor(y2-y1+1)) do
      tiles[x][y] = callback(x,y)
    end
  end
  return tiles
end
