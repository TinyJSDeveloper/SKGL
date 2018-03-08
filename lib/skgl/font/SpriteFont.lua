--[[@meta]]
SpriteFont = {
	__index = SpriteFont,
	__name = "SpriteFont"
}

function SpriteFont:new(width, height)
	--[[@meta]]
	local this = {
		type = "SpriteFont",
		class = SpriteFont
	}

	this.x       = 0
	this.y       = 0
	this.width   = width  or 0
	this.height  = height or 0
	this.image   = nil
	this.charSet = "abcdefghijklmnopqrstuvwxyz0123456789?!.,"
	this.charMap = nil
	this.opacity = 1.0

	--[[
	- @return {number} Retorna a largura da imagem.
	--]]
	function this:getImageWidth()
		if self.image != nil then
			return Surface.getImageWidth(self.image)
		else
			return 0
		end
	end

	--[[
	- @return {number} Retorna a altura da imagem.
	--]]
	function this:getImageHeight()
		if self.image != nil then
			return Surface.getImageHeight(self.image)
		else
			return 0
		end
	end

	--[[
	- @return {Object} Cria automaticamente um mapa de sprites.
	- ]]
	function this:createCharMap()
		local indexedCharMap = {}
		local charMap = {}

		-- Obter número de linhas, colunas e total de caracteres da spritesheet:
		local rows = self:getImageHeight() / self.height
		local cols = self:getImageWidth() / self.width
		local count = rows * cols

		-- Índice do caractere a ser indexado:
		local charIndex = 0

		for row = 0, (rows - 1) do
			for col = 0, (cols - 1) do
				indexedCharMap[charIndex] = {
					x = self.width * col,
					y = self.height * row
				}

				charIndex += 1
			end
		end

		-- CharSet usado, todos os caracteres serão inseridos em uma lista:
		local charSet = self.charSet

		for i = 1, #charSet do
			local char = charSet:sub(i, i)
			charMap[char] = indexedCharMap[(i - 1)]
		end

		return charMap
	end

	--[[
	- Desenha um caractere na tela.
	- @param {number} x Posição X de desenho.
	- @param {number} y Posição Y de desenho.
	- @param {string} char Caractere (deve existir no mapa de caracteres).
	--]]
	function this:drawChar(x, y, char)
		if self.charMap[char] != nil then
			local charData = self.charMap[char]

			Surface.drawImagePartExtended(self.image,
				x,
				y,
				self.charMap[char].x,
				self.charMap[char].y,
				self.width,
				self.height,
				self.opacity
			)
		end
	end

	--[[
	- Escreve um texto na tela.
	- @param {number} x Posição X do texto.
	- @param {number} y Posição Y do texto.
	- @param {string} text Texto a ser renderizado.
	--]]
	function this:print(x, y, text)
		if self.image != nil then
			-- Criar um mapa de caracteres, caso não exista:
			if self.charMap == nil then
				self.charMap = self:createCharMap()
			end

			-- Ajustar o nível de opacidade atual, caso necessário:
			if self.opacity < 0.0 then
				self.opacity = 0
			elseif self.opacity > 1.0 then
				self.opacity = 1
			end

			-- Linha e coluna atual do caractere a ser renderizado:
			local row = 1
			local col = 1

			for i = 1, #text do
				local char = text:sub(i, i)
				self:drawChar(self.x + (width * col), self.y + (height * row), char)

				-- Quebrar uma linha ao encontrar o "\n":
				if char == "\n" then
					row += 1
					col  = 0
				end

				-- Ir para a próxima coluna:
				col += 1
			end
		end
	end

  return this
end
