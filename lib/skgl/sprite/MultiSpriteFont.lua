--[[@meta : @extends SpriteFont]]
MultiSpriteFont = {
  name = "MultiSpriteFont",
  extends = SpriteFont
  }

--[[
- @class MultiSpriteFont @extends SpriteFont
--]]
function MultiSpriteFont.new(width, height)
  --[[@meta : @extends SpriteFont]]
  local def = SpriteFont.new(width, height)
  def.class = MultiSpriteFont

  --[[
  - @constructor
  --]]
  function def:__init__()
  -- Array de imagens usadas pela fonte. Cara imagem equivale a um caractere.
  self.images = {}
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

  --[[
  - @override
  - Cria automaticamente um mapa de caracteres.
  -
  - @param {string} charset Set de caracteres a ser mapeado.
  -
  - @return {Object}
  --]]
  function def:createCharmap(charset)
    -- O mapa de caracteres será criado nesta variável:
    local charmap = {}

    -- Percorrer e mapear todos os caracteres especificados no charset:
    for i = 1, #charset do
			local char = charset:sub(i, i)
			charmap[char] = (i - 1)
		end

    return charmap
  end

  --[[
  - @override
  - Desenha um caractere da fonte na tela.
  -
  - @param {string} char Caractere da fonte.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  --]]
  function def:drawChar(char, x, y)
    if self.charmap[char] ~= nil then
      local charData = self.charmap[char]
      self:drawFrame(charData, x, y)
    end
  end

  def:__init__()
  return def
end
