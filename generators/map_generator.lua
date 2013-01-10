SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")

MapGenerator = class("MapGenerator")

function MapGenerator:initialize(seed)
  self.map = nil
  self.level = nil
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
  self:newBeach(5, 10) -- layer 5
  self:newWave(1) -- waves are layer 10
  self:newWave(3)
  self:newWave(5)
  self:newBeach(20, 7)
  self.level.player = self:newActor(Player, 21, 1, 6/self.map.height) -- place on the beach
end

function MapGenerator:update(dt)
  self.dt.wave = self.dt.wave + dt
  if self.dt.wave > 1 then
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

-- klass: Player, Actor etc
-- x1, y1, x2, y2 to limit the area where to spawn
function MapGenerator:newActor(klass, z, x1, y1, x2, y2)
  local actor = klass()
  local position = self:seedPosition(x1 or 1, y1 or 1,
      x2 or self.map.width, y2 or self.map.height)
  actor.position.x = position.x
  actor.position.y = position.y
  actor.position.z = z or 1
  print(position.x, position.y)
  self.map:addEntity(actor)
  return actor
end

function MapGenerator:newWave(offset_y)
  wave_factor = 6
  x = math.abs(math.floor(SimplexNoise.Noise2D(offset_y, wave_factor) * self.map.width))
  y = 1
  width = math.abs(math.floor(SimplexNoise.Noise2D(x, wave_factor) * self.map.width)) + 2*wave_factor
  local tiles = self:fillTiles(1, 1, width, wave_factor,
    function(x,y)
      local w = math.floor(SimplexNoise.Noise2D(x*0.002, y*0.03)*200) % (60+offset_y)
      if y == math.floor(wave_factor / 2) then
        return w * 3
      else
        return w
      end
    end
  )
  return self.map:addEntity(Wave({x = x, y = self.map.height - offset_y + wave_factor, z = 10, speed = ((width * 101) % 5) + 10 }, tiles))
end

function MapGenerator:newSea()
  -- tiles are all colour values
  local darkening = self.map.height / 10
  local tiles = self:fillTiles(1, 1, self.map.width, self.map.height,
    function(x,y) return {
      0,
      0,
      math.max(0, 200 - darkening * y + math.floor((SimplexNoise.Noise2D(x*0.001, y*0.1) + 1) * 50) % 50),
      255 } end
  )
  return self.map:addEntity(Plane({x = 0, y = 0, z = 4}, tiles))
end

function MapGenerator:newBeach(z, depth)
  local tiles = self:fillTiles(1, 1, self.map.width, depth,
    function(x,y)
      local color_offset = math.floor((self.map.height/4-y)*10)
      return
        {240 - color_offset,
         200 - color_offset,
         190 + math.floor((SimplexNoise.Noise2D(x*0.1, y*0.1) + 1) * 80) % 40 - color_offset,
         255 }
    end
  )
  return self.map:addEntity(Plane({x = 1, y = 1, z = z}, tiles))
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
