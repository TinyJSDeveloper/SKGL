----
-- Abstração do `timer` do *ONELua*; pode ser usado para calcular o
-- tempo de execução de um jogo, a taxa de quadros por segundo (FPS) ou a
-- variação de tempo (*delta time*).
--
-- @classmod skgl.Clock
local class = require("middleclass")
local M = class("skgl.Clock")

----
-- Construtor da classe.
-- @function new
function M:initialize()
  -- @private Cronômetro (timer do ONELua).
  self._cronometer = timer.new()

  -- @private Último tempo salvo cronometrado.
  self._savedTime = 0
end

----
-- Inicia o cronômetro.
-- @return O tempo em que foi iniciado (em milissegundos).
function M:start()
  return timer.start(self._cronometer)
end

----
-- Para o cronômetro.
-- @return O tempo em que foi parado (em milissegundos).
function M:stop()
  return timer.stop(self._cronometer)
end

----
-- Reinicia o cronômetro.
-- @return Retorna o tempo em que foi reiniciado (em milissegundos).
function M:reset()
  return timer.reset(self._cronometer)
end

----
-- Obtém o tempo atual do cronômetro.
-- @return {number} O tempo atual (em milissegundos).
function M:getTime()
  return timer.time(self._cronometer)
end

----
-- Salva o tempo atual.
-- @return O tempo salvo (em milissegundos).
function M:save()
  self._savedTime = self:getTime()
  return self._savedTime
end

----
-- Limpa todo o cronômetro, reiniciando o cronômetro e zerando o tempo salvo.
function M:clear()
  self.savedTime = 0
  self:reset()
end

----
-- Obtém a referência do cronômetro, isto é, o `timer` do *ONELua*.
-- @return O valor descrito.
function M:getCronometer()
  return self._cronometer
end

----
-- Obtém o tempo salvo cronometrado.
function M:getSavedTime()
  return self._savedTime
end

----
-- Obtém o total de tempo passado (em milissegundos). Utiliza como base o
-- último tempo salvo cronometrado e o tempo atual do cronômetro.
function M:getElapsedTime()
  return self:getTime() - self._savedTime
end

return M
