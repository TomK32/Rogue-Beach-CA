
require 'level'
require 'map'
require 'generators/map_generator'
require 'views/map_view'

require 'actors/actor'
require 'actors/player'

require 'entities/entity'
require 'entities/plane'
require 'entities/wave'

MapState = class("MapState", GameState)
function MapState:initialize()
  self.realtime = true
  self.level = Level(1, math.floor(math.random() * 10))
  self.view = MapView(self.level.map)
  game.renderer.map_view = self.view
  self.view:update()
end

function MapState:draw()
  self.view:draw()

  love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)
end

function MapState:update(dt)
  if self.level.player:update(dt) or self.realtime then
    self.level:update(dt)
    self.view:update()
  end
end
