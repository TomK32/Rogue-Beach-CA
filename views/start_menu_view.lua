
gui = require 'lib/quickie'

StartMenuView = class("MenuView", View)

gui.core.style.color.normal.bg = {80,180,80}

function StartMenuView:draw()
  gui.core.draw()
  local x = 250
  local y = 50
  if game.graphics.mode.width < 800 then
    x = 130
    y = 20
  end

  love.graphics.push()
  love.graphics.setFont(game.fonts.regular)
  love.graphics.scale(1.8,1.8)
  love.graphics.setColor(255,255,255,200)
  love.graphics.print('Rogue Beach, CA', x, y)
  love.graphics.setColor(255,200, 10, 255)
  love.graphics.print('Rogue Beach, CA', x-1, y-1)

  love.graphics.pop()
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
  if gui.Button({text = 'Start'}) then
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

  -- screen resolutions
  modes = love.graphics.getModes()
  table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end)   -- sort from smallest to largest
  for i, mode in ipairs(modes) do
    if gui.Button({text = mode.width .. 'x' .. mode.height}) then
      game:setMode(mode)
    end
  end
end
