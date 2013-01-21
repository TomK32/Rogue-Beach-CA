Actor = class("Actor")

function Actor:initialize()
  self.turns = {}
  self.direction = 0
  self.orientation = math.pi/2
  self.speed = 0
  self.max_speed = 3
  self.speed_factor = 10
  self.dt_between_step = 0.01
end


function Actor:keydown(dt)
  if self.dt_since_input > self.dt_between_step then
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        if type(m) == 'function' then
          if self.dt_since_input > 0.5 then
            self.moved = self.moved or m(self, key)
            self.dt_since_input = 0
          end
        end
      end
    end
  end
  self.dt_since_input = self.dt_since_input + dt
end

function Actor:tick()
  return true
end

function Actor:speedUp()
  self:speedChange(1)
  return true
end

function Actor:speedDown()
  self:speedChange(-1)
  return true
end

function Actor:speedChange(val)
  self.speed = self.speed + val
  if self.speed > self.max_speed then
    self.speed = self.max_speed
  elseif self.speed < - self.max_speed / 2 then
    self.speed = - self.max_speed / 2
  end
end

function Actor:turnLeft()
  self:turn(- math.pi / 4)
  return true
end

function Actor:turnRight()
  self:turn(math.pi / 4)
  return true
end

function Actor:turn(direction)
  if not self.turns then self.turns = {} end
  table.insert(self.turns, direction)
  self.orientation = (self.orientation + direction) % (2 * math.pi)
end


function Actor:update(dt)
  self:keydown(dt)
  if not self.moved and self.speed == 0 then
    return false
  end

  local old_position = {x = self.position.x, y = self.position.y}
  self.position.x = self.position.x + math.cos(self.orientation) * self.speed * dt * self.speed_factor
  self.position.y = self.position.y + math.sin(self.orientation) * self.speed * dt * self.speed_factor

  self.map:fitIntoMap(self.position)

  self:positionUpdated(dt)
  return true
end

function Actor:positionUpdated()

end

