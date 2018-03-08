--[[@meta]]
TiledSprite = {
	__index = TiledSprite,
	__name = "TiledSprite"
}

function TiledSprite:new(width, height)
  --[[@meta / @extends TileMap]]
  local this = TileMap:new(width, height)
        this.type = "TiledSprite"
        this.class = TiledSprite

	this.mapWidth  = 0
	this.mapHeight = 0

	--[[
	- Define as dimensões do mapa de tiles.
	- @param {number} mapWidth Largura.
	- @param {number} mapHeight Altura.
	--]]
	function this:setMapSize(mapWidth, mapHeight)
		self.mapWidth = mapWidth or 0
		self.mapHeight = mapHeight or 0
	end

	--[[
	- Desenha uma linha de tiles, sendo que o último da coluna pode ser cortado.
	- @param {number} wc Contador de largura.
	- @param {number} hc Contador de altura.
	- @param {number} wt Largura original dos tiles.
	- @param {number} ht Altura original dos tiles.
	--]]
	function this:drawRow(wc, hc, wt, ht)
		while wc < self.mapWidth do

			-- Desenhar tiles de forma ordenada...
			if (wc + self.width) < self.mapWidth then
				self:drawTile(
					self._x + wc,
					self._y + hc,
					self.frames[self.frame]
				)

				wc += self.width

			-- Desenhar o pedaço restante do último tile...
			else
				self.width = self.mapWidth - wc

				self:drawTile(
					self._x + wc,
					self._y + hc,
					self.frames[self.frame]
				)

				break
			end
		end

		-- Restaurar tamanho original dos tiles:
		self.width  = wt
		self.height = ht
	end

	--[[
  - @override Desenha a instância na tela.
  --]]
  function this:draw()
		if self.backgroundColor != nil then
			Surface.drawFillRect(self._x, self._y, self.width, self.height, self.backgroundColor, self.opacity)
		end

		if self.image != nil then
			-- Criar um mapa de sprites, caso não exista:
			if self.imageAtlas == nil then
				self.imageAtlas = self:createImageAtlas()
			end

			-- Ajustar o índice do frame atual, caso necessário:
			if self.frames[self.frame] == nil then
				self.frame = 1
			end

			-- Ajustar o nível de opacidade atual, caso necessário:
			if self.opacity < 0.0 then
				self.opacity = 0
			elseif self.opacity > 1.0 then
				self.opacity = 1
			end

			-- Contadores de tamanho:
			local wc = 0
			local hc = 0

			-- Guardar tamanho original dos tiles (eles serão restaurados depois):
			local wt = self.width
			local ht = self.height

			while hc < self.mapHeight do
				-- Desenhar tiles de forma ordenada...
				if (hc + self.height) < self.mapHeight then
					self:drawRow(wc, hc, wt, ht)
					hc += self.height

				-- Desenhar o pedaço restante do último tile...
				else
					self.height = self.mapHeight - hc
					self:drawRow(wc, hc, wt, ht)
					break
				end
			end

			-- Restaurar tamanho original dos tiles:
			self.width = wt
			self.height = ht

			self.frame += 1
		end
  end

  return this
end
