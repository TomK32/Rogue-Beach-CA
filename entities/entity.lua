
Entity = class("Entity")
Entity.map = nil

function Entity:initialize(options)
  for k, v in pairs(options) do
    self[k] = v
  end
  if not self.position then
    self.position = {x = 1, y = 1, z = 1}
  end
end

function Entity:draw()
end

function Entity:update(dt)
end

