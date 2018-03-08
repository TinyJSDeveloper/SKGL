--[[@meta]]
Sprite = {
	__index = Sprite,
	__name = "Sprite"
}

function Sprite:new(width, height)
	--[[@meta]]
	local this = {
		type = "Sprite",
		class = Sprite
	}

	this.scene           = nil
	this.parent          = nil
	this.x               = 0
	this.y               = 0
	this._x              = 0 -- (x:sync)
	this._y              = 0 -- (y:sync)
	this.width           = width  or 0
	this.height          = height or 0
	this.backgroundColor = nil
	this.image           = nil
	this.imageAtlas      = nil
	this.frame           = 1
	this.frames          = {0}
	this.bounds          = BoundingBox:new(this.width, this.height)
	this.opacity         = 1.0
	this._destroyed      = false -- (flag:destroy())

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
	- Define novas coordenadas X e Y para esta instância.
	- @param {number} x Posição X.
	- @param {number} y Posição Y.
	--]]
	function this:setPosition(x, y)
		self.x = x or 0
		self.y = y or 0
	end

	--[[
	- Define novas coordenadas X e Y para esta instância a partir de dados de
	- coordenada (podem ser de outra instância ou não).
	- @param {Object} positionData Dados de coordenadas (deve conter "x" e "y").
	--]]
	function this:setPositionData(positionData)
		self.x = positionData.x or 0
		self.y = positionData.y or 0
	end

	--[[
	- @return {Object} Obtém dados das coordenadas X e Y desta instância.
	- @param {boolean} center Se true, obtém a origem do centro da instância.
	--]]
	function this:getPosition(center)
		if center == true then
			return {
				x = self.x + (self.width  / 2),
				y = self.y + (self.height / 2)
			}
		else
			return {
				x = self.x,
				y = self.y
			}
		end
	end

	--[[
	- @return {Object} Cria automaticamente um mapa de sprites.
	- ]]
	function this:createImageAtlas()
		local imageAtlas = {}

		-- Obter número de linhas, colunas e total de frames da spritesheet:
		local rows = self:getImageHeight() / self.height
		local cols = self:getImageWidth() / self.width
		local count = rows * cols

		-- Índice do frame a ser inserido:
		local frameIndex = 0

		for row = 0, (rows - 1) do
			for col = 0, (cols - 1) do
				imageAtlas[frameIndex] = {
					x = self.width * col,
					y = self.height * row
				}

				frameIndex += 1
			end
		end

		return imageAtlas
	end

	--[[
	- Desenha a instância na tela.
	--]]
	function this:draw()
		if self.backgroundColor != nil then
			Surface.drawFillRect(self._x, self._y, self.width, self.height, self.backgroundColor, self.opacity)
		end

		if self.image != nil then
			-- Criar um mapa de sprites, caso não exista:
			if self.imageAtlas == nil then
				self.imageAtlas = self:createImageAtlas()
			end

			-- Ajustar o índice do frame atual, caso necessário:
			if self.frames[self.frame] == nil then
				self.frame = 1
			end

			-- Ajustar o nível de opacidade atual, caso necessário:
			if self.opacity < 0.0 then
				self.opacity = 0
			elseif self.opacity > 1.0 then
				self.opacity = 1
			end

			Surface.drawImagePartExtended(
				self.image,
				self._x,
				self._y,
				self.imageAtlas[self.frames[self.frame]].x,
				self.imageAtlas[self.frames[self.frame]].y,
				self.width,
				self.height,
				self.opacity
			)

			self.frame += 1
		end
	end

	--[[
	- Sincroniza o posicionamento relativo ao parente.
	--]]
	function this:sync()
		local parent = self.parent or {x = 0, y = 0}

		self._x = self.x + parent.x
		self._y = self.y + parent.y

		if self.bounds != nil then
			self.bounds:syncWith(self)
		end
	end

	--[[
	- Checagem de colisão entre uma lista de objetos.
	- @param {Object} colliders Lista de objetos.
	- @return Retorna o resultado da colisão.
	--]]
	function this:intersect(colliders)
		for key, value in pairs(colliders) do
			if self.bounds != nil and colliders.bounds != nil then
				self:sync()
				colliders:sync()

				return self.bounds:intersect(colliders.bounds)
			end

			return false
		end
	end

	--[[
	- Destrói esta instância.
	--]]
	function this:destroy()
		self._destroyed = true
		if self.scene != nil then
			self.scene:flagAsDestroyed({self})
		end
	end

	--[[
	- @return {boolean} Retorna se esta instância foi destruída.
	--]]
	function this:isDestroyed()
		return self._destroyed
	end

	--[[
	- @event
	--]]
	function this:update()
		-- [...]
	end

	return this
end
