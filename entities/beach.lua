
Beach = class("Beach", Entity)
function Beach:initialize(position, tiles)
  self.position = position
  self.tiles = tiles
end

function Beach:draw()
  for x = 1, #self.tiles do
    for y = 1, #self.tiles[x] do
      c = self.tiles[x][y]
      print(c)
      self.map.view.rectangle('fill', {255, 255, c, 255}, x, y)
      self.map.view.print('.', {255, 255, 200, 240}, x, y)
    end
  end
end
