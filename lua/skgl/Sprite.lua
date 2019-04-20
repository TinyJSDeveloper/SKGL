----
-- Objeto gráfico animado a partir de uma *spritesheet*; é usado para
-- compor personagens e outros elementos interativos do jogo.
--
-- Devido à limitações do *ONELua*, este objeto não pode ser rotacionado,
-- escalado ou invertido. Para isso, habilite o modo *Multi Sprite*, um
-- modo especial deste objeto capaz de realizar estas funções, sob o custo do
-- uso de imagens separadas ao invés de uma *spritesheet*.
--
-- O *sprite* é a base de todos os demais objetos gráficos da biblioteca,
-- praticamente assumindo a posição de *god class*. Portanto, a referência
-- sobre o funcionamento dos demais objetos gráficos pode ser vista aqui.
--
-- Dependencies: `skgl.BoundingBox`, `skgl.Graphics`
-- @classmod skgl.Sprite
local class = require("middleclass")
local BoundingBox = require("skgl.BoundingBox")
local Graphics = require("skgl.Graphics")
local M = class("skgl.Sprite")

----
-- Construtor da classe.
-- @param width (***number***) Largura do *sprite*.
-- @param height (***number***) Altura do *sprite*.
-- @function new
function M:initialize(width, height)
  --- ID do sprite.   @todo Ainda não está funcionando e eu pessoalmente não sei se mexo na ordem do "new()" ou não.
  self.id = id or nil

  --- Parente do *sprite*. O posicionamento do *sprite* é relativo ao parente.
  self.parent = nil

  --- Cena do *sprite*.
  self.scene = nil

  --- Posição X.
  self.x = 0

  --- Posição Y.
  self.y = 0

  --- Posição X de origem (afeta a posição de desenho e da caixa de colisão).
  self.originX = 0

  --- Posição Y de origem (afeta a posição de desenho e da caixa de colisão).
  self.originY = 0

  --- Posição X relativa à original (*offset*).
  self.offsetX = 0

  --- Posição Y relativa à original (*offset*).
  self.offsetY = 0

  --- Velocidade do movimento horizontal (posição X).
  self.horizontalSpeed = 0

  --- Velocidade do movimento vertical (posição Y).
  self.verticalSpeed = 0

  --- Largura.
  self.width = width or 1

  --- Altura.
  self.height = height or 1

  --- Rotação.
  self.rotation = 0

  --- Escala horizontal do *sprite*.
  self.scaleX = 1

  --- Escala vertical do *sprite*.
  self.scaleY = 1

  --- *Spritesheet*.
  self.image = nil

  --- *Array* de imagens usadas pelo *sprite* em modo *Multi Sprite*. Cada imagem equivale a um *frame*.
  self.images = {}

  --- Atlas de imagens.
  self.imageAtlas = nil

  --- Cor de fundo (quando nulo, sua cor é transparente).
  self.color = nil

  --- Transparência (de 0.0 a 1.0).
  self.opacity = 1.0

  --- *Frame* de animação atual.
  self.frame = 1

  --- *Delay* até o próximo *frame* (de 0.0 até seu valor máximo).
  self.frameDelay = 0.0

  --- Tempo máximo de *delay* até o próximo *frame*.
  self.frameDelayMax = 10.0

  --- *Ticks* de *delay* de tempo por *frame*.
  self.frameDelayTick = 1.0

  --- *Frames* de animação disponíveis.
  self.frames = {}
  self.frames[1] = 0

  --- Nome da animação atual.
  self.animation = ""

  --- Catálogo de animações.
  self.animations = {}

  --- Visibilidade.
  self.visible = true

  --- Caixa de colisão.
  self.bounds = BoundingBox:new(self.width, self.height)

  --- Deslocamento horizontal do desenho do *sprite*.
  self.paddingX = 0

  --- Deslocamento vertical do desenho do *sprite*.
  self.paddingY = 0

  --- Indica se o modo *Multi Sprite* está ativado ou não.
  self._multiSpriteEnabled = false

  -- @private Indica se o sprite já foi criado.
  self._created = false

  -- @private Indica se o sprite foi destruído.
  self._destroyed = false

  -- @private Variação de tempo.
  self._delta = 0
end

