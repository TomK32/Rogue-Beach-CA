

Plane = class("Plane", Entity)
function Plane:initialize(position, tiles, _type)
  Entity.initialize(self, {position = position, _type = _type})
  self.tiles = tiles
  self.position.width = #self.tiles
  self.position.height = #self.tiles[1]
end

function Plane:draw()
  game.renderer:translate(self.position.x, self.position.y)
  for x, row in ipairs(self.tiles) do
    for y, tile in ipairs(row) do
      if tile then
        self:drawTile(x, y, tile)
      end
    end
  end
end

function Plane:drawTile(x, y, tile)
  game.renderer:rectangle('fill', tile, x-1, y-1)
end

function Plane:update(dt)
end

