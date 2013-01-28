SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")

MapGenerator = class("MapGenerator")

function MapGenerator:initialize(seed)
  self.map = nil
  self.level = nil
  self.seed = seed
  self:incrementSeed(0)
  self.dt = { wave = 0 }
  -- make waves go sideways
  self.orientation = ( SimplexNoise.Noise2D(self.seed, 1) / 5 + math.pi / 2 * 3) % math.pi
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
  self:newWave(self.map.height / 2)
  self.level.player = self:newActor(Player, 21) -- place on the beach
end

function MapGenerator:update(dt)
  self.dt.wave = self.dt.wave + dt
  if self.dt.wave > 2 and self:waveCount() < math.max(8, self.map.height / 4) then
    self.dt.wave = 0
    self:incrementSeed(1)
    self:newWave(1)
  end
end
function MapGenerator:waveCount()
  return #self.map.layers[10]
end

-- int, int, 0..1, 0..1, int, int
function MapGenerator:seedPosition(seed_x,seed_y, scale_x, scale_y, offset_x, offset_y)
  scale_x = scale_x or 1
  scale_y = scale_y or 1
  offset_x = offset_x or 0
  offset_y = offset_y or 0
  return {
    x = math.floor((((SimplexNoise.Noise2D(seed_x*0.1, seed_x*0.1)) * self.map.width) % math.floor(scale_x * self.map.width-1)) + offset_x) + 1,
    y = math.floor((((SimplexNoise.Noise2D(seed_y*0.1, seed_y*0.1)) * self.map.height) % math.floor(scale_y * self.map.height-1)) + offset_y) + 1
  }
end

-- klass: Player, Actor etc
-- x1, y1, x2, y2 to limit the area where to spawn
function MapGenerator:newActor(klass, z, x1, y1, x2, y2)
  local actor = klass()
  actor.position.x = self.map.width / 2
  actor.position.y = 2
  actor.position.z = z or 1
  actor.orientation = math.pi * 1.5
  self.map:addEntity(actor)
  return actor
end

function MapGenerator:newWave(offset_y)
  local wave_factor = 6
  local center = math.floor(wave_factor / 2)
  x = math.abs(math.floor(SimplexNoise.Noise2D(offset_y, wave_factor) * self.map.width))
  y = offset_y
  width = math.abs(math.floor(SimplexNoise.Noise2D(x, wave_factor) * self.map.width)) + 2 * wave_factor
  speed = ((width * 101) % 10) + 2
  beach_y = math.floor(2 + speed / 2) -- point where the wave is being removed
  local tiles = self:fillTiles(1, 1, width, wave_factor,
    function(x,y)
      local w = math.floor(SimplexNoise.Noise2D(x*0.002, y*0.03)*200) % 60
      if y == center then
        return w * 3
      else
        return w
      end
    end
  )
  return self.map:addEntity(Wave({x = x, y = self.map.height - offset_y + wave_factor, z = 10, speed = speed}, self.orientation, tiles, beach_y))
end

function MapGenerator:newSea()
  -- tiles are all colour values
  local darkening = self.map.height / 8
  local tiles = self:fillTiles(1, 1, self.map.width, self.map.height,
    function(x,y)
      local factor = math.min(255, math.max(y, (255 - darkening * y) +
          math.floor((SimplexNoise.Noise2D(x*50000, y*50000) + 1) * 16) % 16) +
          math.floor((SimplexNoise.Noise2D(x*0.001, y * 0.1) + 1) * 16) % 16
          )

      return { 0, factor - y, factor, 255 }
    end
  )
  return self.map:addEntity(Plane({x = 0, y = 0, z = 4}, tiles, 'Water'))
end

function MapGenerator:newBeach(z, depth)
  local tiles = self:fillTiles(1, 1, self.map.width, depth,
    function(x,y)
      local color_offset = math.floor((self.map.height/4-y)*5)
      return
        {240 - color_offset,
         200 - color_offset,
         190 + math.floor((SimplexNoise.Noise2D(x*0.1, y*0.1) + 1) * 80) % 40 - color_offset,
         255 }
    end
  )
  return self.map:addEntity(Plane({x = 0, y = 0, z = z}, tiles, 'Beach'))
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
