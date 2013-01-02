--
-- Rogue Beach, CA
-- 
--   A roguelike surfing game.
--
-- (C) 2012-2013 Thomas R. Koll

require 'lib/middleclass'
require 'game'
require 'views/view'
require 'game_states/game_state'
require 'game_states/start_menu'

function love.load()
  game:createFonts(0)
  game.current_state = StartMenu()
end

function love.draw()
  if not game.current_state then return end
  game.current_state:draw()
end

function love.keypressed(key)
  if not game.current_state then return end
  game.current_state:keypressed(key)
end

function love.update(dt)
  if not game.current_state then return end
  game.current_state:update(dt)
end


