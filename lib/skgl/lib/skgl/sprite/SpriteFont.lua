--[[@meta : @extends Sprite]]
SpriteFont = {
  name = "SpriteFont",
  extends = Sprite
}

--[[
- @class SpriteFont @extends Sprite
-
- @param {number} width Largura dos caracteres.
- @param {number} height Altura dos caracteres.
--]]
function SpriteFont.new(width, height)
  --[[@meta : @extends Sprite]]
  local def = Sprite.new(width, height)
  def.class = SpriteFont

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Set de caracteres usados pela fonte.
    self.charset = ""

    -- Mapa de caracteres.
    self.charmap = nil
  end

  --[[
  - Cria automaticamente um mapa de caracteres.
  -
  - @param {string} charset Set de caracteres a ser mapeado.
  -
  - @return {Object}
  --]]
  function def:createCharmap(charset)
    -- O mapa de caracteres será criado nesta variável:
    local charmap = {}

    -- Como a imagem contendo os caracteres é essencialmente uma spritesheet,
    -- é possível obter todos eles em formato de atlas de imagem:
    local imageAtlas = self:createImageAtlas()

    -- Percorrer e mapear todos os caracteres especificados no charset:
    for i = 1, #charset do
			local char = charset:sub(i, i)
			charmap[char] = imageAtlas[(i - 1)]
		end

    return charmap
  end

  --[[
  - Define um set de caracteres a ser usado pela fonte.
  -
  - @param {string} charset Set de caracteres a ser usado pela fonte.
  --]]
  function def:setCharset(charset)
    self.charset = charset
    self.charmap = self:createCharmap(charset)
  end

  --[[
  - Desenha um caractere da fonte na tela.
  -
  - @param {string} char Caractere da fonte.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  --]]
  function def:drawChar(char, x, y)
    if self.charmap[char] ~= nil then
      local charData = self.charmap[char]
      self:drawFrame(charData.index, x, y)
    end
  end

  --[[
  - Escreve o texto na tela.
  --]]
  function def:print(x, y, text)
    -- Linha e coluna iniciais:
    local row = 1
    local col = 1

    -- Ajustar opacidade:
    self:adjustOpacity()

    -- Desenhar o texto:
    if self.visible == true and self.opacity > 0.0 then

      -- Percorrer todos os caracteres do texto para desenhá-los:
      for i = 1, #text do
        local char = text:sub(i, i)

        -- Desenhar o caractere:
        self:drawChar(
          char,
          x + ((self.width  * math.abs(self.scaleX)) * (col - 1)),
          y + ((self.height * math.abs(self.scaleY)) * (row - 1))
        )

        -- Quebrar uma linha ao encontrar o "\n":
				if char == "\n" then
					row = (row + 1)
					col  = 0
				end

        -- Ir para a próxima coluna:
				col = (col + 1)
      end

    end
  end

  def:__init__()
  return def
end
