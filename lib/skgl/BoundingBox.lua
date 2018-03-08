--[[@meta]]
BoundingBox = {
	__index = BoundingBox,
	__name = "BoundingBox"
}

function BoundingBox:new(width, height)
  --[[@meta]]
  local this = {
    type = "BoundingBox",
    class = BoundingBox
  }

	this.x       = 0
	this.y       = 0
	this._x      = 0 -- (x:sync)
	this._y      = 0 -- (y:sync)
	this.width   = width  or 0
	this.height  = height or 0

  --[[
   - Checagem de colisão entre dois retângulos.
   - @param {BoundingBox} collider Colisor.
   - @return {boolean} Retorna o resultado da colisão.
  --]]
  function this:intersect(collider)
  	return (
  		self._x < collider._x + collider.width  and
  		self._x + self.width > collider._x      and
  		self._y < collider._y + collider.height and
  		self.height + self._y > collider._y
  	)
  end

	--[[
	- Sincroniza o posicionamento relativo ao parente.
	--]]
	function this:syncWith(parent)
		self._x = self.x + parent._x
		self._y = self.y + parent._y
	end

  return this
end
