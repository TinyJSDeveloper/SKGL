----
-- Objeto gráfico animado a partir de uma *spritesheet*; é capaz de preencher
-- toda a sua área com gráficos que se repetem, tornando-o especialmente útil
-- para criar planos de fundo (*backgrounds*).
--
-- Dependencies: `skgl.Display`, `skgl.Sprite`, `skgl.Surface`
-- @classmod skgl.TileSprite
local Display = require("skgl.Display")
local Sprite = require("skgl.Sprite")
local Surface = require("skgl.Surface")
local M = Sprite:subclass("skgl.TileSprite")

----
-- Construtor da classe.
-- @param width (***number***) Largura dos *tiles*.
-- @param height (***number***) Altura dos *tiles*.
function M:initialize(width, height)
  -- Inicializar superclasse:
  Sprite.initialize(self, width, height)

  --- Largura do mapa.
  self.mapWidth = 0

  --- Altura do mapa.
  self.mapHeight = 0
end

----
-- Redimensiona a caixa de colisão de acordo com os atributos de altura e
-- largura do *sprite*.
function M:resizeBounds()
  if self.bounds ~= nil then
    self.bounds.width = self.mapWidth
    self.bounds.height = self.mapHeight
  end
end

----
-- Define o tamanho do mapa.
-- @param mapWidth (***number***) Largura do mapa.
-- @param mapHeight (***number***) Altura do mapa.
function M:setMapSize(mapWidth, mapHeight)
  self.mapWidth = mapWidth or self.mapWidth
  self.mapHeight = mapHeight or self.mapHeight
  self:resizeBounds()
end

----
-- Desenha uma linha de *tiles*, sendo que o último da coluna pode ser cortado.
-- @param width (***number***) Contador de largura.
-- @param height (***number***) Contador de altura.
-- @param tileWidth (***number***) Largura original dos *tiles*.
-- @param tileHeight (***number***) Altura original dos *tiles*.
function M:drawFrameRow(width, height, tileWidth, tileHeight)
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

----
-- Desenha várias colunas de *tiles*.
function  M:drawFrameColumns()
  -- Contadores de tamanho (largura e altura):
  local width =  0
  local height = 0

  -- Salvar tamanho original dos tiles (eles serão restaurados depois):
  local tileWidth = self.width
  local tileHeight = self.height

  -- Salvar tamanho original do mapa (ele será restaurado depois):
  local mapWidth = self.mapWidth
  local mapHeight = self.mapHeight

  -- Adiantar contador de largura para não iterar sobre tiles desnecessários:
  if self.offsetX < -self.width then
    width = math.floor(math.abs(self.offsetX / self.width)) * self.width
  end

  -- Adiantar contador de altura para não iterar sobre tiles desnecessários:
  if self.offsetY < -self.height then
    height = math.floor(math.abs(self.offsetY / self.height)) * self.height
  end

  -- Alterar a largura do mapa para não iterar sobre tiles desnecessários:
  if (self.offsetX + self.mapWidth) > Display.getWidth() then
    self.mapWidth = Display.getWidth() - self.offsetX
  end

  -- Alterar a altura do mapa para não iterar sobre tiles desnecessários:
  if (self.offsetY + self.mapHeight) > Display.getHeight() then
    self.mapHeight = Display.getHeight() - self.offsetY
  end

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

  -- Restaurar tamanho original do mapa:
  self.mapWidth = mapWidth
  self.mapHeight = mapHeight
end

----
-- (***@Override***) Determina se o *sprite* está ou não dentro da tela.
-- @return O valor descrito.
function M:isInsideScreen()
  return Surface.isInsideScreen(self.offsetX, self.offsetY, self.mapWidth, self.mapHeight)
end

----
-- (***@Override***) Desenha o *sprite* na tela.
-- @param delta Variação de tempo (*delta time*).
function M:draw(delta)
  -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
  self:adjustOffset()
  self:adjustBounds()

  -- Ajustar frame e opacidade:
  self:adjustFrame()
  self:adjustOpacity()

  -- Aplicar as velocidades horizontal (posição X) e vertical (posição Y):
  self:applySpeed()

  -- Desenhar o sprite:
  if self.visible == true and self.opacity > 0.0 and self:isInsideScreen() == true then

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

return M
