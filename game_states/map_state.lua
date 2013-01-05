
require 'level'
require 'map'
require 'generators/map_generator'
require 'views/map_view'

require 'entities/entity'
require 'entities/beach'

MapState = class("MapState", GameState)
function MapState:initialize()
  self.level = Level(1, 1)
  self.view = MapView(self, self.level.map)
  self.view.map = self.level.map
end

function MapState:draw()
  self.view:draw()
end

