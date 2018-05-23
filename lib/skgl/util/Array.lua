--[[@meta]]
Array = {
  name = "Array"
}

--[[
- Verifica se um determinado item é ou não é uma Array.
-
- @param {any} item Item.
- @return {boolean} Retorna se o item é ou não é uma Array.
--]]
function Array.isArray(item)
  return (item.class == Array)
end

function Array.new()
  --[[@meta]]
  local _self = {
    class = Array
  }

  -- @private Itens.
  _self._items = {}

  -- @private Total de itens.
  _self._length = 0

  --[[
  - @return {any[]} Itens.
  --]]
  function _self:items()
    return self._items
  end

  --[[
  - Total de itens.
  --]]
  function _self:length()
    return self._length
  end

  --[[
  - Obtém um item pelo seu índice.
  -
  - @param {number} index Índice (indexação baseada em 0).
  - @return {any} Retorna o valor ou, caso o índice não exista, nada.
  --]]
  function _self:get(index)
    return self._items[(index + 1)]
  end

  --[[
  - Obtém o índice de um determinado item.
  -
  - @param {any} item Item.
  - @return {number} Obtém o índice do item ou, caso não exista, -1.
  --]]
  function _self:indexOf(item)
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
  - @return {number} Obtém o índice do item ou, caso não exista, -1.
  --]]
  function _self:lastIndexOf(item)
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
  - @return {boolean}
  --]]
  function _self:push(item)
    table.insert(self._items, item)
    self._length = (self._length + 1)
  end

  --[[
  - Remove o último item inserido.
  -
  - @return {any} Retorna o item removido.
  ]]
  function _self:pop()
    -- Obter último item inserido:
    local item = self.get(self._length - 1)

    -- Remover e retornar o item:
    table.remove(a)
    return item
  end

  --[[
  - Adiciona uma lista de itens.
  -
  - @param {any[]} items Lista de itens.
  --]]
  function _self:addItems(items)
    for itemKey, itemValue in pairs(items) do
      self:push(itemValue)
    end
  end

  --[[
  - Remove uma lista de itens.
  -
  - @param {any[]} items Lista de itens.
  --]]
  function _self:removeItems(items)
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
  function _self:removeIndex(index)
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
  - Percorre todos os itens, chamando um evento que permite obter seus valores,
  - um de cada vez.
  -
  - @param {Function} event Uso: function(key, value, index) ... end
  --]]
  function _self:foreach(event)
    -- Contador de índices percorridos:
    local index = 0

    -- Percorrer todos os itens da lista, chamando o evento especificado:
    for key, value in pairs(self:items()) do
      event(key, value, index)
      index = (index + 1)
    end
  end

  return _self
end
