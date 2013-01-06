
Beach = class("Beach", Entity)
function Beach:initialize(position, tiles)
  self.position = position
  self.tiles = tiles
end

function Beach:draw()
  love.graphics.push()
  for x, row in pairs(self.tiles) do
    for y, c in pairs(row) do
      game.renderer:rectangle('fill', {255, 255, c, 255}, x-1, y-1)
      game.renderer:print('.', {55, 55, 0, 240}, x-1, y-1)
    end
  end
  love.graphics.pop()
end

function Beach:update()
end
