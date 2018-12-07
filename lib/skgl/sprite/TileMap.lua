--[[@meta : @extends Sprite]]
TileMap = {
  name = "TileMap",
  extends = Sprite
}

--[[
- @class TileMap @extends Sprite
-
- @param {number} width Largura dos tiles.
- @param {number} height Altura dos tiles.
--]]
function TileMap.new(width, height)
  --[[@meta : @extends Sprite]]
  local def = Sprite.new(width, height)
  def.class = TileMap

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Mapa de tiles.
    self.tilemap = nil

    -- @private Valor máximo de linhas.
    self._maxRows = 0

    -- @private Valor máximo de colunas.
    self._maxCols = 0
  end

  --[[
  - @override
  - Redimensiona a caixa de colisão de acordo com os atributos de altura e
  - largura do tileset.
  --]]
  function def:resizeBounds()
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
  function def:setTilemap(tilemap)
    self.tilemap = tilemap
    self:resizeBounds()
  end

  --[[
  - @return {number} Obtém o valor máximo de linhas.
  --]]
  function def:getMaxRows()
    return self._maxRows
  end

  --[[
  - @return {number} Obtém o valor máximo de colunas.
  --]]
  function def:getMaxCols()
    return self._maxCols
  end

  --[[
  - Desenha um tile na tela.
  -
  - @param {number} tile ID do tile.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  --]]
  function def:drawTile(tile, x, y)
    self:drawFrame(tile, x, y)
  end

  --[[
  - Procura pela ID de um tile que esteja na coordenada especificada.
  -
  - @param {number} x Posição X.
  - @param {number} y Posição Y.
  -
  - @return {number} Retorna a ID do tile (ou -1 caso não exista).
  --]]
  function def:getTileAt(x, y)
    if self.tilemap ~= nil then
      -- Obter posições X e Y relativas ao mapa:
      local mapX = (x - self.offsetX)
      local mapY = (y - self.offsetY)

      -- Obter possível ID do tile:
      local tileX = (math.floor(mapX / self.width)) + 1
      local tileY = (math.floor(mapY / self.height)) + 1

      -- Se encontrado no mapa de tiles, a ID do tile será retornada:
      if self.tilemap[tileY] ~= nil and self.tilemap[tileY][tileX] ~= nil then
        return self.tilemap[tileY][tileX]
      end
    end

    return -1
  end

  --[[
  - @override
  - @return {boolean} Determina se o sprite está dentro da tela.
  --]]
  function def:isInsideScreen()
    return Surface.isInsideScreen(self.offsetX, self.offsetY, self.bounds.width, self.bounds.height)
  end

  --[[
  - @override
  - Desenha o tileset na tela.
  -
  - @param {number} delta Variação de tempo.
  --]]
  function def:draw(delta)
    -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    -- Ajustar opacidade:
    self:adjustOpacity()

    -- Aplicar as velocidades horizontal (posição X) e vertical (posição Y):
    self:applySpeed()

    -- Desenhar o tileset:
    if self.visible == true and self.opacity > 0.0 and self:isInsideScreen() == true then
      if self.tilemap ~= nil then

        -- Desenhar um retângulo colorido (cor de fundo):
        self:drawColor(self.color, self.offsetX, self.offsetY, (self._maxCols * self.width), (self._maxRows * self.height))

        -- Obter valores máximos de linhas e colunas possíveis na tela:
        local maxRowsOnScreen = math.ceil(Display.getHeight() / self.height)
        local maxColsOnScreen = math.ceil(Display.getWidth() / self.width)

        -- Índices indicativos (qual índice do mapa começar e onde terminar):
        local rowStart = 0
        local rowEnd = self:getMaxRows()
        local colStart = 0
        local colEnd = self:getMaxCols()

        -- Obter a primeira linha de exibição:
        if self.offsetY < 0 then
          rowStart = math.abs(math.floor(self.offsetY / self.height))
        end

        -- Obter a primeira coluna de exibição:
        if self.offsetX < 0 then
          colStart = math.abs(math.floor(self.offsetX / self.width))
        end

        -- Limitar valor máximo de linhas para o que pode ser exibido na tela:
        if rowEnd > maxRowsOnScreen then
          rowEnd = maxRowsOnScreen
        end

        -- Limitar valor máximo de colunas para o que pode ser exibido na tela:
        if colEnd > maxColsOnScreen then
          colEnd = maxColsOnScreen
        end

        -- Percorrer linhas...
        for row = rowStart, (rowEnd + rowStart) do
          if self.tilemap[row] ~= nil then

            -- Percorrer colunas...
            for col = colStart, (colEnd + colStart) do
              if self.tilemap[row][col] ~= nil then

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
    end
  end

  def:__init__()
  return def
end
