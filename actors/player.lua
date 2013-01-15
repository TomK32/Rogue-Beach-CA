
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
  game.renderer:print('@', {255,0,0,255}, 0, 0)
  for i, tile in pairs(self.board) do
    game.renderer:print(tile.c, {255,100,0,255}, tile.x, tile.y)
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
  if self.state == 'standing' then
    self.speed_factor = 25
  elseif self.state == 'paddling' then
    self.speed_factor = 10
  else
    self.speed_factor = 3
  end
  Actor.update(self, dt)
end

-- if standing (i.e on the beach, cut the speed so it becomes proper
function Player:positionUpdated()
  if self.state == 'standing' then
    self.speed = self.speed / 2
  elseif self.state == 'paddling' then
    self.speed = self.speed/3*2
  end
end

function Player:switchState()
  print(self.map:surface(self.position))
  if self.state == 'standing' then
    if self.map:surface(self.position) == 'Water' then
      self.state = 'paddling'
    end
  elseif self.state == 'paddling' then
    self.state = 'surfing'
  elseif self.state == 'surfing' then
    if self.map:surface(self.position) == 'Water' then
      self.state = 'paddling'
    else
      self.state = 'standing'
    end
  end

  self:setBoard()
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
