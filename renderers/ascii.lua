
-- Handles how things are being draw. tiles, colours, text
--

local AsciiRenderer = class("AsciiRenderer")
AsciiRenderer.map_view = nil

function AsciiRenderer:translate(x, y)
  love.graphics.translate(self:scaledXY(x,y))
end
function AsciiRenderer:rectangle(style, color, x, y, tiles_x, tiles_y)
  if not self.map_view then return end
  love.graphics.setColor(unpack(color))
  love.graphics.rectangle(style,
      self:scaledX(x), self:scaledY(y),
      (tiles_x or 1) * self.map_view.scale.x, (tiles_y or 1) * self.map_view.scale.y
  )
end

function AsciiRenderer:print(text, color, x, y)
  love.graphics.setColor(unpack(color))
  love.graphics.print(text, self:scaledXY(x, y))
end
function AsciiRenderer:rotate(angle)
  love.graphics.rotate(angle)
end

function AsciiRenderer:scaledXY(x, y)
  return self:scaledX(x), self:scaledY(y)
end
function AsciiRenderer:scaledX(x)
  return x * self.map_view.scale.x
end
function AsciiRenderer:scaledY(y)
  return - y * self.map_view.scale.y
end
return AsciiRenderer

