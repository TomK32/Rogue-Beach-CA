
require 'level'
require 'map'
require 'generators/map_generator'
require 'views/map_view'

require 'entities/entity'
require 'entities/plane'
require 'entities/wave'

MapState = class("MapState", GameState)
function MapState:initialize()
  self.level = Level(1, math.floor(math.random() * 10))
  self.view = MapView(self.level.map)
  game.renderer.map_view = self.view
  self.view:update()
  self.view.map = self.level.map
end

function MapState:draw()
  self.view:draw()

  love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)
end

function MapState:update(dt)
  self.level:update(dt)
  self.view:update()
end
