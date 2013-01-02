
GameState = class("GameState")
function GameState:initialize(game, name)
  self.name = name
  self.game = game
end

function GameState:update(dt)
end

function GameState:draw()
end

function GameState:keypressed(key)
end
