Level = class("Level")

function Level:initialize(level, seed)
  self.level = level
  self.seed = seed
  self.dt = 0

  self.seed = self.seed + self.level


  self.map = Map(40,30, MapGenerator(self.seed))

end

function Level:update(dt)
  self.dt = self.dt + dt
end


