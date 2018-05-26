--[[@meta : @extends Sprite]]
TileSprite = {
  name = "TileSprite",
  extends = TileSprite
}

function TileSprite.new(width, height)
  --[[@meta : @extends Sprite]]
  local _self = Sprite.new(width, height)
  _self.class = TileSprite

  -- Largura do mapa.
  _self.mapWidth = 0

  -- Altura do mapa.
  _self.mapHeight = 0

  --[[
  - @override
  - Redimensiona a caixa de colisão de acordo com os atributos de altura e
  - largura do sprite.
  --]]
  function _self:resizeBounds()
    if self.bounds ~= nil then
      self.bounds.width = self.mapWidth
      self.bounds.height = self.mapHeight
    end
  end

  --[[
  - Define o tamanho do mapa.
  -
  - @param {number} mapWidth Largura do mapa.
  - @param {number} mapHeight Altura do mapa.
  --]]
  function _self:setMapSize(mapWidth, mapHeight)
    self.mapWidth = mapWidth or self.mapWidth
    self.mapHeight = mapHeight or self.mapHeight
  end

  --[[
  - Desenha uma linha de tiles, sendo que o último da coluna pode ser cortado.
  -
	- @param {number} width Contador de largura.
	- @param {number} height Contador de altura.
	- @param {number} tileWidth Largura original dos tiles.
	- @param {number} tileHeight Altura original dos tiles.
  --]]
  function _self:drawFrameRow(width, height, tileWidth, tileHeight)
    while width < self.mapWidth do
      -- Desenhar tiles de forma ordenada...
			if (width + self.width) < self.mapWidth then
				self:drawFrame(
          self:getFrame(self.frame),
					self.offsetX + width,
					self.offsetY + height
				)

				width = (width + self.width)

      -- Desenhar o pedaço restante do último tile...
      else
        self.width = (self.mapWidth - width)
				self:drawFrame(
          self:getFrame(self.frame),
					self.offsetX + width,
					self.offsetY + height
				)
				break
      end
    end

    -- Restaurar tamanho original dos tiles:
		self.width  = tileWidth
		self.height = tileHeight
  end

  --[[
  - Desenha várias colunas de tiles.
  --]]
  function  _self:drawFrameColumns()
    -- Contadores de tamanho (largura e altura):
    local width = 0
    local height = 0

    -- Salvar tamanho original dos tiles (eles serão restaurados depois):
    local tileWidth = self.width
    local tileHeight = self.height

    while height < self.mapHeight do
      -- Desenhar tiles de forma ordenada...
      if (height + self.height) < self.mapHeight then
        self:drawFrameRow(width, height, tileWidth, tileHeight)
        height = (height + self.height)

      -- Desenhar o pedaço restante do último tile...
      else
        self.height = self.mapHeight - height
        self:drawFrameRow(width, height, tileWidth, tileHeight)
        break
      end
    end

    -- Restaurar tamanho original dos tiles:
    self.width = tileWidth
    self.height = tileHeight
  end

  --[[
  - @override
  - Desenha o sprite na tela.
  -
  - @param {number} delta Variação de tempo.
  --]]
  function _self:draw(delta)
    -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    -- Ajustar frame e opacidade:
    self:adjustFrame()
    self:adjustOpacity()

    -- Aplicar as velocidades horizontal (posição X) e vertical (posição Y):
    self:applySpeed()

    -- Desenhar o sprite:
    if self.visible == true and self.opacity > 0.0 then

      -- Desenhar um retângulo colorido (cor de fundo):
      self:drawColor(self.color, self.offsetX, self.offsetY, self.mapWidth, self.mapHeight)

      if self.image ~= nil then
        -- Criar um atlas de imagens, caso não exista:
  			if self.imageAtlas == nil then
  				self.imageAtlas = self:createImageAtlas()
  			end

        -- Desenhar colunas:
        self:drawFrameColumns()
      end

    end

    -- Requisitar o próximo frame:
    self:nextFrame(delta)
  end

  return _self
end
