--[[@meta]]
Scene = {
	__index = Scene,
	__name = "Scene"
}

function Scene:new()
  --[[@meta]]
  local this = {
    type = "Scene",
    class = Scene
  }

	this.backgroundColor = nil
	this.layers          = {}
	this.destroyedCache  = {}

	--[[
	- Insere uma lista de nós ao parente.
	- @param {Layer{}} Nós.
	--]]
	function this:addChild(children)
		for key, value in pairs(children) do
      value.parent = self
			table.insert(self.layers, value)
		end
	end

	--[[
	- Remove uma lista de nós do parente.
	- @param {Layer{}} Nós.
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

		self.layers = filter
	end

  --[[
  - Limpa todos os nós do parente.
  --]]
  function this:clear()
    for key, value in pairs(self.layers) do
      value.parent = nil
		end

    self.layers = {}
  end

	--[[
  - Retorna o nó com a ID determinada.
  - @param {string} id ID do nó.
  - @return {Object}
  --]]
	function this:getChildrenById(id)
    for key, value in pairs(self.layers) do
      if value.id == id then
        return value
      end
    end

    return children
	end

	--[[
	- Insere uma lista de nós a lista de exclusão.
	- @param {Object{}} Nós.
	--]]
	function this:flagAsDestroyed(children)
		for key, value in pairs(children) do
			table.insert(self.destroyedCache, value)
		end
	end

	--[[
  - Limpa todos os nós da lista de exclusão, removendo-os de suas camadas.
  --]]
	function this:clearDestroyedCache()
		for key, value in pairs(self.destroyedCache) do
			if value.parent != nil then
				value.parent:removeChild({value})
			end
		end

		self.destroyedCache = {}
	end

	--[[
	- Itera entre os nós de uma camada.
	- @param {Layer} layer Camada.
	--]]
	function this:iterateLayer(layer)
		for key, value in pairs(layer.children) do
			value.scene = self

			-- Ciclo de eventos de uma instância:
			if value:isDestroyed() == false then
				value:sync()
				value:draw()
				value:update()
			end
		end
	end

	--[[
	- Itera entre os nós de todas as camadas.
	--]]
	function this:iterateAllLayers()
		for key, value in pairs(self.layers) do
			self:iterateLayer(value)
		end
	end

	--[[
	- Renderiza a cena inteira.
	--]]
	function this:render()
		if self.backgroundColor != nil then
			Surface.drawFillRect(0, 0, Surface.getScreenWidth(), Surface.getScreenHeight(), self.backgroundColor)
		end

		Input.read()
		mainScene:iterateAllLayers()
		mainScene:clearDestroyedCache()
		mainScene:update()
	end

	--[[
	- @event
	--]]
	function this:update()
		-- [...]
	end

  return this
end
