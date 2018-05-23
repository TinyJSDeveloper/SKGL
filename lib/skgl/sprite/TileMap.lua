--[[@meta : @extends Sprite]]
TileMap = {
  name = "TileMap",
  extends = Sprite
}

function TileMap.new(width, height)
  --[[@meta : @extends Sprite]]
  local _self = Sprite.new(width, height)
  _self.class = TileMap

  -- Mapa de tiles.
  _self.tilemap = nil

  -- @private Valor máximo de linhas.
  _self._maxRows = 0

  -- @private Valor máximo de colunas.
  _self._maxCols = 0

  --[[
  - @override
  - Redimensiona a caixa de colisão de acordo com os atributos de altura e
  - largura do tileset.
  --]]
  function _self:resizeBounds()
    if self.bounds ~= nil and self.tilemap ~= nil then

      -- Valores máximos de linhas e colunas presentes no mapa de tiles:
      local maxRows = 0
      local maxCols = 0

      -- Percorrer linhas, contabilizando cada uma delas...
      for row in pairs(self.tilemap) do
        maxRows = (maxRows + 1)

        -- Contador de colunas desta linha:
        local cols = 0

        -- Percorrer colunas, contabilizando cada uma delas...
        for col in pairs(self.tilemap[row]) do
          cols = (cols + 1)
        end

        -- Guardar o valor máximo de colunas, caso tenha sido atingido:
        if cols > maxCols then
          maxCols = cols
        end
      end

      -- As dimensões da caixa de colisão são determinadas pelo total de linhas
      -- e pela linha com o maior número de colunas:
      self.bounds.width = maxCols * self.width
      self.bounds.height = maxRows * self.height

      -- Guardar o valor máximo de linhas e colunas para uso futuro:
      self._maxRows = maxRows
      self._maxCols = maxCols
    end
  end

  --[[
  - Define um mapa de tiles usado pelo tileset.
  -
  - @param {Array(number[])} Mapa de tiles a ser usado pelo tileset.
  --]]
  function _self:setTilemap(tilemap)
    self.tilemap = tilemap
    self:resizeBounds()
  end

  --[[
  - Obtém o valor máximo de linhas.
  -
  - @return {number}
  --]]
  function _self:getMaxRows()
    return self._maxRows
  end

  --[[
  - Obtém o valor máximo de colunas.
  -
  - @return {number}
  --]]
  function _self:getMaxCols()
    return self._maxCols
  end

  --[[
  - Desenha um tile na tela.
  -
  - @param {number} tile ID do tile.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  --]]
  function _self:drawTile(tile, x, y)
    self:drawFrame(tile, x, y)
  end

  --[[
  - @override
  - Desenha o tileset na tela.
  --]]
  function _self:draw()
    -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    -- Ajustar opacidade:
    self:adjustOpacity()

    -- Desenhar o tileset:
    if self.visible == true and self.opacity > 0.0 then
      if self.tilemap ~= nil then

        -- Desenhar um retângulo colorido (cor de fundo):
        self:drawColor(self.color, self.offsetX, self.offsetY, (self._maxCols * self.width), (self._maxRows * self.height))

        -- Percorrer linhas e colunas...
				for row in pairs(self.tilemap) do
					for col in pairs(self.tilemap[row]) do

            -- Desenhar na tela:
						self:drawTile(
              self.tilemap[row][col],
							self.offsetX + ((col - 1) * self.width),
							self.offsetY + ((row - 1) * self.height)
						)

          end
				end

      end
    end
  end

  return _self
end
