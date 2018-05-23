--[[@meta]]
Sprite = {
  name = "Sprite"
}

function Sprite.new(width, height)
  --[[@meta]]
  local _self = {
    class = Sprite
  }

  -- Parente do sprite. O posicionamento do sprite é relativo ao parente.
  _self.parent = nil

  -- Posição X.
  _self.x = 0

  -- Posição Y.
  _self.y = 0

  -- Posição X relativa à original (offset).
  _self.offsetX = 0

  -- Posição Y relativa à original (offset).
  _self.offsetY = 0

  -- Largura.
  _self.width = width or 0

  -- Altura.
  _self.height = height or 0

  -- Spritesheet.
  _self.image = nil

  -- Atlas de imagens.
  _self.imageAtlas = nil

  -- Cor de fundo (quando nulo, sua cor é transparente).
  _self.color = nil

  -- Opacidade (de 0.0 a 1.0).
  _self.opacity = 1.0

  -- Frame de animação atual.
  _self.frame = 1

  -- Delay até o próximo frame (de 0.0 até 1.0).
  _self.frameDelay = 0.0

  -- Frames de animação disponíveis.
  _self.frames = {0}

  -- Visibilidade.
  _self.visible = true

  -- Caixa de colisão.
  _self.bounds = BoundingBox.new(_self.width, _self.height)

  -- @private Indica se o sprite foi destruído.
  _self._destroyed = false

  --[[
	- @return {number} Retorna a largura da imagem.
	--]]
	function _self:getImageWidth()
		if self.image ~= nil then
			return Surface.getImageWidth(self.image)
		else
			return 0
		end
	end

	--[[
	- @return {number} Retorna a altura da imagem.
	--]]
	function _self:getImageHeight()
		if self.image ~= nil then
			return Surface.getImageHeight(self.image)
		else
			return 0
		end
	end

  --[[
	- @return {Object} Cria automaticamente um atlas de imagens.
	- ]]
	function _self:createImageAtlas()
    -- O atlas de imagens será criado nesta variável:
    local imageAtlas = {}

		-- Obter número de linhas, colunas e total de frames da spritesheet:
		local rows = self:getImageHeight() / self.height
		local cols = self:getImageWidth() / self.width
		local count = rows * cols

		-- Índice do frame a ser inserido:
		local frameIndex = 0

    -- Iterar sobre o número de linhas e colunas...
		for row = 0, (rows - 1) do
			for col = 0, (cols - 1) do

        -- ...e mapear o frame correspondente em um índice:
				imageAtlas[frameIndex] = {
          index = frameIndex,
					x = self.width * col,
					y = self.height * row
				}

				frameIndex = (frameIndex + 1)
			end
		end

		return imageAtlas
	end

  --[[
  - @return {boolean} Indica se o sprite foi destruído.
  --]]
  function _self:isDestroyed()
    return self._destroyed
  end

  --[[
  - Destrói o sprite.
  --]]
  function _self:destroy()
    -- Marcar o sprite para a exclusão:
    if not self._destroyed then
      self._destroyed = true

      -- Se estiver atrelado a um grupo, o grupo será notificado da exclusão:
      if self.parent ~= nil then
        self.parent:notifyDestruction(self)
      end
    end
  end

  --[[
  - @return {number} Obtém um frame de animação especificado. Caso não exista,
  - o valor retornado será 0.
  -
  - @param {number} frame Índice do frame.
  --]]
  function _self:getFrame(frame)
    if self.frames[frame] ~= nil then
      return self.frames[frame]
    else
      return 0
    end
  end

  --[[
  - Desenha uma retângulo colorido na tela. Cobre todas as dimensões do sprite.
  -
  - @param {Color} color Cor.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  - @param {number} width Largura do retângulo.
  - @param {number} height Altura do retângulo.
  --]]
  function _self:drawColor(color, x, y, width, height)
    if self.color ~= nil then

      -- Desenhar um retângulo em volta do sprite:
      Surface.drawFillRect(
        x,
        y,
        width,
        height,
        (self.color):retrieve(),
        self.opacity
      )

    end
  end

  --[[
  - Desenha um frame do sprite na tela.
  -
  - @param {number} frame Frame do sprite.
  - @param {number} x Posição X de desenho.
  - @param {number} y Posição Y de desenho.
  --]]
  function _self:drawFrame(frame, x, y)
    if self.image ~= nil then

      -- Criar um atlas de imagens, caso não exista:
			if self.imageAtlas == nil then
				self.imageAtlas = self:createImageAtlas()
			end

      -- Desenhar o frame do sprite:
      if self.imageAtlas[frame] ~= nil then
        Surface.drawImagePartExtended(
          self.image,
          x,
          y,
          self.imageAtlas[frame].x,
          self.imageAtlas[frame].y,
          self.width,
          self.height,
          self.opacity
        )
      end

    end
  end

  --[[
  - Ajusta o índice do frame atual, caso necessário.
  --]]
  function _self:adjustFrame()
		if self.frames[self.frame] == nil then
			self.frame = 1
		end
  end

  --[[
  - Requisita o próximo frame.
  --]]
  function _self:nextFrame()
    -- Ao atingir o tempo de delay, o frame atual será incrementado...
    if self.frameDelay >= 1.0 then
      self.frameDelay = 0.0
      self.frame = (self.frame + 1)

    -- ...do contrário, o contador do delay incrementa seu tempo de espera:
    else
      self.frameDelay = (self.frameDelay + 0.1)
    end
  end

  --[[
  - Ajusta o nível de opacidade atual, caso necessário.
  --]]
  function _self:adjustOpacity()
		if self.opacity <= 0.0 then
			self.opacity = 0.0
    elseif self.opacity >= 1.0 then
			self.opacity = 1.0
		end
  end

  --[[
  - Redimensiona a caixa de colisão de acordo com os atributos de altura e
  - largura do sprite.
  --]]
  function _self:resizeBounds()
    if self.bounds ~= nil then
      self.bounds.width = self.width
      self.bounds.height = self.height
    end
  end

  --[[
  - Ajusta/sincroniza o posicionamento da caixa de colisão do sprite.
  --]]
  function _self:adjustBounds()
    if self.bounds ~= nil then
      self.bounds:adjustOffset(self)
    end
  end

  --[[
  - Ajusta o offset do sprite, sendo relativo ao parente.
  --]]
  function _self:adjustOffset()
    -- Caso o sprite tenha um parente definido, seu posicionamento será
    -- relativo a ele...
    if self.parent ~= nil then
      self.offsetX = (self.x + self.parent.x)
      self.offsetY = (self.y + self.parent.y)

    -- ...do contrário, nada de posicionamento absoluto:
    else
      self.offsetX = self.x
      self.offsetY = self.y
    end
  end

  --[[
	- Checagem de colisão entre uma lista de sprites (colisores).
  -
	- @param {Sprite[]} colliders Lista de sprites (colisores).
	- @return {boolean} Retorna o resultado da colisão.
	--]]
	function _self:intersect(colliders)
    -- Resultado final. Seu valor inicial é "nil", mas pode ser alterado para
    -- uma lista no decorrer do código. Caso não seja, o valor "nil" é
    -- retornado, indicando que não houveram colisões.
    local results = nil

    -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    -- Percorrer todos os sprites contidos na lista...
		for key, value in pairs(colliders) do
			if self.bounds ~= nil and value.bounds ~= nil and value ~= self then

        -- Ajustar/sincronizar offsets e caixas de colisão do sprite colisor:
        value:adjustOffset()
        value:adjustBounds()

        -- Checagem de colisão:
				if self.bounds:intersect(value.bounds) == true then

          -- Quando ao menos uma colisão ocorre, o resultado final é alterado
          -- para uma lista contendo todos os sprites colididos...
          if results == nil then
            results = {}
          end

          -- ...e o sprite checado é adicionado à lista:
          table.insert(results, value)
				end

			end
		end

		return results
	end

  --[[
  - Desenha o sprite na tela.
  --]]
  function _self:draw()
    -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    -- Ajustar frame e opacidade:
    self:adjustFrame()
    self:adjustOpacity()

    -- Desenhar o sprite:
    if self.visible == true and self.opacity > 0.0 then
      self:drawColor(self.color, self.offsetX, self.offsetY, self.width, self.height)
      self:drawFrame(self:getFrame(self.frame), self.offsetX, self.offsetY)
    end

    -- Requisitar o próximo frame:
    self:nextFrame()
  end

  --[[
  - @event
  --]]
  function _self:update()
  end

  return _self
end
