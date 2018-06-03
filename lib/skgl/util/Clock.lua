--[[@meta]]
Clock = {
  name = "Clock"
}

--[[
- @class Clock
--]]
function Clock.new()
  --[[@meta]]
  local def = {
    class = Clock
  }

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- @private Cronômetro (timer do ONELua).
    self._cronometer = timer.new()

    -- @private Último tempo salvo cronometrado.
    self._savedTime = 0
  end

  --[[
  - Inicia o cronômetro.
  -
  - @return {number} Retorna o tempo que foi iniciado (em milissegundos).
  --]]
  function def:start()
    return timer.start(self._cronometer)
  end

  --[[
  - Para o cronômetro.
  -
  - @return {number} Retorna o tempo que foi parado (em milissegundos).
  --]]
  function def:stop()
    return timer.stop(self._cronometer)
  end

  --[[
  - Reinicia o cronômetro.
  -
  - @return {number} Retorna o tempo que foi reiniciado (em milissegundos).
  --]]
  function def:reset()
    return timer.reset(self._cronometer)
  end

  --[[
  - Obtém o tempo atual do cronômetro.
  -
  - @return {number} Retorna o tempo atual (em milissegundos).
  --]]
  function def:getTime()
    return timer.time(self._cronometer)
  end

  --[[
  - Salva o tempo atual.
  -
  - @return {number} Retorna o tempo salvo (em milissegundos).
  --]]
  function def:save()
    self._savedTime = self:getTime()
    return self._savedTime
  end

  --[[
  - Limpa todo o cronômetro, reiniciando o cronômetro e zerando o tempo salvo.
  --]]
  function def:clear()
    self.savedTime = 0
    self:reset()
  end

  --[[
  - Obtém a referência do cronômetro (timer do ONELua).
  -
  - @return {object}
  --]]
  function def:getCronometer()
    return self._cronometer
  end

  --[[
  - Obtém o tempo salvo cronometrado.
  --]]
  function def:getSavedTime()
    return self._savedTime
  end

  --[[
  - Obtém o total de tempo passado (em milissegundos). Utiliza como base o
  - último tempo salvo cronometrado e o tempo atual do cronômetro.
  --]]
  function def:getElapsedTime()
    return self:getTime() - self._savedTime
  end

  def:__init__()
  return def
end
