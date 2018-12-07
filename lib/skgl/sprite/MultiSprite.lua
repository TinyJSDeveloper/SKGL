--[[@meta : @extends Sprite]]
MultiSprite = {
  class = "MultiSprite",
  extends = Sprite
}

--[[
- @class MultiSprite @extends Sprite
-
- @param {number} width Largura do sprite.
- @param {number} height Altura do sprite.
--]]
function MultiSprite.new(width, height)
  --[[@meta : @extends Sprite]]
  local def = Sprite.new(width, height)
  def.class = MultiSprite

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Array de imagens usadas pelo sprite.
    self.images = {}

    -- @todo Será que poderíamos aumentar a caixa de colisão ao aumentar a escala? Seria bom ter isso...
  end

  --[[
  - @override
  - Desenha um frame do sprite na tela.
  -
  - @param {number} frame Frame do sprite.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  --]]
  function def:drawFrame(frame, x, y)
    if self.images[(frame + 1)] ~= nil then

      -- Desenhar o frame do sprite:
      Surface.drawImageExtended(
        self.images[(frame + 1)],
        x + self.originX,
        y + self.originY,
        self.originX,
        self.originY,
        self.scaleX,
        self.scaleY,
        self.rotation,
        self.opacity
      )

    end
  end

  def:__init__()
  return def
end
