----
-- Grupo de *sprites* que serve como camada para as cenas do jogo.
--
-- Extends `skgl.Array`
--
-- Dependencies: `skgl.Array`
-- @classmod skgl.Group
local Array = require("skgl.Array")
local M = Array:subclass("skgl.Group")

----
-- Construtor da classe.
-- @param id (***string***) ID do grupo.
-- @function new
function M:initialize(id)
  -- Inicializar superclasse:
  Array.initialize(self)

  --- ID do grupo.
  self.id = id or nil

  --- Parente do grupo.
  self.parent = nil

  --- Posição X.
  self.x = 0

  --- Posição Y.
  self.y = 0

  --- Determina se o *scroll* horizontal da câmera é ou não é permitido.
  self.scrollHorizontally = true

  --- Determina se o *scroll* vertical da câmera é ou não é permitido.
  self.scrollVertically = true

  --- *Parallax* horizontal (efeito de profundidade para a câmera).
  self.parallaxX = 0

  --- *Parallax* vertical (efeito de profundidade para a câmera).
  self.parallaxY = 0

  -- @private Lista de sprites destruídos.
  self._destroyedSprites = {}

  -- @private Variação de tempo.
  self._delta = 0
end

----
-- Define configurações de *scroll* horizontal e vertical da câmera.
-- @param horizontally (***boolean***) Habilitar ou desabilitar o scroll horizontal.
-- @param vertically (***boolean***) Habilitar ou desabilitar o scroll vertical.
function M:setScroll(horizontally, vertically)
  self.scrollHorizontally = horizontally or false
  self.scrollVertically = vertically or false
end

----
-- Define valores de *parallax* horizontal e vertical.
-- @param x (***number***) *Parallax* horizontal.
-- @param y (***number***) *Parallax* vertical.
function M:setParallax(x, y)
  self.parallaxX = x or 0
  self.parallaxY = y or 0
end

----
-- Função acionada pelos *sprites* ao serem destruídos.
-- @param sprite (`skgl.Sprite`) Sprite.
function M:notifyDestruction(sprite)
  if sprite ~= nil then
    sprite:onDestroy()
    sprite.parent = nil
    table.insert(self._destroyedSprites, sprite)
  end
end

----
-- Desenha o grupo na tela.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:draw(delta)
  -- Percorrer todos os sprites...
  self:foreach(function(key, value, index)
    value.parent = self
    value.scene = self.parent

    -- Executar evento de "update" e desenhar o sprite na tela...
    if not value:isDestroyed() then
      value:setDelta(delta)

      -- O evento de "update" é executado apenas depois de ter sido criado...
      if value:isCreated() then
        value:update(delta)

      -- ...do contrário, o evento "onCreate()" é acionado primeiro:
      else
        value:onCreate()
        value._created = true
      end

    -- Desenhar o sprite:
    value:draw(delta)

    -- ...ou marcá-lo na lista de exclusão, caso tenha sido removido:
    else
      self:notifyDestruction(value)
    end
  end)

  -- Remover sprites destruídos e limpar a lista:
  self:removeItems(self._destroyedSprites)
  self._destroyedSprites = {}
end

----
-- Movimenta a posição X do grupo em um valor relativo.
-- @param value (***number***) Valor relativo do movimento.
function M:moveX(value)
  self.x = (self.x + (value * self:getDelta()))
end

----
-- Movimenta a posição Y do grupo em um valor relativo.
-- @param value (***number***) Valor relativo do movimento.
function M:moveY(value)
  self.y = (self.y + (value * self:getDelta()))
end

----
-- Obtém o valor da variação de tempo (*delta time*).
-- @return O valor descrito.
function M:getDelta()
  return self._delta
end

----
-- Define um valor para a variação de tempo (*delta time*).
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:setDelta(delta)
  self._delta = delta
end

----
-- (***@event***) Evento chamado a cada quadro.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:update(delta)
end

return M
