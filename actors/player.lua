
Player = class("Player", Actor)
Player.input_alternatives = {
  arrows = {
    keyboard = {
      speedUp = 'up',
      speedDown = 'down',
      turnLeft = 'left',
      turnRight = 'right',
      switchState = ' '
    }
  },
  wasd = {
    keyboard = {
      speedUp = 'w',
      speedDown = 's',
      turnLeft = 'a',
      turnRight = 'd',
      switchState = ' '
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

function Player:update(dt)
  game.ticked = self.moved
  if self.state == 'standing' then
    self.speed_factor = 30
  elseif self.state == 'paddling' then
    self.speed_factor = 10
  else
    self.speed_factor = 1
  end
  for i, wave in ipairs(self.map:waves(self.position)) do
    if wave.direction.x ~= 0 then
      self.position.x = self.position.x - wave.direction.x * dt * wave.speed / 4
    end
    if wave.direction.y ~= 0 then
      self.position.y = self.position.y - wave.direction.y * dt * wave.speed / 4
    end
  end
  Actor.update(self, dt)
end

-- if standing (i.e on the beach, cut the speed so it becomes proper
function Player:positionUpdated(dt)
  self.speed = math.max(0, self.speed - self.speed_factor * dt)
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
