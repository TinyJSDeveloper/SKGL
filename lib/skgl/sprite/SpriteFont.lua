--[[@meta : @extends Sprite]]
SpriteFont = {
  name = "SpriteFont",
  extends = Sprite
}

function SpriteFont.new(width, height)
  --[[@meta : @extends Sprite]]
  local _self = Sprite.new(width, height)
  _self.class = SpriteFont

  -- Set de caracteres usados pela fonte.
  _self.charset = ""

  -- Mapa de caracteres.
  _self.charmap = nil

  --[[
  - @return {Object} Cria automaticamente um mapa de caracteres.
  -
  - @param {string} charset Set de caracteres a ser mapeado.
  --]]
  function _self:createCharmap(charset)
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
  function _self:setCharset(charset)
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
  function _self:drawChar(char, x, y)
    if self.charmap[char] ~= nil then
      local charData = self.charmap[char]
      self:drawFrame(charData.index, x, y)
    end
  end

  --[[
  - Escreve o texto na tela.
  --]]
  function _self:print(x, y, text)
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
          x + (self.width * (col - 1)),
          y + (self.height * (row - 1))
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

  return _self
end
