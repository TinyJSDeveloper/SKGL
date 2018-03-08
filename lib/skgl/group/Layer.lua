--[[@meta]]
Layer = {
	__index = Layer,
	__name = "Layer"
}

function Layer:new(id)
  --[[@meta]]
  local this = {
    type = "Layer",
    class = Layer
  }

	this.id       = id or nil
  this.children = {}
  this.parent   = nil
  this.x        = 0
  this.y        = 0

	--[[
	- Insere uma lista de nós ao parente.
	- @param {Object{}} Nós.
	--]]
	function this:addChild(children)
		for key, value in pairs(children) do
      value.parent = self
			table.insert(self.children, value)
		end
	end

	--[[
	- Remove uma lista de nós do parente.
	- @param {Object{}} Nós.
	--]]
	function this:removeChild(children)
		-- Remover referência dos nós a serem removidos:
		for key, value in pairs(children) do
      value.parent = nil
		end

		-- Filtro contendo todos os nós não removidos:
		local filter = {}

		-- Filtrar e guardar somente os nós não removidos:
		for key, value in pairs(self.children) do
			if value.parent == self then
				table.insert(filter, value)
			end
		end

		self.children = filter
	end

  --[[
  - Limpa todos os nós do parente.
  --]]
  function this:clear()
    for key, value in pairs(self.children) do
      value.parent = nil
		end

    self.children = {}
  end

  --[[
  - Retorna todos os nós com o tipo determinado.
  - @param {string} type Tipo do nó.
  - @return {Object{}}
  --]]
  function this:getChildrenByType(type)
    local children = {}

    for key, value in pairs(self.children) do
      if value.type == type then
        table.insert(children, value)
      end
    end

    return children
  end

  --[[
  - Retorna todos os nós com o nome da classe determinada.
  - @param {string} class Nome da classe do nó.
  - @return {Object{}}
  --]]
  function this:getChildrenByClassName(className)
    local children = {}

    for key, value in pairs(self.children) do
      if value.class.__name == className then
        table.insert(children, value)
      end
    end

    return children
  end

  return this
end
