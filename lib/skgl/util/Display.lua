--[[@meta]]
Display = {
  name = "Display"
}

-- @private @const largura real da tela do console (em pixels).
Display._DEVICE_WIDTH = 480

-- @private @const Altura real da tela do console (em pixels).
Display._DEVICE_HEIGHT = 272

-- @private Dimensão de largura da tela.
Display._width = Display._DEVICE_WIDTH

-- @private Dimensão de altura da tela.
Display._height = Display._DEVICE_HEIGHT

-- @private Posição X inicial em relação a tela do console.
Display._x = 0

-- @private Posição Y inicial em relação a tela do console.
Display._y = 0

--[[
- Obtém a largura real da tela do console (em pixels).
-
- @return {number} Retorna a largura real da tela do console (em pixels).
--]]
function Display.getDeviceWidth()
	return Display._DEVICE_WIDTH
end

--[[
- Obtém a altura real da tela do console (em pixels).
-
- @return {number} Retorna a altura real da tela do console (em pixels).
--]]
function Display.getDeviceHeight()
	return Display._DEVICE_HEIGHT
end

--[[
- Obtém a dimensão de largura da tela.
-
- @return {number} Retorna a dimensão de largura da tela.
--]]
function Display.getWidth()
	return Display._width
end

--[[
- Obtém a dimensão de altura da tela.
-
- @return {number} Retorna a dimensão de altura da tela.
--]]
function Display.getHeight()
	return Display._height
end

--[[
- Obtém a posição X inicial em relação a tela do console.
-
- @return {number} Retorna a posição X inicial em relação a tela do console.
--]]
function Display.getX()
  return Display._x
end

--[[
- Obtém a posição Y inicial em relação a tela do console.
-
- @return {number} Retorna a posição X inicial em relação a tela do console.
--]]
function Display.getY()
  return Display._y
end

--[[
- Calcula e retorna um valor de coordenada X de acordo com a posição da tela.
-
- @return {number} Retorna o valor de offset X.
--]]
function Display.getOffsetX(x)
  return x + Display._x
end

--[[
- Calcula e retorna um valor de coordenada Y de acordo com a posição da tela.
-
- @return {number} Retorna o valor de offset Y.
--]]
function Display.getOffsetY(y)
  return y + Display._y
end

--[[
- Desenha uma cor de fundo para a tela.
-
- @param {Color} fillColor Cor de preenchimento (ver Color:retrieve()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Display.setBackgroundColor(fillColor, opacity)
  Surface.drawFillRect(0, 0, Display.getWidth(), Display.getHeight(), fillColor, opacity)
end

--[[
- Redimensiona o tamanho da tela do jogo.
-
- @param {number} x Posição X inicial em relação a tela do console.
- @param {number} y Posição Y inicial em relação a tela do console.
- @param {number} width dimensão de largura da tela.
- @param {number} height dimensão de altura da tela.
--]]
function Display.setSize(x, y, width, height)
  Display._width = width + x
  Display._height = height + y
  Display._x = x
  Display._y = y
  screen.clip(x, y, width, height)
end
