--[[@meta : @extends Array]]
Scene = {
  name = "Scene",
  extends = Array
}
--[[
- @class Scene @extends Array
-
- @param {number} width Largura do cenário (usado pela câmera).
- @param {number} height Altura do cenário (usado pela câmera).
--]]
function Scene.new(width, height)
  --[[@meta : @extends Array]]
  local def = Array.new()
  def.class = Scene

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Posição X da câmera.
    self.cameraX = 0

    -- Posição Y da câmera.
    self.cameraY = 0

    -- Dimensão de largura do cenário (usado pela câmera).
    self.width = width or Display.getWidth()

    -- Dimensão de altura do cenário (usado pela câmera).
    self.height = height or Display.getHeight()

    -- Cor de fundo (quando nulo, sua cor é transparente).
    self.color = nil

    -- Opacidade (de 0.0 a 1.0). Vale apenas para a cor de fundo.
    self.opacity = 1.0
  end

  --[[
  - Renderiza a cena na tela.
  -
  - @param {number} delta Variação de tempo.
  --]]
  function def:render(delta)
    -- Desenhar a cor de fundo, caso tenha sido definida:
    if self.color ~= nil then
      self:drawBackground((self.color):retrieve(), self.opacity)
    end

    -- Percorrer todos os sprites...
    self:foreach(function(key, value, index)
      value.parent = self

      -- Executar evento de "update" e desenhar o conteúdo do grupo na tela...
      self:adjustCamera(value)
      value:setDelta(delta)
      value:draw(delta)
      value:update(delta)
    end)

    -- Executar evento de "update":
    self:update(delta)
  end

  --[[
  - Desenha uma cor de fundo para a cena.
  -
  - @param {Color} color Cor.
  - @param {number} opacity Transparência (de 0.0 a 1.0).
  --]]
  function def:drawBackground(color, opacity)
    if self.color ~= nil then
      Display.setBackgroundColor(color, opacity)
    end
  end

  --[[
  - Ajusta a câmera para um grupo especificado.
  -
  - @param {Group} group Grupo.
  --]]
  function def:adjustCamera(group)
    -- Calcular posicionamento de ajuste da tela do console:
    local displayWidth  = Display.getWidth()  + Display.getX()
    local displayHeight = Display.getHeight() + Display.getY()

    -- Obter as posições X e Y do centro da tela:
    local centerX = (displayWidth  / 2) - Display.getX()
    local centerY = (displayHeight / 2) - Display.getY()

    -- Posicionamento de scroll (X):
    if group.scrollHorizontally == true then

      -- Quando estiver muito para a esquerda...
      if self.cameraX < centerX then
        self.cameraX = centerX
      end

      -- Quando estiver muito para a direita...
      if self.cameraX > (self.width - centerX) then
        self.cameraX = (self.width - centerX)
      end

      -- Movimento parallax X rápido (útil para foregrounds):
      if group.parallax > 0 then
        group.x = -(((self.cameraX) + centerX) * group.parallax)

      -- Movimento X padrão:
      elseif group.parallax == 0 then
        group.x = -(self.cameraX) + centerX

      -- Movimento parallax X lento (útil para backgrounds):
      elseif group.parallax < 0 then
        group.x = -(((self.cameraX) + centerX) / group.parallax)
      end

    end

    -- Posicionamento de scroll (Y):
    if group.scrollVertically == true then

      -- Quando estiver muito para cima...
      if self.cameraY < centerY then
        self.cameraY = centerY
      end

      -- Quando estiver muito para baixo...
      if self.cameraY > (self.height - centerY) then
        self.cameraY = (self.height - centerY)
      end

      -- Movimento parallax Y rápido (útil para foregrounds):
      if group.parallax > 0 then
        group.y = -(((self.cameraY) + centerY) * group.parallax)

      -- Movimento Y padrão:
      elseif group.parallax == 0 then
        group.y = -(self.cameraY) + centerY

      -- Movimento parallax Y lento (útil para backgrounds):
      elseif group.parallax < 0 then
        group.y = -(((self.cameraY)	+ centerY) / group.parallax)
      end

    end

  end

  --[[
  - Focaliza a câmera para exibir uma determinada posição.
  -
  - @param {number} x Posição X da câmera.
  - @param {number} y Posição Y da câmera.
  --]]
  function def:lookAt(x, y)
    self.cameraX = x or self.cameraX
    self.cameraY = y or self.cameraY
  end

  --[[
  - @event
  - @param {number} delta Variação de tempo.
  --]]
  function def:update(delta)
  end

  def:__init__()
  return def
end
