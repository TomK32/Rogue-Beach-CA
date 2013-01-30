
Rock = class("Rock", Plane)

function Rock:drawTile(x, y, tile)
  game.renderer:print('x', {0,0,0,200}, x-1, y-1)
  game.renderer:rectangle('fill', tile, x-1, y-1)
end


