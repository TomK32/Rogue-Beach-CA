
Wave = class("Wave", Entity)
function Wave:initialize(position, tiles)
  self.position = position
  self.tiles = tiles
  self.dt = 0
  self.dead = false
end

function Wave:draw()
  love.graphics.push()
  game.renderer:translate(self.position.x, self.position.y)
  for x, row in pairs(self.tiles) do
    for y, c in pairs(row) do
      game.renderer:rectangle('fill', {0, 0, 255-c, 155}, x-1, y-1)
      game.renderer:print('~', {2200, 200, 255-c, 255}, x-1, y-1)
    end
  end
  love.graphics.pop()
end


function Wave:update(dt)
  self.dead = false
  self.dt = self.dt + dt * 3
  if self.dt > 1 then
    local new_tiles = {}
    self.dt = 0
    self.position.y = self.position.y - 1
    if self.position.y < 1 then
      self.position.y = 1
      table.remove(self.tiles, 0)
    end
    for x, row in pairs(self.tiles) do
      new_tiles[x] = {}
      -- remove wave if it is very small
      for y, c in pairs(row) do
        new_tiles[x][y-1] = c
      end
    end
    if self.position.y == 2 then self.dead = true end
    self.tiles = new_tiles
  end
end
