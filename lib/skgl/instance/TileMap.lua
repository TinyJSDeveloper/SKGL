--[[@meta]]
TileMap = {
	__index = TileMap,
	__name = "TileMap"
}

function TileMap:new(width, height)
  --[[@meta / @extends Sprite]]
  local this = Sprite:new(width, height)
        this.type = "TileMap"
        this.class = TileMap

	this.mapData = nil
	this.bounds  = nil

	--[[
	- Carrega um tileset.
	- @param {number{number{}}} mapData Mapa de tiles (array 2D numérica).
	--]]
	function this:loadData(mapData)
		self.mapData = mapData
	end

	--[[
	- Desenha um tile na tela.
	- @param {number} x Posição X de desenho.
	- @param {number} y Posição Y de desenho.
	- @param {number} tile Tile (deve existir no mapa de frames).
	--]]
	function this:drawTile(x, y, tile)
		if self.imageAtlas[tile] != nil then
			Surface.drawImagePartExtended(self.image,
				x,
				y,
				self.imageAtlas[tile].x,
				self.imageAtlas[tile].y,
				self.width,
				self.height,
				self.opacity
			)
		end
	end

  --[[
  - @override Desenha a instância na tela.
  --]]
  function this:draw()
		-- @todo Adaptar o backgroundColor (é necessário calcular o tamanho do mapa).
		--[[
		if self.backgroundColor != nil then
			Surface.drawFillRect(self._x, self._y, self.mapWidth, self.mapHeight, self.backgroundColor, self.opacity)
		end
		]]

		if self.image != nil then
			-- Criar um mapa de sprites, caso não exista:
			if self.imageAtlas == nil then
				self.imageAtlas = self:createImageAtlas()
			end

			-- Ajustar o nível de opacidade atual, caso necessário:
			if self.opacity < 0.0 then
				self.opacity = 0
			elseif self.opacity > 1.0 then
				self.opacity = 1
			end

			if self.mapData != nil then
				-- Linhas...
				for row in pairs(self.mapData) do
					-- Colunas...
					for col in pairs(self.mapData[row]) do
						-- Desenhar na tela:
						this:drawTile(
							self._x + ((col - 1) * self.width),
							self._y + ((row - 1) * self.height),
							self.mapData[row][col]
						)
					end
				end
			end

		end
  end

  return this
end
