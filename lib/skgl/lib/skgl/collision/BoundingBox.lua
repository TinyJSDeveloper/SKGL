--[[@meta]]
BoundingBox = {
  name = "BoundingBox"
}

--[[
- @class BoundingBox
-
- @param {number} width Largura da caixa de colisão.
- @param {number} height Altura da caixa de colisão.
--]]
function BoundingBox.new(width, height)
  --[[@meta]]
  local def = {
    class = BoundingBox
  }

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Posição X.
    self.x = 0

    -- Posição Y.
    self.y = 0

    -- Posição X relativa à original (offset).
    self.offsetX = 0

    -- Posição Y relativa à original (offset).
    self.offsetY = 0

    -- Largura.
    self.width = width or 0

    -- Altura.
    self.height = height or 0
  end

  --[[
   - Checagem de colisão entre dois retângulos.
   -
   - @param {BoundingBox} collider Colisor.
   -
   - @return {boolean} Retorna o resultado da colisão.
  --]]
  function def:intersect(collider)
  	return (
  		self.offsetX < collider.offsetX + collider.width  and
  		self.offsetX + self.width > collider.offsetX      and
  		self.offsetY < collider.offsetY + collider.height and
  		self.height + self.offsetY > collider.offsetY
  	)
  end

  --[[
  - Ajusta o offset da caixa de colisão, sendo relativo a um sprite.
  -
  - @param {Sprite} sprite Sprite.
  --]]
  function def:adjustOffset(sprite)
    self.offsetX = (self.x + sprite.offsetX)
    self.offsetY = (self.y + sprite.offsetY)
  end

  def:__init__()
  return def
end
