--
-- Rogue Beach, CA
-- 
--   A roguelike surfing game.
--
-- (C) 2012-2013 Thomas R. Koll

require 'lib/middleclass'

game = {
  graphics = {
    fullscreen = false,
    mode = { height = love.graphics.getHeight(), width = love.graphics.getWidth() }
  },
  fonts = {},
}

function game.createFonts(offset)
  return {
    lineHeight = (10 + offset) * 1.7,
    small = love.graphics.newFont(10 + offset),
    regular = love.graphics.newFont(14 + offset),
    large = love.graphics.newFont(24 + offset),
    very_large = love.graphics.newFont(48 + offset)
  }
end

function love.load()
  game.fonts = game.createFonts(0)
end

function love.draw()

end


function love.keypressed(key)
end

function love.update(dt)

end


