
Player = class("Player", Actor)
Player.input_alternatives = {
  arrows = {
    keyboard = {
      up = 'up',
      down = 'down',
      left = 'left',
      right = 'right',
    }
  },
  wasd = {
    keyboard = {
      up = 'w',
      down = 's',
      left = 'a',
      right = 'd',
    }
  }
}
Player.movements = {
  up    = { x = 0, y = - 1 },
  down  = { x = 0, y =   1 },
  left  = { x = - 1, y = 0 },
  right = { x =   1, y = 0 },
}

function Player:initialize(position)
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
  game.renderer:print('@', {255,0,0,255}, self.position.x, self.position.y)
  for i, tile in pairs(self.board) do
    game.renderer:print(tile.c, {255,100,0,255}, self.position.x + tile.x, self.position.y - tile.y)
  end
end

function Player:setInputs(inputs)
  for direction, key in pairs(inputs.keyboard) do
    self.inputs[key] = Player.movements[direction]
  end
end

function Player:switchState()
  if self.state == 'standing' then
    self.state = 'paddling'
  elseif self.state == 'padding' then
    self.state = 'surfing'
  else
    self.self = 'standing'
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
      {x = 0, y = -1, c = '▒'},
      {x = 0, y = 1, c = '▒'}
    }
  end
end
