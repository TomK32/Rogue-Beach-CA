

Plane = class("Plane", Entity)
function Plane:initialize(position, tiles, _type)
  if _type then
    self._type = _type
  end
  self.position = position
  self.tiles = tiles
  self.position.width = #self.tiles
  self.position.height = #self.tiles[1]
end

function Plane:draw()
  love.graphics.push()
  for x, row in pairs(self.tiles) do
    for y, tile in pairs(row) do
      self:drawTile(x, y, tile)
    end
  end
  love.graphics.pop()
end

function Plane:drawTile(x, y, tile)
  game.renderer:rectangle('fill', tile, x-1, y-1)
end

function Plane:update(dt)
end

