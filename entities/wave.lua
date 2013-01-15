
Wave = class("Wave", Entity)
function Wave:initialize(position, tiles)
  self.position = position
  self.tiles = tiles
  self.dt = 0
  self.speed = position.speed
  self.dead = false
  self.direction = {x = 0, y = 1}
end

function Wave:draw()
  love.graphics.push()
  game.renderer:translate(self.position.x, self.position.y)
  for x, row in pairs(self.tiles) do
    for y, c in pairs(row) do
      game.renderer:rectangle('fill', {0, 0, 255-c, 105}, x-1, y-1)
      game.renderer:print('~', {2200, 200, 255-c, 255}, x-1, y-1)
    end
  end
  love.graphics.pop()
end


function Wave:update(dt)
  self.dead = false
  self.position.y = self.position.y - dt * self.speed
  if self.position.y < 1 then self.dead = true end
end
