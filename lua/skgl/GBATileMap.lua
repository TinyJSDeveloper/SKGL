----
-- Abstração do `map` do *ONELua*; é similar ao `skgl.TileMap`, mas funciona
-- a partir de uma implementação da biblioteca
-- *[GBA Graphics](http://www.mobile-dev.ch/old.php?page=pcsoft_gbagraphics)*,
-- desenvolvida por *Brunni*.
--
-- Sua performance é melhor e mais rápida que o `skgl.TileMap`, mas se repete
-- até preencher toda a tela.
--
-- Extends `skgl.TileMap`
--
-- Dependencies: `skgl.TileMap`
-- @classmod skgl.GBATileMap
local TileMap = require("skgl.TileMap")
local M = TileMap:subclass("skgl.GBATileMap")

----
-- Construtor da classe.
-- @param image (***any***) *Spritesheet* (deve ser obrigatoriamente divisível por 8).
-- @param tilemap (***{{number}}***) Mapa de *tiles*.
-- @param width (***number***) Largura dos *tiles*.
-- @param height (***number***) Altura dos *tiles*.
-- @param autoMapArea (***boolean***) Quando ativado, obtém os valores máximos de
-- linhas e colunas automaticamente. O valor padrão é "`true`".
-- @param maxRows (***number***) Valor máximo de linhas.
-- @param maxCols (***number***) Valor máximo de colunas.
-- @function new
function M:initialize(image, tilemap, width, height, autoMapArea, maxRows, maxCols)
  -- Inicializar superclasse:
  TileMap.initialize(self, width, height)

  --- Objeto de mapa do *GBA Graphics* (um objeto `map` do *ONELua*).
  self.GBAMap = nil

  --- *Spritesheet*.
  self.image = image

  -- Definir imagem e mapa de tiles usado por esta instância. Estas
  -- propriedades não poderão ser alteradas após a criação deste objeto:
  self:setTilemap(tilemap, autoMapArea, maxRows, maxCols)

  -- Tentar criar um objeto de mapa do GBA Graphics:
  self:adjustGBAMap()
end

----
-- Verifica se esta instância possui todos os parâmetros necessários para a
-- criação de um objeto de mapa do *GBA Graphics*. Esta checagem maximiza as
-- chances de funcionamento, evitando travamentos do jeito que for possível.
-- @return O resultado da verificação, ou seja, se está qualificada ou não.
function M:isQualified()
  local imageWidth = self:getImageWidth()
  local imageHeight = self:getImageHeight()

  return (
    imageWidth >= 8 and
    imageHeight >= 8 and
    imageWidth % 8 == 0 and
    imageHeight % 8 == 0
  )
end

----
-- Controla a criação do objeto de mapa do *GBA Graphics*, caso não exista.
function M:adjustGBAMap()
  if self.GBAMap == nil and self:isQualified() then
    self.GBAMap = map.new(self.image, self.tilemap, self.width, self.height)
  end
end

----
-- (***@Override***) Desenha o *tileset* na tela.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:draw(delta)
  -- Tentar criar um objeto de mapa do GBA Graphics:
  self:adjustGBAMap()

  -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
  self:adjustOffset()
  self:adjustBounds()

  -- Ajustar opacidade:
  --self:adjustOpacity()

  -- Aplicar as velocidades horizontal (posição X) e vertical (posição Y):
  self:applySpeed()

  -- Desenhar o tileset:
  if self.visible == true and self.opacity > 0.0 and self:isInsideScreen() == true then
    if self.tilemap ~= nil and self.GBAMap ~= nil then
      self:drawColor(self.color, self.offsetX, self.offsetY, (self._maxCols * self.width), (self._maxRows * self.height))

      -- O tileset da GBA Graphics é desenhado através desta função...
      map.blit(self.GBAMap, -(self.offsetX), -(self.offsetY))
    end
  end
end

return M
