----
-- Cena padrão de carregamento; apresenta um indicador de progresso na tela,
-- indicando quantos recursos já foram carregados.
--
-- O código desta cena pode ser usado como base para entender como fazer suas
-- próprias telas de carregamento. Com um objeto `skgl.AssetManager` e alguns
-- eventos, estas telas acabam sendo bem simples de fazer.
--
-- Dependencies: `skgl.Color`, `skgl.Scene`, `skgl.Surface`
-- @classmod skgl.LoadingScene
local Color = require("skgl.Color")
local Scene = require("skgl.Scene")
local Surface = require("skgl.Surface")
local M = Scene:subclass("skgl.LoadingScene")

----
-- Construtor da classe.
-- @param assets (`skgl.AssetManager`) Gerenciador de recursos.
-- @function new
function M:initialize(assets)
  -- Inicializar superclasse:
  Scene.initialize(self)

  --- Gerenciador de recursos.
  self.assets = assets

  --- Porcentagem real do indicador (de 0% a 100%).
  self.percentage = 0

  --- Preenchimento do indicador de progresso.
  self.fill = 0

  --- Velocidade de preenchimento do indicador de progresso.
  self.fillSpeed = 2

  --- Cores utilizadas pela cena.
  self.style = {
    background = Color:new(42, 42, 42),  -- Cor de fundo da tela (`#2A2A2A`).
    empty = Color:new(32, 32, 32),       -- Cor de fundo do indicador de progresso (`#202020`).
    fillTop = Color:new(0, 125, 255),    -- Cor de preenchimento superior do indicador de progresso (`#007DFF`).
    fillBottom = Color:new(36, 105, 179) -- Cor de preenchimento inferior do indicador de progresso (`#2469B3`).
  }

  -- Definir a cor de fundo da tela:
  self.color = self.style.background
end

----
-- Desenha o indicador de progresso no centro da tela.
function M:drawProgressBar()
  local fillWidth = (self.fill * 158) / 100

  Surface.drawFillRect(160, 128, 160, 16, self.style.empty, 1)
  Surface.drawFillRect(161, 129, fillWidth, 7, self.style.fillTop, 1)
  Surface.drawFillRect(161, 136, fillWidth, 7, self.style.fillBottom, 1)
end

----
-- (***@event***) Evento chamado a cada quadro.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:update(delta)
  -- Observar o carregamento dos recursos:
  self.assets:observe()

  -- Obter valor em porcentagem do progresso:
  self.percentage = self.assets:getPercentage()

  -- Preencher o indicador de progresso lentamente...
  if self.fill < self.percentage then
    self.fill = (self.fill + self.fillSpeed)

    if self.fill > self.percentage then
      self.fill = self.percentage
    end
  end

  self:drawProgressBar()
end

return M
