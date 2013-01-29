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
  local dt_change = false
  if self.dt_since_input > self.dt_between_step then
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        if type(m) == 'function' then
          if self.dt_since_input > 0.5 then
            dt_change = true
            m(self, key)
          end
        end
      end
    end
  end
  if dt_change then
    self.dt_since_input = 0
  end
  self.dt_since_input = self.dt_since_input + dt
end

function Actor:tick()
  self.moved = true
end

function Actor:maxSpeed()
  return self.max_speed
end

function Actor:speedUp()
  self:speedChange(self:accellerationUp())
end

function Actor:speedDown()
  self:speedChange(self:accellerationDown())
end

function Actor:accellerationUp()
  return 1
end
function Actor:accellerationDown()
  return -1
end

function Actor:speedChange(val, min, max)
  self.moved = true
  self.speed = self.speed + val
  if self.speed > self:maxSpeed() then
    self.speed = self:maxSpeed()
  elseif self.speed < - self:maxSpeed() / 2 then
    self.speed = - self:maxSpeed() / 2
  end
  if min and self.speed < min then
    self.speed = min
  end
  if max and self.speed > max then
    self.max = max
  end
end

function Actor:turnLeft()
  self:turn(math.pi / 8)
end

function Actor:turnRight()
  self:turn(- math.pi / 8)
end

function Actor:turn(direction)
  self.moved = true
  if not self.turns then self.turns = {} end
  table.insert(self.turns, direction)
  self.orientation = (self.orientation + direction) % (2 * math.pi)
end


function Actor:update(dt)
  self:keydown(dt)
  if not self.moved then
    return false
  end

  local old_position = {x = self.position.x, y = self.position.y}
  self.position.x = self.position.x - math.cos(self.orientation) * self.speed * dt * self.speed_factor
  self.position.y = self.position.y - math.sin(self.orientation) * self.speed * dt * self.speed_factor

  self.map:fitIntoMap(self.position)

end

