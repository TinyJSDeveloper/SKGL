--[[@meta]]
Camera = {
	__index = Camera,
	__name = "Camera"
}

--[[
- @return {Object} Cria parâmetros de tamanho de mapa para a câmera.
- @param {number} width Largura.
- @param {number} height Altura.
--]]
function Camera.mapSize(width, height)
	return {
		width  = width or 0,
		height = height or 0
	}
end

--[[
- @return {Object} Cria parâmetros de câmera para uma camada.
- @param {Layer} layer Camada a ser afetada.
- @param {boolean} xScroll Ativa ou desativa o scroll horizontal.
- @param {boolean} yScroll Ativa ou desativa o scroll vertical.
- @param {number} parallax Parallax.
--]]
function Camera.cameraSettings(layer, xScroll, yScroll, parallax)
	return {
		layer    = layer,
		xScroll  = xScroll or true,
		yScroll  = yScroll or true,
		parallax = parallax or 0
	}
end

--[[
- Focaliza a câmera em um alvo específico.
- @param {Object} cameraTarget Alvo.
- @param {Object} mapSize Tamanho de mapa (ver Camera.mapSize()).
- @param {Object{}} cameraSettings Lista de parâmetros de câmera (ver Camera.cameraSettings()).
--]]
function Camera.target(cameraTarget, mapSize, cameraSettings)
  -- Alvo a ser centralizado pela câmera:
  local target = {
    x = (cameraTarget.x or 0),
    y = (cameraTarget.y or 0)
  }

  -- Posicionamento da largura e altura da tela:
  local position = {
    x = (Surface.getScreenWidth() / 2),
    y = (Surface.getScreenHeight() / 2)
  }

  -- Movimento de câmera na posição X:
  for key, value in pairs(cameraSettings) do
    -- Posicionamento de scroll (X):
		if value.xScroll == true then

      -- Quando estiver muito para a esquerda...
			if target.x < position.x then
				target.x = position.x
			end

			-- Quando estiver muito para a direita...
			if target.x > (mapSize.width - position.x) then
				target.x = (mapSize.width - position.x)
			end

			-- Movimento parallax X rápido (útil para foregrounds):
			if value.parallax > 0 then
				value.layer.x = -(((target.x) + position.x) * value.parallax)

			-- Movimento X padrão:
			elseif value.parallax == 0 then
				value.layer.x = -(target.x) + position.x

			-- Movimento parallax X lento (útil para backgrounds):
			elseif value.parallax < 0 then
				value.layer.x = -(((target.x) + position.x) / value.parallax)
			end

    end
  end

  for key, value in pairs(cameraSettings) do
    -- Posicionamento de scroll (Y):
    if value.yScroll == true then

      -- Quando estiver muito para cima...
			if target.y < position.y then
				target.y = position.y
			end

			-- Quando estiver muito para baixo...
			if target.y > (mapSize.height - position.y) then
				target.y = (mapSize.height - position.y)
      end

			-- Movimento parallax Y rápido (útil para foregrounds):
			if value.parallax > 0 then
				value.layer.y = -(((target.y) + position.y) * value.parallax)

			-- Movimento Y padrão:
      elseif value.parallax == 0 then
				value.layer.y = -(target.y) + position.y

			-- Movimento parallax Y lento (útil para backgrounds):
      elseif value.parallax < 0 then
				value.layer.y = -(((target.y)	+ position.y) / value.parallax)
			end

    end
  end
end
