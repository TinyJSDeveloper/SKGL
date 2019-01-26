-----
-- Implementação de uma *Array*; esta é indexada em 0.
--
-- @classmod skgl.Array
local class = require("middleclass")
local M = class("skgl.Array")

----
-- Verifica se um determinado item é ou não é uma *Array*.
-- @param item (***any***) Item.
-- @return Retorna se o item é ou não é uma *Array*.
function M.static:isArray(item)
  return (item.class == self)
end

----
-- Construtor da classe.
-- @function new
-- @param items (***{any}***) Lista inicial de itens (*opcional*).
function M:initialize(items)
  -- @private Itens.
  self._items = {}

  -- @private Total de itens.
  self._length = 0

  -- Pré-adiciona uma lista de itens na Array (opcional):
  if items ~= nil then
    self:addItems(items)
  end
end

----
-- Obtém todos os itens desta *Array*.
-- @return O valor descrito.
function M:items()
  return self._items
end

----
-- Obtém o valor total de itens desta *Array*.
-- @return O valor descrito.
function M:length()
  return self._length
end

----
-- Obtém um item pelo seu índice.
-- @param index (***number***) Índice (indexação baseada em 0).
-- @return Valor do índice; ou nada, caso não exista.
function M:get(index)
  return self._items[(index + 1)]
end

----
-- Adiciona ou substitui o valor de um item com um índice específico.
-- @param index (***number***) Índice (indexação baseada em 0).
-- @param item (***any***) Item.
-- @return O item adicionado ou substituído.
function M:set(index, item)
  self._items[(index + 1)] = item
  return item
end

----
-- Obtém o índice de um determinado item.
-- @param item (***any***) Item.
-- @return O índice do item; ou -1, caso não exista.
function M:indexOf(item)
  -- Contador de índices percorridos:
  local index = 0

  -- Percorrer todos os itens...
  for key, value in pairs(self._items) do

    -- Retornar o índice registrado caso o item tenha sido encontrado:
    if item == value then
      return index
    end

    index = (index + 1)
  end

  return -1
end

----
-- Obtém o último índice de um determinado item.
-- @param item (***any***) Item.
-- @return O índice do item; ou -1, caso não exista.
function M:lastIndexOf(item)
  -- Contador de índices percorridos:
  local index = 0

  -- Último índice encontrado:
  local foundIndex = -1

  -- Percorrer todos os itens...
  for key, value in pairs(self._items) do

    -- Registrar este índice caso o item tenha sido encontrado:
    if item == value then
      foundIndex = index
    end

    index = (index + 1)
  end

  return foundIndex
end


----
-- Insere um item.
-- @param item (***any***) Item.
-- @return O item inserido.
function M:push(item)
  table.insert(self._items, item)
  self._length = (self._length + 1)

  return item
end

----
-- Remove o último item inserido.
-- @return O item removido.
function M:pop()
  -- Obter último item inserido:
  local item = self:get(self._length - 1)

  -- Remover o item e subtrair a contagem total:
  table.remove(self._items, self._length)
  self._length = (self._length - 1)

  return item
end

----
-- Adiciona uma lista de itens.
-- @param items (***{any}***) Lista de itens.
function M:addItems(items)
  for itemKey, itemValue in pairs(items) do
    self:push(itemValue)
  end
end

----
-- Remove uma lista de itens.
-- @param items (***{any}***) Lista de itens.
function M:removeItems(items)
  -- Converter lista de itens em uma Array (facilita a sua manipulação):
  local itemsArray = M:new()
  itemsArray:addItems(items)

  -- Filtro contendo todos os itens não removidos:
  local filter = {}

  -- Total de itens filtrados:
  local length = 0

  -- Indica se a lista de itens possui, de fato, itens:
  local hasItems = false

  -- Filtrar e guardar somente os itens não removidos...
  for key, value in pairs(self._items) do
    hasItems = true

    -- Se um item não constar na lista passada, ele será filtrado como um
    -- item não removido:
    if itemsArray:indexOf(value) < 0 then
      table.insert(filter, value)
      length = (length + 1)
    end
  end

  -- Ao passar uma lista vazia, o filtro não recebe nenhum item, o que
  -- faz todos os itens serem apagados. Como uma lista vazia não contém nada
  -- que possa ser verificado, a função que substitui a lista de itens pelo
  -- filtro termina aqui:
  if not hasItems then
    return nil
  end

  self._items = filter
  self._length = length
end

----
-- Remove o item correspondente ao índice especificado.
-- @param index (***number***) Índice.
function M:removeIndex(index)
  -- Contador de índices percorridos:
  local indexCounter = 0

  -- Filtro contendo todos os itens não removidos:
  local filter = {}

  -- Total de itens filtrados:
  local length = 0

  -- Filtrar e guardar somente os itens não removidos...
  for key, value in pairs(self._items) do
    if indexCounter ~= index then
      table.insert(filter, value)
      length = (length + 1)
    end

    indexCounter = (indexCounter + 1)
  end

  self._items = filter
  self._length = length
end

--- Remove todos os itens desta Array.
function M:clear()
  self._items = {}
  self._length = 0
end

----
-- Percorre todos os itens, chamando um evento que permite obter seus valores,
-- um de cada vez.
-- @param event (***function***) Uso: `function(key, value, index) ... end`
function M:foreach(event)
  -- Contador de índices percorridos:
  local index = 0

  -- Percorrer todos os itens da lista, chamando o evento especificado:
  for key, value in pairs(self:items()) do
    event(key, value, index)
    index = (index + 1)
  end
end

return M
