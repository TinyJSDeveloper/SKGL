--[[@meta : @extends Array]]
Group = {
  name = "SpriteFont",
  extends = Array
}

--[[
- @class Group @extends Array
--]]
function Group.new()
  --[[@meta : @extends Array]]
  local def = Array.new()
  def.class = Group

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Parente do grupo.
    self.parent = nil

    -- Posição X.
    self.x = 0

    -- Posição Y.
    self.y = 0

    -- Determina se o scroll horizontal da câmera é ou não é permitido.
    self.scrollHorizontally = true

    -- Determina se o scroll vertical da câmera é ou não é permitido.
    self.scrollVertically = true

    -- Parallax (efeito de profundidade para a câmera).
    self.parallax = 0

    -- @private Lista de sprites destruídos.
    self._destroyedSprites = {}

    -- @private Variação de tempo.
    self._delta = 0
  end

  --[[
  - Define configurações de scroll horizontal e vertical da câmera.
  -
  - @param {boolean} horizontally Habilitar ou desabilitar o scroll horizontal.
  - @param {boolean} vertically Habilitar ou desabilitar o scroll vertical.
  --]]
  function def:setScroll(horizontally, vertically)
    self.scrollHorizontally = horizontally or false
    self.scrollVertically = vertically or false
  end

  --[[
  - Função acionada pelos sprites ao serem destruídos.
  -
  - @param {Sprite} sprite Sprite.
  --]]
  function def:notifyDestruction(sprite)
    if sprite ~= nil then
      sprite.parent = nil
      table.insert(self._destroyedSprites, sprite)
    end
  end

  --[[
  - Desenha o grupo na tela.
  -
  - @param {number} delta Variação de tempo.
  --]]
  function def:draw(delta)
    -- Percorrer todos os sprites...
    self:foreach(function(key, value, index)
      value.parent = self
      value.scene = self.parent

      -- Executar evento de "update" e desenhar o sprite na tela...
      if not value:isDestroyed() then
        value:setDelta(delta)
        value:update(delta)
        value:draw(delta)

      -- ...ou marcá-lo na lista de exclusão, caso tenha sido removido:
      else
        self.notifyDestruction(value)
      end
    end)

    -- Remover sprites destruídos e limpar a lista:
    self:removeItems(self._destroyedSprites)
    self._destroyedSprites = {}
  end

  --[[
  - Movimenta a posição X do grupo em um valor relativo.
  -
  - @param {number} valor Valor relativo do movimento.
  --]]
  function def:moveX(value)
    self.x = (self.x + (value * self:getDelta()))
  end

  --[[
  - Movimenta a posição Y do grupo em um valor relativo.
  -
  - @param {number} valor Valor relativo do movimento.
  --]]
  function def:moveY(value)
    self.y = (self.y + (value * self:getDelta()))
  end

  --[[
  - Obtém o valor da variação de tempo.
  -
  - @return {number}
  --]]
  function def:getDelta()
    return self._delta
  end

  --[[
  - Define um valor para a variação de tempo.
  -
  - @param {number} Variação de tempo.
  --]]
  function def:setDelta(delta)
    self._delta = delta
  end

  --[[
  - @event
  - @param {number} delta Variação de tempo.
  --]]
  function def:update(delta)
  end

  def:__init__()
  return def
end
