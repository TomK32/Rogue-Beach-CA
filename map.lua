-- As the map is going to be large (I'm thinking 1000x200 meters),
-- only sparsely populated, and changing quite often (waves),
-- a tiled map doesn't make that much sense.
-- Instead the map will manage only entities.
-- For a future optimization the map might be split up into smaller maps

-- Entities are arranged in layers, each of which the map view has to draw
-- Entities are expected to have a position with x, y and z (layer)
-- and update and draw functions

Map = class("Map")
function Map:initialize(width, height)
  self.width = width
  self.height = height
  self.layers = {} -- here the entities are stuffed into
  self.map = {}
end

function Map:place(entity)
  entity.map = self
  if not self.layers[entity.position.z] then
    self.layers[entity.position.z] = {}
  end
  table.insert(self.layers[entity.position.z], entity)
end

-- The map is wrapped, meaning if something leaves on one side it
-- reappears on the opposing side
function Map:fitIntoMap(position)
  if position.x < 0 then
    position.x = self.width
  elseif position.x > self.width then
    position.x = 0
  end
  if position.y < 0 then
    position.y = self.height
  elseif position.y > self.height then
    position.y = 0
  end
  return position
end

