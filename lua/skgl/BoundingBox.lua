----
-- Caixa de colisão usada pelos *sprites* e outros objetos do jogo.
--
-- @classmod skgl.BoundingBox
local class = require("middleclass")
local M = class("skgl.BoundingBox")

----
-- construtor da classe.
-- @param width (***number***) Largura.
-- @param height (***number***) Altura.
-- @function new
function M:initialize(width, height)
  --- Posição X.
  self.x = 0

  --- Posição Y.
  self.y = 0

  --- Posição X relativa à original (*offset*).
  self.offsetX = 0

  --- Posição Y relativa à original (*offset*).
  self.offsetY = 0

  --- Largura.
  self.width = width or 0

  --- Altura.
  self.height = height or 0

  --- Quando ativada, ajusta o tamanho da caixa de colisão para ser o mesmo de
  --- um *sprite*. O tamanho é alterado automaticamente.
  self.autoResize = false
end

----
-- Checagem de colisão entre duas caixas.
-- @param collider (`skgl.BoundingBox`) Colisor.
-- @return Retorna o resultado da checagem, isto é, se houve colisão.
function M:intersect(collider)
  return (
    self.offsetX < collider.offsetX + collider.width  and
    self.offsetX + self.width > collider.offsetX      and
    self.offsetY < collider.offsetY + collider.height and
    self.height + self.offsetY > collider.offsetY
  )
end

----
-- Ajusta o tamanho da caixa de colisão para ser o mesmo de um *sprite*.
-- @param sprite (`skgl.Sprite`) Sprite.
function M:adjustSize(sprite)
  if self.autoResize == true then
    self.width = sprite.width
    self.height = sprite.height
  end
end

----
-- Ajusta o *offset* da caixa de colisão, sendo relativo a um *sprite*.
-- @param sprite (`skgl.Sprite`) Sprite.
function M:adjustOffset(sprite)
  self.offsetX = (self.x + sprite.offsetX) - sprite.paddingX
  self.offsetY = (self.y + sprite.offsetY) - sprite.paddingY
end

return M
