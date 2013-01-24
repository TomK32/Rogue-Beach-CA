
Wave = class("Wave", Plane)
function Wave:initialize(position, direction, tiles, beach_y)
  Plane.initialize(self, position, tiles, 'Wave')
  self.dt = 0
  self.speed = position.speed
  self.beach_y = beach_y
  self.dead = false
  self.direction = direction
  self.sprawl = false -- countdown for when waves hit the beach
  self:updateColors(0.1)
  return self
end

function Wave:draw()
  if not self.colors then return end
  love.graphics.push()
  game.renderer:translate(self.position.x, self.position.y)
  for x, row in pairs(self.colors) do
    for y, cell in pairs(row) do
      love.graphics.push()
      game.renderer:translate(x, y)
      if cell.offset_y ~= 0 then
        love.graphics.scale(cell.offset_x, cell.offset_x)
        love.graphics.rotate(cell.offset_x, cell.offset_y)
      end
      game.renderer:rectangle('fill', {cell.w, 255-cell.c,255-cell.c, 255}, cell.offset_x, cell.offset_y)
      game.renderer:print('~', {200, 200, 255-cell.c, cell.t}, cell.offset_x, cell.offset_y)
      love.graphics.pop()
    end
  end
  love.graphics.pop()
end

function Wave:updateColors(dt)
  local rand = SimplexNoise.Noise2D(dt, self.dt) * 100
  local w = 0
  local t = 205
  local new_colors = {}
  local offset_x = 0
  local offset_y = 0
  for x, row in pairs(self.tiles) do
    new_colors[x] = {}
    for y, c in pairs(row) do
      w = 0
      t = 205
      offset_x, offset_y = 0, 0
      if self.sprawl and self.position.y - (self.position.height - y) < self.beach_y then
        w = 205 + (rand % 50)
        c = math.floor(((SimplexNoise.Noise2D(rand + x, y) * 16) % 16) + 1)
        t = 230 + c
        offset_x = - c / 12
        offset_y = - c / 11
      end
      new_colors[x][y] = {
        w= w, c= c, t= t, offset_x= offset_x, offset_y= offset_y
      }
    end
  end
  self.colors = new_colors
end

function Wave:update(dt)
  self.dt = self.dt + dt
  self.position.y = self.position.y - self.direction.y * dt * self.speed
  self.position.x = self.position.x - self.direction.x * dt * self.speed
  if self.position.y < self.beach_y then
    self.dead = true
  elseif not self.sprawl and (self.position.y - self.position.height * 2) < self.beach_y then
    print("Sprawl")
    self.sprawl = true
    -- hitting the beach, change colour
  end
  if self.sprawl then
    self:updateColors(dt)
  end
end
