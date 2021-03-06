----
-- Fonte montada a partir de uma *spritesheet*; este objeto permite
-- escrever texto em qualquer lugar, dado um mapa de caracteres apropriado.
--
-- Devido à limitações do *ONELua*, esta fonte não pode ser rotacionada,
-- escalada ou invertida. Para isso, habilite o modo *Multi Sprite*, um
-- modo especial deste objeto capaz de realizar estas funções, sob o custo do
-- uso de imagens separadas ao invés de uma *spritesheet*.
--
-- O texto é sempre exibido da esquerda para a direita. As fontes funcionam de
-- maneira independente: para escrever na tela, basta usar, em qualquer lugar,
-- o método `skgl.SpriteFont:print()`.
--
-- Extends `skgl.Sprite`
--
-- Dependencies: `skgl.Sprite`
-- @classmod skgl.SpriteFont
local Sprite = require("skgl.Sprite")
local M = Sprite:subclass("skgl.SpriteFont")

----
-- Construtor da classe.
-- @param width (***number***) Largura dos caracteres.
-- @param height (***number***) Altura dos caracteres.
-- @function new
function M:initialize(width, height)
  -- Inicializar superclasse:
  Sprite.initialize(self, width, height)

  --- *Set* de caracteres usados pela fonte.
  self.charset = ""

  --- Mapa de caracteres.
  self.charmap = nil

  --- Espaçamento entre os caracteres.
  self.charSpacing = 0

  --- Espaçamento entre as linhas.
  self.lineHeight = 0
end

----
-- Cria automaticamente um mapa de caracteres.
-- @param charset (***string***) *Set* de caracteres a ser mapeado.
-- @return O mapa de caracteres criado por este método.
function M:createCharmap(charset)
  -- O mapa de caracteres será criado nesta variável:
  local charmap = {}

  -- Criar mapa de caracteres com o modo Multi Sprite ativado...
  if self._multiSpriteEnabled == true then

    -- Percorrer e mapear todos os caracteres especificados no charset:
    for i = 1, #charset do
      local char = charset:sub(i, i)
      charmap[char] = {index = (i - 1)}
    end

  -- Criar mapa de caracteres normalmente...
  else

    -- Como a imagem contendo os caracteres é essencialmente uma spritesheet,
    -- é possível obter todos eles em formato de atlas de imagem:
    local imageAtlas = self:createImageAtlas()

    -- Percorrer e mapear todos os caracteres especificados no charset:
    for i = 1, #charset do
      local char = charset:sub(i, i)
      charmap[char] = imageAtlas[(i - 1)]
    end

  end

  return charmap
end

----
-- Define um *set* de caracteres a ser usado pela fonte.
-- @param charset (***string***) *Set* de caracteres a ser usado pela fonte.
function M:setCharset(charset)
  self.charset = charset
  self.charmap = self:createCharmap(charset)
end

----
-- Desenha um caractere da fonte na tela.
-- @param char (***string***) Caractere da fonte.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
function M:drawChar(char, x, y)
  if self.charmap[char] ~= nil then
    local charData = self.charmap[char]
    self:drawFrame(charData.index, x, y, true)
  end
end

----
-- Escreve o texto na tela.
-- @param x (***number***) Posição X do texto.
-- @param y (***number***) Posição Y do texto.
-- @param text (***string***) Texto.
function M:print(x, y, text)
  -- Linha e coluna iniciais:
  local row = 1
  local col = 1

  -- Ajustar opacidade:
  self:adjustOpacity()

  -- Desenhar o texto:
  if self.visible == true and self.opacity > 0.0 then

    -- Salvar o tamanho original dos caracteres...
    local originalWidth  = self.width
    local originalHeight = self.height

    -- ...e alterá-los com base na escala. Eles serão restaurados mais tarde:
    self.width  = math.abs(self.width  * self.scaleX)
    self.height = math.abs(self.height * self.scaleY)

    -- Percorrer todos os caracteres do texto para desenhá-los:
    for i = 1, #text do
      local char = text:sub(i, i)
      local charSpacing = self.charSpacing
      local lineHeight = self.lineHeight

      -- Ajustar o espaçamento entre as linhas (ignorando a primeira):
      if row == 0 then
        lineHeight = 0
      end

      -- Ajustar o espaçamento entre os caracteres (ignorando o primeiro):
      if col == 0 then
        charSpacing = 0
      end

      -- Desenhar o caractere:
      self:drawChar(
        char,
        x + ((  self.width  + charSpacing) * (col - 1)),
        y + ((  self.height + lineHeight) * (row - 1))
      )

      -- Quebrar uma linha ao encontrar o "\n":
      if char == "\n" then
        row = (row + 1)
        col  = 0
      end

      -- Ir para a próxima coluna:
      col = (col + 1)
    end

    -- Restaurar o tamanho original dos caracteres:
    self.width = originalWidth
    self.height = originalHeight

  end
end

return M
