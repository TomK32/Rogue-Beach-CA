
Player = class("Player", Actor)
Player.input_alternatives = {
  arrows = {
    keyboard = {
      speedUp = 'up',
      speedDown = 'down',
      turnLeft = 'left',
      turnRight = 'right',
      switchState = ' ',
      tick = 'z'
    }
  },
  wasd = {
    keyboard = {
      speedUp = 'w',
      speedDown = 's',
      turnLeft = 'a',
      turnRight = 'd',
      switchState = ' ',
      tick = 'z'
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
  self:setBoard()
  self:setInputs(Player.input_alternatives['wasd'])
  self:setInputs(Player.input_alternatives['arrows'])

  self.current_wave = 0
  self.score = 0

  self.accelleration = {
    standing = 1.5,
    paddling = 0.5,
    surfing = 0
  }
  self.max_speed = {
    standing = 4,
    paddling = 1,
    surfing = 8
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
  game.renderer:rotate(self.orientation + math.pi / 2)
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
  return - self.accelleration[self.state] / 2
end

function Player:update(dt)
  local surface = self.map:surface(self.position)
  if (surface == 'Water' and self.state == 'standing') or (surface == 'Beach' and self.state ~= 'standing') then
    self:switchState()
    self:setBoard()
  end

  game.ticked = self.moved
  if not Actor.update(self, dt) then
    return false
  end
  self:speedChange(self.speed * - self.drag[self.state], 0, self:maxSpeed(self.state))

  local had_wave = false
  for i, wave in ipairs(self.map:waves(self.position)) do
    had_wave = true
    if self.state == 'paddling' then
      --self:speedChange(- (wave.speed * dt) / 16, self.speed / 2, wave.speed)
    elseif self.state == 'surfing' and self.moved then
      self.current_wave = self.current_wave + dt * 100
      self.score = self.score + self.current_wave
      self:speedChange(math.sqrt(self.speed + wave.speed)/4, self.speed, wave.speed)
      self.orientation = (self.orientation + wave.orientation) / 2
    end
    self.position.x = self.position.x - (math.cos(wave.orientation) * dt * (wave.speed + self.speed)/4 * (1 - self.drag[self.state]))
    self.position.y = self.position.y - (math.sin(wave.orientation) * dt * (wave.speed + self.speed)/4 * (1 - self.drag[self.state]))
  end
  if not had_wave then
    self.current_wave = 0
    if self.state == 'surfing' then
      self.state = 'paddling'
      self:setBoard()
    end
  end
end

function Player:positionUpdated(dt)
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
      {x = 0, y = -1, c = '▌'},
      {x = -1, y = 0, c = '/'},
      {x = 1, y = 0, c = '\\'},
      {x = 0, y = 1, c = '▌'}
    }
  elseif self.state == 'surfing' then
    self.board = {
      {x = 0, y = -1, c = '▌'},
      {x = 0, y = 1, c = '▌'}
    }
  else
    error(1, 'player state invalid')
  end
end
