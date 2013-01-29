
Player = class("Player", Actor)
Player.input_alternatives = {
  arrows = {
    keyboard = {
      speedUp = 'up',
      speedDown = 'down',
      turnLeft = 'left',
      turnRight = 'right',
      switchState = ' ',
      waitForWave = 'z'
    }
  },
  wasd = {
    keyboard = {
      speedUp = 'w',
      speedDown = 's',
      turnLeft = 'a',
      turnRight = 'd',
      switchState = ' ',
      waitForWave = 'z'
    }
  }
}
Player.movements = {
  up    = { x = 0, y = - 1 },
  down  = { x = 0, y =   1 },
}

function Player:initialize(position)
  Actor.initialize(self)
  self.position = position or {x = 1, y = 1}
  self.direction = nil
  self.dt_since_input = 0
  self.entity_type = 'Actor'
  self.inputs = {}
  self.state = 'standing'
  self.had_wave = false
  self.wait_for_wave = false
  self:setBoard()
  self:setInputs(Player.input_alternatives['wasd'])
  self:setInputs(Player.input_alternatives['arrows'])

  self.current_wave = 0
  self.score = 0

  self.accelleration = {
    standing = 2,
    paddling = 0.5,
    surfing = 0
  }
  self.max_speed = {
    standing = 2,
    paddling = 1,
    surfing = 6
  }
  self.drag = { -- how much the player is slowed down, 1 is a full halt
    standing = 1,
    paddling = 0.2,
    surfing = 0.1
  }
end

function Player:draw()
  local board = {}
  game.renderer:translate(self.position.x, self.position.y)
  game.renderer:rotate(-self.orientation - math.pi * 0.5)
  game.renderer:print('@', {0,0,0,255}, 0, 0)
  game.renderer:print('@', {255,200,50,255}, 0.1, 0.1)
  for i, tile in pairs(self.board) do
    game.renderer:print(tile.c, {0,0,0,255}, tile.x+0.1, tile.y+0.1)
    game.renderer:print(tile.c, {255,200,50,255}, tile.x, tile.y)
  end
end

function Player:setInputs(inputs)
  for direction, key in pairs(inputs.keyboard) do
    if Player.movements[direction] then
      self.inputs[key] = Player.movements[direction]
    elseif type(self[direction]) == 'function' then
      self.inputs[key] = self[direction]
    end
  end
end

function Player:maxSpeed()
  return self.max_speed[self.state]
end

function Actor:accellerationUp()
  return self.accelleration[self.state]
end
function Actor:accellerationDown()
  if self.state == 'surfing' then
    return - self.speed / 2 -- break hard
  else
    return - self.accelleration[self.state] * 0.75
  end
end

function Player:waitForWave()
  self.wait_for_wave = true
  self.moved = false
end

function Player:update(dt)
  self.moved = false
  local surface = self.map:surface(self.position)
  if (surface == 'Water' and self.state == 'standing') or (surface == 'Beach' and self.state ~= 'standing') then
    self:switchState()
    self:setBoard()
  end

  Actor.update(self, dt)

  if not self.moved and not self.wait_for_wave then
    return false
  end
  if self.moved then self.wait_for_wave = false end
  game.ticked = self.moved or self.wait_for_wave
  self:speedChange(self.speed * - self.drag[self.state], 0, self:maxSpeed(self.state))
  self.had_wave = false
  for i, wave in ipairs(self.map:waves(self.position)) do
    self.had_wave = true
    self.wait_for_wave = false
    if self.state == 'paddling' then
      --self:speedChange(- (wave.speed * dt) / 16, self.speed / 2, wave.speed)
    elseif self.state == 'surfing' and self.moved then
      self.current_wave = self.current_wave + dt * 100
      self.score = self.score + self.current_wave
      -- speed up 
      self:speedChange(
          math.min(
                self.drag['surfing'] * math.abs(wave.speed - self.speed),
                (wave.speed - self.speed)/2)
            ,
        self.speed, wave.speed * (1 - self.drag['surfing']))
      local direction = 1
      if self.orientation - wave.orientation < math.pi then
        direction = -1
      end
      self:turn(direction * math.max(-0.2, math.min(0.2, math.abs(self.orientation - wave.orientation) / 2)))
    end
    self.position.x = self.position.x - (math.cos(wave.orientation) * dt * (wave.speed + self.speed)/4 * (1 - self.drag[self.state]))
    self.position.y = self.position.y - (math.sin(wave.orientation) * dt * (wave.speed + self.speed)/4 * (1 - self.drag[self.state]))
  end
  if not self.had_wave then
    self.current_wave = 0
    if self.state == 'surfing' then
      self.state = 'paddling'
      self:setBoard()
    end
  end
end

function Player:switchState()
  local previousState = self.state
  surface = self.map:surface(self.position)
  if surface == 'Beach' and self.state ~= 'standing' then
    self.state = 'standing'
    game.realtime = true
  end

  if surface == 'Water' then
    game.realtime = false
    if self.state == 'standing' then
      self.state = 'paddling'
    elseif self.state == 'paddling' then
      self.state = 'surfing'
    elseif self.state == 'surfing' then
      self.state = 'paddling'
    end
  end

  self:setBoard()
  if self.state ~= previousState then
    self.moved = true
  end
  return self.state ~= previousState
end

function Player:setBoard()

  if self.state == 'standing' then
    self.board = {
      {x = 1, y = -1, c = '|'},
      {x = 1, y = 0, c = '|'},
      {x = 1, y = 1, c = '|'}
    }
  elseif self.state == 'paddling' then
    self.board = {
      {x = 0.2, y = -1, c = '▌'},
      {x = -0.4, y = 0, c = '/'},
      {x = 0.8, y = 0, c = '\\'},
      {x = 0.2, y = 1, c = '^'}
    }
  elseif self.state == 'surfing' then
    self.board = {
      {x = 0.2, y = -1, c = '▌'},
      {x = 0.2, y = 1, c = '^'}
    }
  else
    error(1, 'player state invalid')
  end
end
