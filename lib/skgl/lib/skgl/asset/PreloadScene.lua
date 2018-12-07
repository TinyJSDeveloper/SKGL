--[[@meta : @extends Scene]]
PreloadScene = {
  name = "PreloadScene",
  extends = Scene
}

--[[
- @class PreloadScene @extends Scene
--]]
function PreloadScene.new(manager)
  --[[@meta : @extends Scene]]
  local def = Scene.new()
  def.class = PreloadScene

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Gerenciador de recursos.
    self.manager = manager

    -- Propriedades da barra de carregamento.
    self.bar = {
      width = 300,
      height = 16,
      colorA = Color.new(255, 255, 255),
      colorB = Color.new(0, 0, 0)
    }

    -- Indicador de progresso (0-100%).
    self.progress = 0

    -- Velocidade que a barra de progresso leva para ser preenchida.
    self.fillSpeed = 1

    -- @private Auxiliar do indicador de progresso que é preenchido lentamente.
    self._filledProgress = 0

    -- @private Indica se o catálogo do gerenciador já foi carregado.
    self._ready = false
  end

  --[[
  - Desenha a barra de carregamento.
  --]]
  function def:drawBar()
    -- Dados de posicionamento/cor da barra de carregamento:
    local barX = (Display.getDeviceWidth()  / 2) - (self.bar.width  / 2)
    local barY = (Display.getDeviceHeight() / 2) - (self.bar.height / 2)
    local barWidth = self.bar.width
    local barHeight = self.bar.height
    local barColorA = self.bar.colorA:retrieve()
    local barColorB = self.bar.colorB:retrieve()
    local fillWidth = (self._filledProgress * (barWidth-4)) / 100

    -- Desenhar a base da barra de carregamento:
    Surface.drawFillRect(barX,barY,barWidth,barHeight,barColorA,1)
    Surface.drawFillRect(barX+1,barY+1,barWidth-2,barHeight-2,barColorB,1)

    -- Preencher barra de carregamento:
    if self._filledProgress > 0 then
      Surface.drawFillRect(barX+2,barY+2,fillWidth,barHeight-4,barColorA,1)
    end
  end

  --[[
  - @event
  - @param {number} delta Variação de tempo.
  --]]
  function def:update(delta)
    -- Observar o carregamento dos recursos:
    self.manager:observe()

    -- Calcular porcentagem indicativa do progresso:
    self.progress = (self.manager:readyCount() / self.manager:length()) * 100

    -- Preencher progresso lentamente...
    if self._filledProgress < self.progress then
      self._filledProgress = (self._filledProgress + self.fillSpeed)

      -- ...sem exceder a valor de progresso real:
      if self._filledProgress > self.progress then
        self._filledProgress = self.progress
      end
    end

    -- Desenhar a barra de carregamento:
    self:drawBar()
  end

  --[[
  - Indica se o catálogo do gerenciador já foi carregado.
  -
  - @return {boolean}
  --]]
  function def:isReady()
    return (self.manager):isReady()
  end

  def:__init__()
  return def
end
