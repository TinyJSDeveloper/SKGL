----
-- Implementação de mapas de *tiles* (*tilesets*); é especialmente utilizada
-- para decorar os estágios de um jogo, mas podem possuir diversos outro usos.
--
-- Devido à limitações do *ONELua*, este objeto não apresenta uma boa
-- performance. Por isso, para *tilesets* maiores, o `skgl.GBATileMap` é o mais
-- recomendável.
--
-- Diferente do `skgl.GBATileMap`, no entanto, o tamanho deste objeto pode
-- assumir diversos tamanhos diferentes sem necessariamente preencher toda a
-- tela. Seu uso também é mais simples e direto, viabilizando seu uso.
--
-- Extends `skgl.Sprite`
--
-- Dependencies: `skgl.Display`, `skgl.Graphics`, `skgl.Sprite`
-- @classmod skgl.TileMap
local Display = require("skgl.Display")
local Sprite = require("skgl.Sprite")
local Graphics = require("skgl.Graphics")
local M = Sprite:subclass("skgl.TileMap")

----
-- Construtor da classe.
-- @param width (***number***) Largura dos *tiles*.
-- @param height (***number***) Altura dos *tiles*.
function M:initialize(width, height)
  -- Inicializar superclasse:
  Sprite.initialize(self, width, height)

  --- Mapa de *tiles*.
  self.tilemap = nil

  --- Máscara de colisão (use 0 para áreas livres e 1 para obstáculos).
  self.collisionData = nil

  -- @private Valor máximo de linhas.
  self._maxRows = 0

  -- @private Valor máximo de colunas.
  self._maxCols = 0
end

----
-- Define os valores máximos de linhas e colunas.
function M:setMapArea(maxRows, maxCols)
  -- Valores máximos de linhas e colunas presentes no mapa de tiles:
  maxRows = maxRows or 0
  maxCols = maxCols or 0

  -- As dimensões da caixa de colisão são determinadas pelo total de linhas
  -- e pela linha com o maior número de colunas:
  self.bounds.width = maxCols * self.width
  self.bounds.height = maxRows * self.height

  -- Guardar o valor máximo de linhas e colunas para uso futuro:
  self._maxRows = maxRows
  self._maxCols = maxCols
end

----
-- (***@Override***) Redimensiona a caixa de colisão de acordo com os atributos
-- de altura e largura do *tileset*.
function M:resizeBounds()
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

----
-- Define um mapa de *tiles* usado pelo *tileset*.
-- @param tilemap (***{{number}}***) Mapa de *tiles* a ser usado pelo *tileset*.
-- @param autoMapArea (***boolean***) Quando ativado, obtém os valores máximos de
-- linhas e colunas automaticamente. O valor padrão é "`true`".
-- @param maxRows (***number***) Valor máximo de linhas.
-- @param maxCols (***number***) Valor máximo de colunas.
function M:setTilemap(tilemap, autoMapArea, maxRows, maxCols)
  self.tilemap = tilemap

  -- Mapear área manualmente (os valores devem ser passados com a função):
  if autoMapArea == false then
    self:setMapArea(maxRows, maxCols)

  -- ...ou automaticamente:
  else
    self:resizeBounds()
  end
end

----
-- Obtém o valor máximo de linhas.
-- @return O valor descrito.
function M:getMaxRows()
  return self._maxRows
end

----
-- Obtém o valor máximo de colunas.
-- @return O valor descrito.
function M:getMaxCols()
  return self._maxCols
end

----
-- Desenha um *tile* na tela.
-- @param tile (***number***) ID do *tile*.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
function M:drawTile(tile, x, y)
  self:drawFrame(tile, x, y, true)
end

----
-- Procura pela informação de um *tile* que esteja na coordenada especificada.
-- Diferente das outras funções, esta requer o mapa de *tiles* como parâmetro.
-- @param x (***number***) Posição X.
-- @param y (***number***) Posição Y.
-- @param tilemap (***{{number}}***) Mapa de *tiles*.
-- @return Um objeto contendo a ID do *tile*, além de outras informações
-- adicionais; ou nada, caso não exista.
function M:getTileInfo(x, y, tilemap)
  if tilemap ~= nil then
    -- Obter posições X e Y relativas ao mapa:
    local mapX = x - self.x
    local mapY = y - self.y

    -- Obter possível ID do tile:
    local tileX = (math.floor(mapX / math.floor(self.width  * self.scaleX) )) + 1
    local tileY = (math.floor(mapY / math.floor(self.height * self.scaleY) )) + 1

    -- Se encontrado no mapa de tiles, as informações do tile serão retornadas:
    if tilemap[tileY] ~= nil and tilemap[tileY][tileX] ~= nil then
      return {
		    id      = tilemap[tileY][tileX],
        tileX   = tileX,
        tileY   = tileY,
        x       = (tileX - 1),
        y       = (tileY - 1),
        offsetX = self.offsetX + ((tileX - 1) * math.floor(self.width  * self.scaleX)),
        offsetY = self.offsetY + ((tileY - 1) * math.floor(self.height * self.scaleY)),
        width   = math.floor(self.width  * self.scaleX),
        height  = math.floor(self.height * self.scaleY)
      }
    else
      return nil
    end
  end

  return nil
end

----
-- Procura pela ID de um *tile* que esteja na coordenada especificada.
-- @param x (***number***) Posição X.
-- @param y (***number***) Posição Y.
-- @return A ID do *tile*; ou -1, caso não exista.
function M:checkTile(x, y)
  local tileInfo = self:getTileInfo(x, y, self.tilemap)

  if tileInfo ~= nil then
    return tileInfo.id
  else
    return -1
  end
end

----
-- Verifica se há colisão na coordenada especificada, com base na máscara de
-- colisão do mapa de *tiles*.
-- @param x (***number***) Posição X.
-- @param y (***number***) Posição Y.
-- @return O resultado da colisão.
function M:hitTest(x, y)
  local tileInfo = self:getTileInfo(x, y, self.collisionData)

  if tileInfo ~= nil and tileInfo.id >= 1 then
    return true
  else
    return false
  end
end

----
-- (***@Override***) Determina se o *sprite* está ou não dentro da tela.
-- @return O valor descrito.
function M:isInsideScreen()
  return Graphics.isInsideScreen(self.offsetX, self.offsetY, (self.width * self._maxCols), (self.height * self._maxRows))
end

----
-- (***@Override***) Desenha o *tileset* na tela.
-- @param delta Variação de tempo (*delta time*).
function M:draw(delta)
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

      -- Salvar o tamanho original dos tiles...
      local originalWidth  = self.width
      local originalHeight = self.height

      -- ...e alterá-los com base na escala. Eles serão restaurados mais tarde:
      self.width  = math.abs(self.width  * self.scaleX)
      self.height = math.abs(self.height * self.scaleY)

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

      -- Restaurar o tamanho original dos tiles:
      self.width = originalWidth
      self.height = originalHeight

    end
  end
end

return M
