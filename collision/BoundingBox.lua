--[[@meta]]
BoundingBox = {
  name = "BoundingBox"
}

function BoundingBox.new(width, height)
  --[[@meta]]
  local _self = {
    class = BoundingBox
  }

  -- Posição X.
  _self.x = 0

  -- Posição Y.
  _self.y = 0

  -- Posição X relativa à original (offset).
  _self.offsetX = 0

  -- Posição Y relativa à original (offset).
  _self.offsetY = 0

  -- Largura.
  _self.width = width or 0

  -- Altura.
  _self.height = height or 0

  --[[
   - Checagem de colisão entre dois retângulos.
   -
   - @param {BoundingBox} collider Colisor.
   - @return {boolean} Retorna o resultado da colisão.
  --]]
  function _self:intersect(collider)
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
  function _self:adjustOffset(sprite)
    self.offsetX = (self.x + sprite.offsetX)
    self.offsetY = (self.y + sprite.offsetY)
  end

  return _self
end
