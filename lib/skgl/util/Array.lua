--[[@meta]]
Array = {
  name = "Array"
}

--[[
- Verifica se um determinado item é ou não é uma Array.
-
- @param {any} item Item.
-
- @return {boolean} Retorna se o item é ou não é uma Array.
--]]
function Array.isArray(item)
  return (item.class == Array)
end

--[[
- @class Array
-
- @param {any[]} items Lista inicial de itens (opcional).
--]]
function Array.new(items)
  --[[@meta]]
  local def = {
    class = Array
  }

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- @private Itens.
    self._items = {}

    -- @private Total de itens.
    self._length = 0

    -- Pré-adiciona uma lista de itens na Array (opcional):
    if items ~= nil then
      self:addItems(items)
    end
  end

  --[[
  - @return {any[]} Itens.
  --]]
  function def:items()
    return self._items
  end

  --[[
  - Total de itens.
  --]]
  function def:length()
    return self._length
  end

  --[[
  - Obtém um item pelo seu índice.
  -
  - @param {number} index Índice (indexação baseada em 0).
  -
  - @return {any} Retorna o valor ou, caso o índice não exista, nada.
  --]]
  function def:get(index)
    return self._items[(index + 1)]
  end

  --[[
  - Adiciona ou substitui o valor de um item com um índice específico.
  -
  - @param {number} index Índice (indexação baseada em 0).
  - @param {any} item Item.
  -
  - @return {number} Retorna de volta o item adicionado ou substituído.
  --]]
  function def:set(index, item)
    self._items[(index + 1)] = item
    return item
  end

  --[[
  - Obtém o índice de um determinado item.
  -
  - @param {any} item Item.
  -
  - @return {number} Obtém o índice do item ou, caso não exista, -1.
  --]]
  function def:indexOf(item)
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

  --[[
  - Obtém o último índice de um determinado item.
  -
  - @param {any} item Item.
  -
  - @return {number} Obtém o índice do item ou, caso não exista, -1.
  --]]
  function def:lastIndexOf(item)
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

  --[[
  - Insere um item.
  -
  - @param {any} item Item.
  -
  - @return {any} Retorna de volta o item inserido.
  --]]
  function def:push(item)
    table.insert(self._items, item)
    self._length = (self._length + 1)

    return item
  end

  --[[
  - Remove o último item inserido.
  -
  - @return {any} Retorna o item removido.
  ]]
  function def:pop()
    -- Obter último item inserido:
    local item = self:get(self._length - 1)

    -- Remover o item e subtrair a contagem total:
    table.remove(self._items, self._length)
    self._length = (self._length - 1)

    return item
  end

  --[[
  - Adiciona uma lista de itens.
  -
  - @param {any[]} items Lista de itens.
  --]]
  function def:addItems(items)
    for itemKey, itemValue in pairs(items) do
      self:push(itemValue)
    end
  end

  --[[
  - Remove uma lista de itens.
  -
  - @param {any[]} items Lista de itens.
  --]]
  function def:removeItems(items)
    -- Converter lista de itens em uma Array (facilita a sua manipulação):
    local itemsArray = Array.new()
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

  --[[
  - Remove o item correspondente ao índice especificado.
  -
  - @param {number} index Índice.
  --]]
  function def:removeIndex(index)
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

  --[[
  - Remove todos os itens desta Array.
  --]]
  function def:clear()
    self._items = {}
    self._length = 0
  end

  --[[
  - Percorre todos os itens, chamando um evento que permite obter seus valores,
  - um de cada vez.
  -
  - @param {Function} event Uso: function(key, value, index) ... end
  --]]
  function def:foreach(event)
    -- Contador de índices percorridos:
    local index = 0

    -- Percorrer todos os itens da lista, chamando o evento especificado:
    for key, value in pairs(self:items()) do
      event(key, value, index)
      index = (index + 1)
    end
  end

  def:__init__()
  return def
end
