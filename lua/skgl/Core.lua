----
-- Parte central do jogo; as cenas, os controles, os recursos usados pelo jogo
-- e o *game loop* são todos gerenciados aqui.
--
-- Dependencies: `skgl.Array`, `skgl.AssetManager`,  `skgl.Clock`, `skgl.Input`
-- @classmod skgl.Core
local class = require("middleclass")
local Array = require("skgl.Array")
local AssetManager = require("skgl.AssetManager")
local Clock = require("skgl.Clock")
local Input = require("skgl.Input")
local M = class("skgl.Core")

----
-- Construtor da classe.
-- @function new
function M:initialize()
  --- Gerenciador de recursos usados pelo jogo (*sprites*, sons, etc).
  self.assets = AssetManager:new()

  --- Cena-raíz.
  self.rootScene = nil

  --- Cena atual em uso.
  self.currentScene = nil

  --- Eventos de entrada.
  self.input = Input:new()

  -- @private Cenas.
  self._scenes = Array:new()

  -- @private Cronômetro responsável por controlar a taxa de quadros do jogo.
  self._clock = Clock:new()
  self._clock:start()
end

----
-- Obtém a cena-raíz, isto é, a primeira cena inserida na lista.
-- @return O valor descrito.
function M:getRootScene()
  return self._scenes:get(0)
end

----
-- Obtém a cena atual em uso, isto é, a última cena inserida na lista.
-- @return O valor descrito.
function M:getCurrentScene()
  local lastIndex = self._scenes:length() - 1
  return self._scenes:get(lastIndex)
end

----
-- Substitui a cena atual por outra.
-- @param scene (`skgl.Scene`) Cena a ser substituída.
function M:replaceScene(scene)
  local lastIndex = self._scenes:length() - 1

  if lastIndex < 0 then
    self._scenes:push(scene)
  else
    self._scenes:set(lastIndex, scene)
  end
end

----
-- Remove uma cena da lista.
-- @param scene (`skgl.Scene`) Cena.
function M:removeScene(scene)
  self._scenes:removeItems({scene})
end

----
-- Insere uma nova cena na lista. Ela também se tornará a cena atual em uso.
-- @param scene (`skgl.Scene`) Cena.
function M:pushScene(scene)
  self._scenes:push(scene)
end

----
-- Remove a cena atual em uso da lista. Se existir uma cena no índice anterior,
-- esta assumirá o seu lugar.
function M:popScene()
  self._scenes:pop()
end

----
-- Executa o *game loop*.
function M:loop()
  -- Obter tempo atual e o tempo salvo no frame anterior:
  local newTime = self._clock:getTime()
  local oldTime = self._clock:getSavedTime()

  -- Obter o valor da variação de tempo:
  local delta = newTime - oldTime
  local sceneDelta = 1

  -- Iniciar o cronômetro e salvar o tempo cronometrado até agora:
  self._clock:start()
  self._clock:save()

  -- Obter a cena atual em uso e ler teclas:
  self.rootScene = self:getRootScene()
  self.currentScene = self:getCurrentScene()

  -- Ler teclas:
  Input:read()

  -- executar evento de "update" e renderizar a cena:
  self:update(sceneDelta)
  self.currentScene:render(sceneDelta)
end

----
-- Desenha todo o conteúdo gerado no decorrer do código, finalizando um *frame*.
-- É essencialmente o mesmo método presente na `skgl.Surface`.
function M:flip()
  screen.flip()
end

----
-- (***@event***) Evento chamado a cada quadro.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:update(delta)
end

return M
