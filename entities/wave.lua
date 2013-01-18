
Wave = class("Wave", Plane)
function Wave:initialize(position, tiles, beach_y)
  Plane.initialize(self, position, tiles, 'Wave')
  self.dt = 0
  self.speed = position.speed
  self.beach_y = beach_y
  self.dead = false
  self.direction = {x = 0, y = 1}
  self.sprawl = false -- countdown for when waves hit the beach
  return self
end

function Wave:draw()
  love.graphics.push()
  game.renderer:translate(self.position.x, self.position.y)
  local w = 0
  local t = 205
  for x, row in pairs(self.tiles) do
    for y, c in pairs(row) do
      w = 0
      t = 205
      if self.sprawl and self.position.y - (self.position.height - y) < self.beach_y then
        w = 255
        c = 0
        -- TOOD: Seed this
        t = 223 + math.floor(math.random() * 32)
      end
      game.renderer:rectangle('fill', {w, 255-c,255-c, t}, x-1, y-1)
      game.renderer:print('~', {200, 200, 255-c, t}, x-1, y-1)
    end
  end
  love.graphics.pop()
end


function Wave:update(dt)
  self.position.y = self.position.y - dt * self.speed
  if self.position.y < self.beach_y then
    self.dead = true
  elseif not self.sprawl and (self.position.y - self.position.height * 2) < self.beach_y then
    print("Sprawl")
    self.sprawl = true
    -- hitting the beach, change colour
  end
end
