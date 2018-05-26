--[[@meta]]
Clock = {
  name = "Clock"
}

function Clock.new()
  --[[@meta]]
  local _self = {
    class = Clock
  }

  -- @private Cronômetro (timer do ONELua).
  _self._cronometer = timer.new()

  -- @private Último tempo salvo cronometrado.
  _self._savedTime = 0

  --[[
  - Inicia o cronômetro.
  -
  - @return {number} Retorna o tempo que foi iniciado (em milissegundos).
  --]]
  function _self:start()
    return timer.start(self._cronometer)
  end

  --[[
  - Para o cronômetro.
  -
  - @return {number} Retorna o tempo que foi parado (em milissegundos).
  --]]
  function _self:stop()
    return timer.stop(self._cronometer)
  end

  --[[
  - Reinicia o cronômetro.
  -
  - @return {number} Retorna o tempo que foi reiniciado (em milissegundos).
  --]]
  function _self:reset()
    return timer.reset(self._cronometer)
  end

  --[[
  - Obtém o tempo atual do cronômetro.
  -
  - @return {number} Retorna o tempo atual (em milissegundos).
  --]]
  function _self:getTime()
    return timer.time(self._cronometer)
  end

  --[[
  - Salva o tempo atual.
  -
  - @return {number} Retorna o tempo salvo (em milissegundos).
  --]]
  function _self:save()
    self._savedTime = self:getTime()
    return self._savedTime
  end

  --[[
  - Limpa todo o cronômetro, reiniciando o cronômetro e zerando o tempo salvo.
  --]]
  function _self:clear()
    self.savedTime = 0
    self:reset()
  end

  --[[
  - Obtém a referência do cronômetro (timer do ONELua).
  -
  - @return {object}
  --]]
  function _self:getCronometer()
    return self._cronometer
  end

  --[[
  - Obtém o tempo salvo cronometrado.
  --]]
  function _self:getSavedTime()
    return self._savedTime
  end

  --[[
  - Obtém o total de tempo passado (em milissegundos). Utiliza como base o
  - último tempo salvo cronometrado e o tempo atual do cronômetro.
  --]]
  function _self:getElapsedTime()
    return self:getTime() - self._savedTime
  end

  return _self
end
