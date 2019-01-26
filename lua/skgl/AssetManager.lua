----
-- Gerenciador de recursos; é usado para pré-carregar vários recursos de uma
-- vez, notificando quando todos estiverem prontos.
--
-- Dependencies: `skgl.Array`
-- @classmod skgl.AssetManager
local Array = require("skgl.Array")
local M = Array:subclass("skgl.AssetManager")

----
-- Construtor da classe.
-- @param items ({`skgl.Image`, `skgl.Audio`}) Catálogo de recursos.
-- @function new
function M:initialize(items)
  -- Inicializar superclasse:
  Array.initialize(self)

  -- @private Catálogo de recursos carregados.
  self._assets = {}

  -- @private Número total de recursos carregados.
  self._readyCount = 0

  -- @private Indica se o catálogo já foi carregado.
  self._ready = false

  --- Tempo de espera até o próximo recurso ser carregado.
  self.wait = 0

  -- @private Contador do tempo de espera.
  self._waitCounter = 0

  -- Pré-carregar um catálogo inicial de recursos (opcional):
  if items ~= nil then
    self:preloadTable(items)
  end
end

----
-- Pré-carrega um recurso.
-- @param id (***number***) ID deste recurso.
-- @param item (`skgl.Image`, `skgl.Audio`) Recurso.
function M:preload(id, item)
  item.id = id
  self:push(item)
end

----
-- Pré-carrega vários recursos.
-- @param items ({`skgl.Image`, `skgl.Audio`}) Catálogo de recursos.
function M:preloadTable(items)
  for id, item in pairs(items) do
    self:preload(id, item)
  end
end

----
-- Pré-carrega uma sequência de recursos.
-- @param id (***string***) ID destes recursos (sem os números).
-- @param first (***number***) Primeiro índice enumerado após a ID.
-- @param last (***number***) Último índice enumerado após a ID.
-- @param zeroFill (***number***) Preenchimento de zeros.
-- @param event (***function***) Uso:
-- `function(nextId, id, index) ... return <any> end`
function M:preloadSequence(id, first, last, zeroFill, event)
  -- Lista de recursos:
  local items = {}

  -- Formatação de string (zero-fill):
  local format = "%0"..zeroFill.."d"

  -- Iterar sobre os índices, enumerando a ID de cada recurso...
  for i = first, last do
    local nextId = id..string.format(format, i)

    -- O recurso final depende do retorno da função de evento, na qual
    -- receberá a ID enumerada deste recurso e deverá retornar algum valor:
    items[nextId] = event(nextId, id, i)

    -- Pré-carregar o recurso enumerado:
    self:preload(nextId, items[nextId])
  end
end

----
-- Obtém um item do catálogo de recursos carregados.
-- @param id (***string***) ID deste recurso.
-- @return O recurso; ou nada, caso não exista.
function M:res(id)
  return self._assets[id]
end

----
-- Obtém uma sequência de itens do catálogo de recursos carregados.
-- @param id (***string***) ID dos recursos (sem os números).
-- @param first (***number***) Primeiro índice enumerado após a ID.
-- @param last (***number***) Último índice enumerado após a ID.
-- @param zeroFill (***number***) Preenchimento de zeros.
-- @return Uma tabela de recursos; ou uma tabela vazia, caso não existam.
--]]
function M:ress(id, first, last, zeroFill)
  -- Lista de recursos + contador de índice:
  local items = {}
  local nextIndex = 1

  -- Formatação de string (zero-fill):
  local format = "%0"..zeroFill.."d"

  -- Iterar sobre os índices, obtendo cada um dos recursos enumerados...
  for i = first, last do
    local nextId = id..string.format(format, i)

    -- Obter e guardar cada recurso na lista...
    items[nextIndex] = self:res(nextId)
    nextIndex = (nextIndex + 1)
  end

  return items
end

----
-- Obtém o último item adicionado.
-- @return O valor descrito.
function M:lastItem()
  return (self:get(self:length() - 1))
end

----
-- Obtém a quantidade total de recursos presentes no gerenciador.
-- @return O valor descrito.
function M:getCount()
  return (self:length() + self._readyCount)
end

----
-- Obtém um valor em porcentagem do total carregado.
-- @return O valor descrito.
function M:getPercentage()
  return (self._readyCount / self:getCount()) * 100
end

----
-- Obtém o contador do tempo de espera.
-- @return O valor descrito.
function M:getWaitCounter()
  return (self._waitCounter)
end

----
-- Evento de observador. Ele deve ser executado regularmente para manter um
-- status do carregamento do recurso.
function M:observe()
  -- Verificar se todos os recursos já foram carregados:
  if self:length() <= 0 then
    if self._ready == false then
      self._ready = true
      self:ready()
    end

    return true
  end

  -- Os recursos são tratados como uma pilha, ou seja, o que estiver na frente
  -- é sempre escolhido para sair primeiro:
  local item = self:lastItem()

  -- Se não existirem mais itens, o evento de observador pode ser encerrado:
  if item == nil then
    return false
  end

  -- Controlar tempo de espera até o carregamento do próximo recurso. Este
  -- controle é útil para simular/testar barras de progresso ou para corrigir
  -- problemas ao carregar múltiplos recursos em sequência:
  if self._waitCounter > 0 then
    self._waitCounter = (self._waitCounter - 1)
    if self._waitCounter < 0 then
      self._waitCounter = 0
    end

    return false
  end

  -- Carregar este recurso. Todos os demais permanecem aguardando até chegar a
  -- sua vez:
  if not item.loading then
    item:load()
  end

  -- Quando o recurso tiver sido carregado, ele é adicionado de recursos
  -- carregados, aciona um evento e sai da pilha:
  if item.resource ~= nil then
    self._assets[item.id] = item:get()
    self:loaded(item)
    self:pop(item)

    self._readyCount = (self._readyCount + 1)
    self._waitCounter = self.wait
  end
end

----
-- Obtém o catálogo de recursos carregados.
-- @return O valor descrito.
function M:retrieve()
  return self._assets
end

----
-- Obtém o número total de recursos carregados.
-- @return O valor descrito.
function M:readyCount()
  return self._readyCount
end

----
-- Indica se o catálogo já foi carregado.
-- @return O valor descrito.
function M:isReady()
  return self._ready
end

----
-- (***@event***) Evento acionado ao ter recém-carregado um recurso.
-- @param item (`skgl.Image`, `skgl.Audio`) Recurso recém-carregado.
function M:loaded(item)
end

----
-- (***@event***) Evento ao carregar.
--
function M:ready()
end

return M
