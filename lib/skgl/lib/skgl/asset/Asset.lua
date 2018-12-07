--[[@meta]]
Asset = {
  class = "Asset"
}

--[[
- @class Asset
--]]
function Asset.new(name, resource)
  --[[@meta]]
  local def = {
    class = Asset
  }

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- @private Nome.
    self._name = name or nil

    -- @private Recurso.
    self._resource = resource or nil

    -- @private Indica se o recurso já está pronto para uso.
    self._ready = false
  end

  --[[
  - Evento acionado pelo observador quando o recurso estiver pronto para uso.
  --]]
  function def:notify()
    if self._ready == false then
      self._ready = true
      self:ready()
    end
  end

  --[[
  - Evento de observador. Ele deve ser executado regularmente para manter um
  - status do carregamento do recurso.
  --]]
  function def:observe()
    if self._resource ~= nil then
      self:notify()
      return true
    end
  end

  --[[
  - Obtém a categoria do recurso.
  -
  - @return {string}
  --]]
  function def:getCategory()
    return self._category
  end

  --[[
  - Retorna o nome do recurso.
  -
  - @return {string}
  --]]
  function def:getName()
    return self._name
  end

  --[[
  - Obtém o recurso (pode retornar nulo caso ainda não tenha sido carregado).
  -
  - @return {any}
  --]]
  function def:retrieve()
    return self._resource
  end

  --[[
  - Indica se o recurso já está pronto para uso.
  -
  - @return {boolean}
  --]]
  function def:isReady()
    return self._ready
  end

  --[[
  - @event
  --]]
  function def:ready()
  end

  def:__init__()
  return def
end
