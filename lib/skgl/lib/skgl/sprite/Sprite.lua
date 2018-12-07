--[[@meta]]
Sprite = {
  name = "Sprite"
}

--[[
- @class Sprite
-
- @param {number} width Largura do sprite.
- @param {number} height Altura do sprite.
--]]
function Sprite.new(width, height)
  --[[@meta]]
  local def = {
    class = Sprite
  }

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Parente do sprite. O posicionamento do sprite é relativo ao parente.
    self.parent = nil

    -- Cena do sprite.
    self.scene = nil

    -- Posição X.
    self.x = 0

    -- Posição Y.
    self.y = 0

    -- Posição X de origem (afeta a posição de desenho e da caixa de colisão).
    self.originX = 0

    -- Posição Y de origem (afeta a posição de desenho e da caixa de colisão).
    self.originY = 0

    -- Posição X relativa à original (offset).
    self.offsetX = 0

    -- Posição Y relativa à original (offset).
    self.offsetY = 0

    -- Velocidade do movimento horizontal (posição X).
    self.horizontalSpeed = 0

    -- Velocidade do movimento vertical (posição Y).
    self.verticalSpeed = 0

    -- Largura.
    self.width = width or 1

    -- Altura.
    self.height = height or 1

    -- Rotação.
    self.rotation = 0

    -- Escala horizontal do sprite.
    self.scaleX = 1

    -- Escala vertical do sprite.
    self.scaleY = 1

    -- Spritesheet.
    self.image = nil

    -- Atlas de imagens.
    self.imageAtlas = nil

    -- Cor de fundo (quando nulo, sua cor é transparente).
    self.color = nil

    -- Opacidade (de 0.0 a 1.0).
    self.opacity = 1.0

    -- Frame de animação atual.
    self.frame = 1

    -- Delay até o próximo frame (de 0.0 até seu valor máximo).
    self.frameDelay = 0.0

    -- Tempo máximo de delay até o próximo frame.
    self.frameDelayMax = 10.0

    -- Ticks de delay de tempo por frame.
    self.frameDelayTick = 1.0

    -- Frames de animação disponíveis.
    self.frames = {0}

    -- Nome da animação atual.
    self.animation = ""

    -- Catálogo de animações.
    self.animations = {}

    -- Visibilidade.
    self.visible = true

    -- Caixa de colisão.
    self.bounds = BoundingBox.new(def.width, def.height)

    -- @private Indica se o sprite foi destruído.
    self._destroyed = false

    -- @private Variação de tempo.
    self._delta = 0
  end

  --[[
	- @return {number} Retorna a largura da imagem.
	--]]
	function def:getImageWidth()
		if self.image ~= nil then
			return Surface.getImageWidth(self.image)
		else
			return 0
		end
	end

	--[[
	- @return {number} Retorna a altura da imagem.
	--]]
	function def:getImageHeight()
		if self.image ~= nil then
			return Surface.getImageHeight(self.image)
		else
			return 0
		end
	end

  --[[
	- @return {Object} Cria automaticamente um atlas de imagens.
	- ]]
	function def:createImageAtlas()
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
  function def:isDestroyed()
    return self._destroyed
  end

  --[[
  - Destrói o sprite.
  --]]
  function def:destroy()
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
  function def:getFrame(frame)
    if self.frames[frame] ~= nil then
      return self.frames[frame]
    else
      return 0
    end
  end

  --[[
  - Adiciona uma animação para este sprite.
  -
  - @param {string} name Nome da animação.
  - @param {number[]} frames Frames Frames de animação.
  --]]
  function def:addAnimation(name, frames)
    self.animations[name] = frames or {0}
  end

  --[[
  - Define uma animação para este sprite.
  -
  - @param {string} name Nome da animação.
  - @param {number} frame Frame de animação (opcional).
  --]]
  function def:setAnimation(name, frame)
    self.animation = name or ""
    self.frames = self.animations[name] or {0}
    self.frame = frame or self.frame
  end

  --[[
  - Remove uma animação deste sprite.
  -
  - @param {string} name Nome da animação.
  --]]
  function def:removeAnimation(name)
    local frames = self.animations[name]
    table.remove(self.animations, frames)
    return frames
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
  function def:drawColor(color, x, y, width, height)
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
  function def:drawFrame(frame, x, y)
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
  function def:adjustFrame()
		if self.frames[self.frame] == nil then
			self.frame = 1
      self:animationEnded()
		end
  end

  --[[
  - Define o controle dos ticks de delay usados para animar o sprite.
  -
  - @param {number} frameDelayTick Ticks de delay de tempo por frame.
  - @param {number} frameDelayMax Tempo máximo de delay até o próximo frame.
  --]]
  function def:setFrameDelay(frameDelayTick, frameDelayMax)
    self.frameDelayTick = frameDelayTick or self.frameDelayTick
    self.frameDelayMax = frameDelayMax or self.frameDelayMax
  end

  --[[
  - Requisita o próximo frame.
  -
  - @param {number} delta Variação de tempo.
  --]]
  function def:nextFrame(delta)
    -- Ao atingir o tempo de delay, o frame atual será incrementado...
    if self.frameDelay >= self.frameDelayMax then
      self.frameDelay = 0.0
      self.frame = (self.frame + 1)

    -- ...do contrário, o contador do delay incrementa seu tempo de espera:
    else
      self.frameDelay = (self.frameDelay + (self.frameDelayTick * delta))
    end
  end

  --[[
  - Ajusta o nível de opacidade atual, caso necessário.
  --]]
  function def:adjustOpacity()
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
  function def:resizeBounds()
    if self.bounds ~= nil then
      self.bounds.width = self.width
      self.bounds.height = self.height
    end
  end

  --[[
  - Ajusta/sincroniza o posicionamento da caixa de colisão do sprite.
  --]]
  function def:adjustBounds()
    if self.bounds ~= nil then
      self.bounds:adjustOffset(self)
    end
  end

  --[[
  - Ajusta o offset do sprite, sendo relativo ao parente.
  --]]
  function def:adjustOffset()
    -- Caso o sprite tenha um parente definido, seu posicionamento será
    -- relativo a ele...
    if self.parent ~= nil then
      self.offsetX = (self.x + self.parent.x) - self.originX
      self.offsetY = (self.y + self.parent.y) - self.originY

    -- ...do contrário, nada de posicionamento absoluto:
    else
      self.offsetX = self.x
      self.offsetY = self.y
    end
  end

  --[[
  - Aplica a velocidade dos movimentos horizontal e vertical.
  --]]
  function def:applySpeed()
    self:moveX(self.horizontalSpeed)
    self:moveY(self.verticalSpeed)
  end

  --[[
	- Checagem de colisão entre uma lista de sprites (colisores).
  -
	- @param {Sprite[]} colliders Lista de sprites (colisores).
  -
	- @return {nil, Sprite[]} Retorna o resultado da colisão.
	--]]
	function def:intersect(colliders)
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
  - Checagem de colisão entre uma lista de sprites (colisores), mas
  - considerando estar em outra coordenada.
  -
  - @param {number} x Posição X.
  - @param {number} y Posição Y.
  - @param {Sprite[]} colliders Lista de sprites (colisores).
  -
	- @return {nil, Sprite[]} Retorna o resultado da colisão.
  --]]
  function def:intersectAt(x, y, colliders)
    -- Guardar as posições X e Y deste sprite. Elas serão restauradas depois:
    local originalX = self.x
    local originalY = self.y

    -- Mover o sprite para as posições especificadas:
    self.x = x
    self.y = y

    -- Obter resultados da colisão:
    local results = self:intersect(colliders)

    -- Restaurar as posições X e Y deste sprite:
    self.x = originalX
    self.y = originalY

    -- Ajustar/sincronizar offsets e caixas de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    return results
  end

  --[[
  - Checagem de colisão entre uma lista de sprites (colisores), mas
  - considerando estar em outra coordenada.
  -
  - Diferente da funçào "intersectAt()", esta não leva em consideração a caixa
  - de colisão deste sprite, mas sim uma coordenada absoluta.
  -
  - @param {number} x Posição X.
  - @param {number} y Posição Y.
  - @param {Sprite[]} colliders Lista de sprites (colisores).
  -
	- @return {nil, Sprite[]} Retorna o resultado da colisão.
  --]]
  function def:placeFreeAt(x, y, colliders)
    -- Salvar e zerar a caixa de colisão deste sprite temporariamente:
    local bounds = self.bounds
    self.bounds = nil

    -- Criar um sprite pequeno, usado para testar a coordenada especificada:
    local testSprite = Sprite.new(1, 1)
          testSprite.x = x
          testSprite.y = y

    -- Checar colisões e restaurar caixa de colisão original:
    local collisions = testSprite:intersect(colliders)
    self.bounds = bounds

    return collisions
  end

  --[[
  - Desenha o sprite na tela.
  -
  - @param {number} delta Variação de tempo.
  --]]
  function def:draw(delta)
    -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
    self:adjustOffset()
    self:adjustBounds()

    -- Ajustar frame e opacidade:
    self:adjustFrame()
    self:adjustOpacity()

    -- Aplicar as velocidades horizontal (posição X) e vertical (posição Y):
    self:applySpeed()

    -- Desenhar o sprite:
    if self.visible == true and self.opacity > 0.0 and self:isInsideScreen() == true then
      self:drawColor(self.color, self.offsetX, self.offsetY, self.width, self.height)
      self:drawFrame(self:getFrame(self.frame), self.offsetX, self.offsetY)
    end

    -- Requisitar o próximo frame:
    self:nextFrame(delta)
  end

  --[[
  - Obtém o valor resultante ao movimentar a posição X do sprite em um valor
  - relativo. Ao contrário da "moveX()", esta apenas retorna o valor calculado,
  - ou seja, não altera a posição do sprite.
  -
  - @param {number} value Valor relativo ao movimento.
  -
  - @return {number}
  --]]
  function def:getMoveX(value)
    return (self.x + (value * self:getDelta()))
  end

  --[[
  - Obtém o valor resultante ao movimentar a posição Y do sprite em um valor
  - relativo. Ao contrário da "moveY()", esta apenas retorna o valor calculado,
  - ou seja, não altera a posição do sprite.
  -
  - @param {number} value Valor relativo ao movimento.
  -
  - @return {number}
  --]]
  function def:getMoveY(value)
    return (self.y + (value * self:getDelta()))
  end

  --[[
  - Movimenta a posição X do sprite em um valor relativo.
  -
  - @param {number} value Valor relativo do movimento.
  --]]
  function def:moveX(value)
    self.x = (self.x + (value * self:getDelta()))
  end

  --[[
  - Movimenta a posição Y do sprite em um valor relativo.
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
  - Define valores para as posições de origem do sprite.
  -
  - @param {number} originX Posição X de origem.
  - @param {number} originY Posição Y de origem.
  --]]
  function def:setOrigins(originX, originY)
    self.originX = originX or 0
    self.originY = originY or 0
  end

  --[[
  - Centraliza as posições de origem do sprite automaticamente.
  --]]
  function def:centerOrigins()
    self:setOrigins((self.width / 2), (self.height / 2))
  end

  --[[
  - Define valores para o tamanho em escala do sprite.
  -
  - @param {number} scaleX Escala horizontal do sprite.
  - @param {number} scaleY Escala vertical do sprite.
  --]]
  function def:setScale(scaleX, scaleY)
    self.scaleX = scaleX or 0
    self.scaleY = scaleY or 0
  end

  --[[
  - Determina se o sprite está dentro da tela.
  -
  - @return {boolean}
  --]]
  function def:isInsideScreen()
    return Surface.isInsideScreen(self.offsetX, self.offsetY, self.width * math.abs(self.scaleX), self.height * math.abs(self.scaleY))
  end

  --[[
  - @event
  - @param {number} delta Variação de tempo.
  --]]
  function def:update(delta)
  end

  --[[
  - @event
  --]]
  function def:animationEnded()
  end

  def:__init__()
  return def
end
