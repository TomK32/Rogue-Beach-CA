
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
  self:setInputs(Player.input_alternatives['wasd'])
  self:setInputs(Player.input_alternatives['arrows'])
end

function Player:draw()
  game.renderer:print('@', {255,0,0,255}, self.position.x, self.position.y)
  game.renderer:print('|', {255,100,0,255}, self.position.x + 1, self.position.y - 1)
  game.renderer:print('|', {255,100,0,255}, self.position.x + 1, self.position.y)
  game.renderer:print('|', {255,100,0,255}, self.position.x + 1, self.position.y + 1)
end
function Player:setInputs(inputs)
  for direction, key in pairs(inputs.keyboard) do
    self.inputs[key] = Player.movements[direction]
  end
end


