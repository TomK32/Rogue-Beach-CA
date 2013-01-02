
require 'map'
require 'views/map_view'

MapState = class("MapState", GameState)
function MapState:initialize()
  self.map = Map(200, 200)
  self.view = MapView(self, map)
end

function MapState:draw()
  self.view:draw()
end

