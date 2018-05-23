--[[@meta : @extends Array]]
Scene = {
  name = "Scene",
  extends = Array
}

function Scene.new()
  --[[@meta : @extends Array]]
  local _self = Array.new()
  _self.class = Scene

  -- Posição X da câmera.
  _self.cameraX = 0

  -- Posição Y da câmera.
  _self.cameraY = 0

  -- Dimensão de largura do cenário (usado pela câmera).
  _self.width = 0

  -- Dimensão de altura do cenário (usado pela câmera).
  _self.height = 0

  -- Cor de fundo (quando nulo, sua cor é transparente).
  _self.color = nil

  -- Opacidade (de 0.0 a 1.0). Vale apenas para a cor de fundo.
  _self.opacity = 1.0

  --[[
  - Renderiza a cena na tela.
  --]]
  function _self:render()
    -- Desenhar a cor de fundo:
    self:drawBackground((self.color):retrieve(), self.opacity)

    -- Percorrer todos os sprites...
    self:foreach(function(key, value, index)
      value.parent = self

      -- Executar evento de "update" e desenhar o conteúdo do grupo na tela...
      self:adjustCamera(value)
      value:draw()
    end)
  end

  --[[
  - Desenha uma cor de fundo para a cena.
  -
  - @param {Color} color Cor.
  - @param {number} opacity Transparência (de 0.0 a 1.0).
  --]]
  function _self:drawBackground(color, opacity)
    if self.color ~= nil then
      Display.setBackgroundColor(color, opacity)
    end
  end

  --[[
  - Ajusta a câmera para um grupo especificado.
  -
  - @param {Group} group Grupo.
  --]]
  function _self:adjustCamera(group)
    -- Obter as posições X e Y do centro da tela:
    local centerX = (Display.getWidth()  / 2)
    local centerY = (Display.getHeight() / 2)

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

  return _self
end
