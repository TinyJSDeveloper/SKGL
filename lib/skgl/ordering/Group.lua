--[[@meta : @extends Array]]
Group = {
  name = "SpriteFont",
  extends = Array
}

function Group.new()
  --[[@meta : @extends Array]]
  local _self = Array.new()
  _self.class = Group

  -- Parente do grupo.
  _self.parent = nil

  -- Posição X.
  _self.x = 0

  -- Posição Y.
  _self.y = 0

  -- Determina se o scroll horizontal da câmera é ou não é permitido.
  _self.scrollHorizontally = true

  -- Determina se o scroll vertical da câmera é ou não é permitido.
  _self.scrollVertically = true

  -- Parallax (efeito de profundidade para a câmera).
  _self.parallax = 0

  -- @private Lista de sprites destruídos.
  _self._destroyedSprites = {}

  --[[
  - Define configurações de scroll horizontal e vertical da câmera.
  -
  - @param {boolean} Habilitar ou desabilitar o scroll horizontal.
  - @param {boolean} Habilitar ou desabilitar o scroll vertical.
  --]]
  function _self:setScroll(horizontal, vertical)
    self.scrollHorizontally = horizontal or self.scrollHorizontally
    self.scrollVertically = vertical or self.scrollVertically
  end

  --[[
  - Função acionada pelos sprites ao serem destruídos.
  -
  - @param {Sprite} sprite Sprite.
  --]]
  function _self:notifyDestruction(sprite)
    if sprite ~= nil then
      sprite.parent = nil
      table.insert(self._destroyedSprites, sprite)
    end
  end

  --[[
  - Desenha o grupo na tela.
  --]]
  function _self:draw()
    -- Percorrer todos os sprites...
    self:foreach(function(key, value, index)
      value.parent = self

      -- Executar evento de "update" e desenhar o sprite na tela...
      if not value:isDestroyed() then
        value:update()
        value:draw()

      -- ...ou marcá-lo na lista de exclusão, caso tenha sido removido:
      else
        self.notifyDestruction(value)
      end
    end)

    -- Remover sprites destruídos e limpar a lista:
    self:removeItems(self._destroyedSprites)
    self._destroyedSprites = {}
  end

  return _self
end
