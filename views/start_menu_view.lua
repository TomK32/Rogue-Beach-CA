
gui = require 'lib/quickie'

StartMenuView = class("MenuView", View)

gui.core.style.color.normal.bg = {80,180,80}

function StartMenuView:drawContent()
  love.graphics.setFont(game.fonts.regular)
  gui.core.draw()
  local x = 250
  local y = 50
  if game.graphics.mode.width < 800 then
    x = 130
    y = 20
  end

  love.graphics.scale(1.8,1.8)
  love.graphics.setColor(255,255,255,200)
  love.graphics.print('Rogue Beach, CA', x, y)
  love.graphics.setColor(255,200, 10, 255)
  love.graphics.print('Rogue Beach, CA', x-1, y-1)
end

function StartMenuView:update(dt)
  local x = 100
  local y = 50
  if game.graphics.mode.width < 800 then
    x = 10
    y = 20
  end

  gui.group.push({grow = "down", pos = {x, y}})
  -- start the game
  if gui.Button({text = '[N]ew game'}) then
    game:start()
  end
  gui.group.push({grow = "down", pos = {0, 20}})

  -- fullscreen toggle
  if game.graphics.mode.fullscreen then
    text = 'Windowed'
  else
    text = 'Fullscreen'
  end
  if gui.Button({text = text}) then
    game.graphics.fullscreen = not game.graphics.fullscreen
    love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), game.graphics.fullscreen)
  end

end
