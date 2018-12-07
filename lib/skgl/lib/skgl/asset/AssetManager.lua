--[[@meta : @extends Array]]
AssetManager = {
  class = "AssetManager",
  extends = Array
}

--[[
- @class AssetManager @extends Array
-
- @param {object<any[]>} items Catálogo de recursos.
--]]
function AssetManager.new(items)
  --[[@meta : @extends Array]]
  local def = Array.new()
  def.class = AssetManager

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- @private Catálogo de recursos carregados.
    self._assets = {}

    -- @private Número total de recursos carregados.
    self._readyCount = 0

    -- @private Indica se o catálogo já foi carregado.
    self._ready = false

    -- Pré-carregar um catálogo inicial de recursos (opcional):
    if items ~= nil then
      self:preloadItems(items)
    end
  end

  --[[
  - Pré-carrega um item/recurso.
  -
  - @param {string} category Categoria pertencente a este recurso.
  - @param {string} name Nome dado a este recurso.
  - @param {any} resource Recurso.
  -
  - @return {object} Retorna um objeto contendo dados do pré-carregamento.
  --]]
  function def:preloadItem(name, resource)
    -- Dados do pré-carregamento:
    local itemData = Asset.new(name, resource)

    -- Inserir e retornar os dados deste recurso na fila de espera:
    self:push(itemData)
    return itemData
  end

  --[[
  - Pré-carrega um catálogo de recursos.
  -
  - @param {object<any[]>} items Catálogo de recursos.
  - Uso: { sprite_foo = load(1), sprite_bar = load(2), [...] }
  -
  - @return {object<any[]>} Retorna um catálogo contendo todos os dados do
  - pré-carregamento.
  --]]
  function def:preloadItems(items)
    -- Catálogo de dados do pré-carregamento:
    local itemData = {}

    -- Percorrer e inserir os dados deste recurso na fila de espera...
    for key, value in pairs(items) do
      itemData[key] = self:preloadItem(key, value)
    end

    return itemData
  end

  --[[
  - Evento acionado pelo observador quando o catálogo estiver carregado.
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
    -- Verificar se todos os recursos já foram carregados:
    if self._readyCount >= self:length() then
      self:notify()
      return true
    end

    -- Percorrer fila de espera, gerenciando os itens do carregamento...
    self:foreach(function(key, value, index)
      -- Observar o recurso:
      value:observe()

      -- Adicionar recurso ao catálogo quando estiver pronto:
      if self:res(value:getName()) == nil and value:isReady() then
        self._assets[value:getName()] = value:retrieve()
        self._readyCount = (self._readyCount + 1)

        self:loaded(value)
      end
    end)
  end

  --[[
  - Obtém um item do catálogo de recursos carregados. Pode retornar nulo caso
  - não tenha sido carregado ou não exista.
  -
  - @param {string} name Nome do recurso.
  -
  - @return {any}
  --]]
  function def:res(name)
    return self._assets[name]
  end

  --[[
  - Obtém o catálogo de recursos carregados.
  -
  - @return {object}
  --]]
  function def:retrieve()
    return self._assets
  end

  --[[
  - Número total de recursos carregados.
  -
  - @return {number}
  --]]
  function def:readyCount()
    return self._readyCount
  end

  --[[
  - Indica se o catálogo já foi carregado.
  -
  - @return {boolean}
  --]]
  function def:isReady()
    return self._ready
  end

  --[[
  - @event
  - @param {object} resource Recurso recém-carregado.
  --]]
  function def:loaded(resource)
  end

  --[[
  - @event
  --]]
  function def:ready()
  end

  def:__init__()
  return def
end