---- Obtém a largura da imagem.
-- @return O valor descrito.
function M:getImageWidth()
  if self._multiSpriteEnabled == true and self.images[self:getFrame(self.frame) + 1] ~= nil then
    return Graphics.getImageWidth(self.images[self:getFrame(self.frame) + 1])
  elseif self.image ~= nil then
    return Graphics.getImageWidth(self.image)
  else
    return 0
  end
end

---- Obtém a altura da imagem.
-- @return O valor descrito.
function M:getImageHeight()
  if self._multiSpriteEnabled == true and self.images[self:getFrame(self.frame) + 1] ~= nil then
    return Graphics.getImageHeight(self.images[self:getFrame(self.frame) + 1])
  elseif self.image ~= nil then
    return Graphics.getImageHeight(self.image)
  else
    return 0
  end
end

---- Cria automaticamente um atlas de imagens.
-- @return O atlas de imagens criado por este método.
function M:createImageAtlas()
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

---- Indica se o *sprite* foi criado.
-- @return O valor descrito.
function M:isCreated()
  return self._created
end

---- Indica se o *sprite* foi destruído.
-- @return O valor descrito.
function M:isDestroyed()
  return self._destroyed
end

----
-- Destrói o *sprite*.
function M:destroy()
  -- Marcar o sprite para a exclusão:
  if not self._destroyed then
    self._destroyed = true

    -- Se estiver atrelado a um grupo, o grupo será notificado da exclusão:
    if self.parent ~= nil then
      self.parent:notifyDestruction(self)
    end
  end
end

----
-- Define configurações de modo *Multi Sprite*.
-- @param enabled (***boolean***) Ativar ou desativar o modo *Multi Sprite*.
function M:setMultiSprite(enabled)
  self._multiSpriteEnabled = enabled or false
end

----
-- Indica se o modo *Multi Sprite* está ativado ou não.
-- @return O valor descrito.
function M:isMultiSpriteEnabled()
  return self._multiSpriteEnabled
end

----
-- Obtém um *frame* de animação especificado; ou 0, caso não exista.
-- @param frame Índice do *frame*.
-- @return O valor descrito.
function M:getFrame(frame)
  if self.frames[frame] ~= nil then
    return self.frames[frame]
  else
    return 0
  end
end

----
-- Adiciona uma animação para este *sprite*.
-- @param name (***string***) Nome da animação.
-- @param frames (***{number}***) *Frames* de animação.
function M:addAnimation(name, frames)
  self.animations[name] = frames or {0}
end

----
-- Define uma animação para este *sprite*.
-- @param name (***string***) Nome da animação.
-- @param frame (***number***) *Frame* de animação (opcional).
function M:setAnimation(name, frame)
  self.animation = name or ""
  self.frames = self.animations[name] or {0}
  self.frame = frame or self.frame
end

----
-- Remove uma animação deste *sprite*.
-- @param name (***string***) Nome da animação.
function M:removeAnimation(name)
  local frames = self.animations[name]
  table.remove(self.animations, frames)
  return frames
end

----
-- Desenha uma retângulo colorido na tela. Cobre todas as dimensões do *sprite*.
-- @param color (`skgl.Color`) Cor.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param width (***number***) Largura do retângulo.
-- @param height (***number***) Altura do retângulo.
function M:drawColor(color, x, y, width, height)
  if self.color ~= nil then

    -- Desenhar um retângulo em volta do sprite:
    Graphics.rectangle.fill(
      x,
      y,
      width,
      height,
      self.color,
      self.opacity
    )

  end
end

