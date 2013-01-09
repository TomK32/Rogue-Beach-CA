Level = class("Level")

function Level:initialize(level, seed)
  self.level = level
  self.seed = seed
  self.dt = 0

  self.seed = self.seed + self.level


  self.generator = MapGenerator(self.seed)
  self.map = Map(48,36, self.generator)

end

function Level:update(dt)
  self.dt = self.dt + dt
  for layer, entities in pairs(self.map.layers) do
    for i, entity in pairs(entities) do
      entity:update(dt)
      if entity.dead == true then
        print("Removing", entity.position.y)
        table.remove(self.map.layers[layer], i)
      end
    end
  end
  self.generator:update(dt)
end