----
-- Desenha um *frame* do *sprite* na tela.
-- @param frame (***number***) *Frame* do sprite.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param autoCenterOrigins (***boolean***) Quando ativado, centraliza as posições de origem da imagem automaticamente. O valor padrão é "`true`".
function M:drawFrame(frame, x, y, autoCenterOrigins)
  -- Desenhar frame com o modo Multi Sprite ativado...
  if self._multiSpriteEnabled == true and self.images[(frame + 1)] ~= nil then

    -- Desenhar o frame do sprite:
    Graphics.image.drawExtended(
      self.images[(frame + 1)],
      x + (self.width  / 2),
      y + (self.height / 2),
      self.scaleX,
      self.scaleY,
      self.rotation,
      self.opacity,
      autoCenterOrigins,
      self.originX,
      self.originY
    )

  -- Desenhar frame normalmente...
  elseif self.image ~= nil then

    -- Criar um atlas de imagens, caso não exista:
    if self.imageAtlas == nil then
      self.imageAtlas = self:createImageAtlas()
    end

    -- Desenhar o frame do sprite:
    if self.imageAtlas[frame] ~= nil then
      Graphics.image.partExtended(
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

----
-- Ajusta o índice do *frame* atual, caso necessário.
function M:adjustFrame()
  if self.frameDelay - 0.1 >= math.abs(self.frameDelayMax - self.frameDelayTick) and self.frames[self.frame + 1] == nil then
    self:onAnimationEnd()
  elseif self.frames[self.frame] == nil then
    self.frame = 1
  end
end

----
-- Define o controle dos *ticks* de *delay* usados para animar o *sprite*.
-- @param frameDelayTick (***number***) *Ticks* de *delay* de tempo por *frame*.
-- @param frameDelayMax (***number***) Tempo máximo de *delay* até o próximo *frame*.
function M:setFrameDelay(frameDelayTick, frameDelayMax)
  self.frameDelayTick = frameDelayTick or self.frameDelayTick
  self.frameDelayMax = frameDelayMax or self.frameDelayMax
end

----
-- Requisita o próximo *frame*.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:nextFrame(delta)
  -- Ao atingir o tempo de delay, o frame atual será incrementado...
  if self.frameDelay >= self.frameDelayMax then
    self.frameDelay = 0.0
    self.frame = (self.frame + 1)

  -- ...do contrário, o contador do delay incrementa seu tempo de espera:
  else
    self.frameDelay = (self.frameDelay + (self.frameDelayTick * delta))
  end
end

----
-- Ajusta o nível de Transparência atual, caso necessário.
function M:adjustOpacity()
  if self.opacity <= 0.0 then
    self.opacity = 0.0
  elseif self.opacity >= 1.0 then
    self.opacity = 1.0
  end
end

----
-- Redimensiona a caixa de colisão de acordo com os atributos de altura e
-- largura do *sprite*.
function M:resizeBounds()
  if self.bounds ~= nil then
    self.bounds.width = self.width
    self.bounds.height = self.height
  end
end

----
-- Ajusta/sincroniza o posicionamento da caixa de colisão do *sprite*.
function M:adjustBounds()
  if self.bounds ~= nil then
    self.bounds:adjustSize(self)
    self.bounds:adjustOffset(self)
  end
end

----
-- Ajusta o *offset* do *sprite*, sendo relativo ao parente.
function M:adjustOffset()
  -- Caso o sprite tenha um parente definido, seu posicionamento será
  -- relativo a ele...
  if self.parent ~= nil then
    self.offsetX = ((self.x + self.parent.x) - self.originX) + self.paddingX
    self.offsetY = ((self.y + self.parent.y) - self.originY) + self.paddingY

  -- ...do contrário, nada de posicionamento absoluto:
  else
    self.offsetX = (self.x) + self.paddingX
    self.offsetY = (self.y) + self.paddingY
  end
end

----
-- Aplica a velocidade dos movimentos horizontal e vertical.
function M:applySpeed()
  self:moveX(self.horizontalSpeed)
  self:moveY(self.verticalSpeed)
end

----
-- Checagem de colisão entre uma lista de *sprites* (colisores).
-- @param colliders ({`skgl.Sprite`}) Lista de *sprites* (colisores).
-- @return Uma lista com todos os objetos colididos; ou nada, caso nenhuma colisão tenha ocorrido.
function M:intersect(colliders)
  -- Resultado final. Seu valor inicial é "nil", mas pode ser alterado para
  -- uma lista no decorrer do código. Caso não seja, o valor "nil" é
  -- retornado, indicando que não houveram colisões.
  local results = nil

  -- Ajustar/sincronizar o offset e a caixa de colisão deste sprite:
  self:adjustOffset()
  self:adjustBounds()

  -- Percorrer todos os sprites contidos na lista...
  for key, value in pairs(colliders) do
    if self.bounds ~= nil and value.bounds ~= nil and self:isDestroyed() == false and value:isDestroyed() == false and value ~= self then

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

----
-- Checagem de colisão entre uma lista de *sprites* (colisores), mas
-- considerando estar em outra coordenada.
-- @param x (***number***) Posição X.
-- @param y (***number***) Posição Y.
-- @param colliders ({`skgl.Sprite`}) Lista de *sprites* (colisores).
-- @return Uma lista com todos os objetos colididos; ou nada, caso nenhuma colisão tenha ocorrido.
function M:intersectAt(x, y, colliders)
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

----
-- Checagem de colisão entre uma lista de *sprites* (colisores), mas
-- considerando estar em outra coordenada.
--
-- Diferente do método `skgl.Sprite:intersectAt()`, esta não leva em
-- consideração a caixa de colisão deste *sprite*, mas sim uma coordenada
-- absoluta.
-- @param x (***number***) Posição X.
-- @param y (***number***) Posição Y.
-- @param colliders ({`skgl.Sprite`}) Lista de *sprites* (colisores).
-- @return Uma lista com todos os objetos colididos; ou nada, caso nenhuma colisão tenha ocorrido.
function M:placeFreeAt(x, y, colliders)
  -- Salvar e zerar a caixa de colisão deste sprite temporariamente:
  local bounds = self.bounds
  self.bounds = nil

  -- Criar um sprite pequeno, usado para testar a coordenada especificada:
  local testSprite = Sprite:new(1, 1)
        testSprite.x = x
        testSprite.y = y

  -- Checar colisões e restaurar caixa de colisão original:
  local collisions = testSprite:intersect(colliders)
  self.bounds = bounds

  return collisions
end

----
-- Desenha o *sprite* na tela.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:draw(delta)
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

----
-- Obtém o valor resultante ao movimentar a posição X do *sprite* em um valor
-- relativo. Ao contrário da `skgl.Sprite:moveX()`, esta apenas retorna o valor
-- calculado, ou seja, não altera a posição do *sprite*.
-- @param value (***number***) Valor relativo ao movimento.
-- @return O valor descrito.
function M:getMoveX(value)
  return (self.x + (value * self:getDelta()))
end

----
-- Obtém o valor resultante ao movimentar a posição Y do *sprite* em um valor
-- relativo. Ao contrário da `skgl.Sprite:moveY()`, esta apenas retorna o valor
-- calculado, ou seja, não altera a posição do *sprite*.
-- @param value (***number***) Valor relativo ao movimento.
-- @return O valor descrito.
function M:getMoveY(value)
  return (self.y + (value * self:getDelta()))
end

----
-- Obtém o valor resultante ao movimentar o *sprite* em um ângulo especificado,
-- sob um valor relativo. Ao contrário da `skgl.Sprite:moveToAngle()`, esta
-- apenas retorna o valor calculado, ou seja, não altera a posição do *sprite*.
-- @param value (***number***) Valor relativo ao movimento.
-- @param angle (***number***) Ângulo de movimento (de 0 a 360 graus).
-- @return O valor descrito, em uma tabela com as propriedades *x* e *y*.
function M:getMoveToAngle(value, angle)
	return {
		x = self:getMoveX(value * math.cos(angle * (math.pi / 180))),
		y = self:getMoveY(value * math.sin(angle * (math.pi / 180)))
	}
end

----
-- Obtém o valor resultante ao rotacionar o *sprite*, fazendo-o olhar para um
-- ponto especificado. Ao contrário da `skgl.Sprite:rotateTo()`, esta apenas
-- retorna o valor calculado, ou seja, não altera a rotação do *sprite*.
-- @param x (***number***) Posição X do ponto.
-- @param x (***number***) Posição Y do ponto.
-- @return O valor descrito.
function M:getRotateTo(x, y)
  return (math.atan2(y - self.y, x - self.x)) * (180 / math.pi)
end

----
-- Obtém o valor resultante ao movimentar o *sprite* para um ponto
-- especificado, em um valor relativo. Ao contrário da `skgl.Sprite:moveTo()`,
-- esta apenas retorna o valor calculado, ou seja, não altera a posição do
-- *sprite*.
-- Movimenta o *sprite* para um ponto especificado, em um valor relativo.
-- @param x (***number***) Posição X do ponto.
-- @param x (***number***) Posição Y do ponto.
-- @param value (***number***) Valor relativo ao movimento.
-- @return O valor descrito, em uma tabela com as propriedades *x* e *y*.
function M:getMoveTo(x, y, value)
	return self:getMoveToAngle(value, self:getRotateTo(x, y))
end

----
-- Movimenta a posição X do *sprite* em um valor relativo.
-- @param value (***number***) Valor relativo ao movimento.
function M:moveX(value)
  self.x = (self.x + (value * self:getDelta()))
end

----
-- Movimenta a posição Y do *sprite* em um valor relativo.
-- @param value (***number***) Valor relativo ao movimento.
function M:moveY(value)
  self.y = (self.y + (value * self:getDelta()))
end

----
-- Movimenta o *sprite* em um ângulo especificado, sob um valor relativo.
-- @param value (***number***) Valor relativo ao movimento.
-- @param angle (***number***) Ângulo de movimento (de 0 a 360 graus).
function M:moveToAngle(value, angle)
	self:moveX(value * math.cos(angle * (math.pi / 180)))
	self:moveY(value * math.sin(angle * (math.pi / 180)))
end

----
-- Rotaciona o *sprite*, fazendo-o olhar para um ponto especificado.
-- @param x (***number***) Posição X do ponto.
-- @param x (***number***) Posição Y do ponto.
function M:rotateTo(x, y)
	self.rotation = (math.atan2(y - self.y, x - self.x)) * (180 / math.pi)
end

----
-- Movimenta o *sprite* para um ponto especificado, em um valor relativo.
-- @param x (***number***) Posição X do ponto.
-- @param x (***number***) Posição Y do ponto.
-- @param value (***number***) Valor relativo ao movimento.
function M:moveTo(x, y, value)
	self:moveToAngle(value, self:getRotateTo(x, y))
end

----
-- Obtém o valor da variação de tempo (*delta time*).
-- @return O valor descrito.
function M:getDelta()
  return self._delta
end

----
-- Define um valor para a variação de tempo (*delta time*).
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:setDelta(delta)
  self._delta = delta
end

----
-- Define valores para as posições de origem do *sprite*.
-- @param originX (***number***) Posição X de origem.
-- @param originY (***number***) Posição Y de origem.
function M:setOrigins(originX, originY)
  self.originX = originX or 0
  self.originY = originY or 0
end

----
-- Centraliza as posições de origem do *sprite* automaticamente.
function M:centerOrigins()
  self:setOrigins((self.width / 2), (self.height / 2))
end

----
-- Define valores para o tamanho do *sprite*.
-- @param width (***number***) Altura do *sprite*.
-- @param height (***number***) Largura do *sprite*.
function M:setSize(width, height)
  self.width = width or 1
  self.height = height or 1
end

----
-- Define valores para o tamanho em escala do *sprite*.
-- @param scaleX (***number***) Escala horizontal do *sprite*.
-- @param scaleY (***number***) Escala vertical do *sprite*.
function M:setScale(scaleX, scaleY)
  self.scaleX = scaleX or 0
  self.scaleY = scaleY or 0
end

----
-- Define valores para o deslocamento do desenho do *sprite*.
-- @param paddingX (***number***) Deslocamento horizontal do desenho do *sprite*.
-- @param paddingY (***number***) Deslocamento vertical do desenho do *sprite*.
function M:setPadding(paddingX, paddingY)
  self.paddingX = paddingX or 0
  self.paddingY = paddingY or 0
end

----
-- Determina se o *sprite* está dentro da tela ou não.
-- @return O valor descrito.
function M:isInsideScreen()
  return Graphics.isInsideScreen(self.offsetX, self.offsetY, self.width * math.abs(self.scaleX), self.height * math.abs(self.scaleY))
end

----
-- (***@event***) Evento chamado uma única vez, quando este objeto é criado e
-- "percorrido" durante a execução do jogo.
function M:onCreate()
end

----
-- (***@event***) Evento chamado a cada quadro.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:update(delta)
end

----
-- (***@event***) Evento chamado uma única vez, quando este objeto é destruído
-- durante a execução do jogo.
function M:onDestroy()
end

----
-- (***@event***) Evento chamado quando a animação atual termina.
function M:onAnimationEnd()
end

return M
