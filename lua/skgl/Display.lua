----
-- Módulo de controle do *display* do PSP; pode ser usado para obter o tamanho
-- da tela, bem como aumentar ou diminuir sua resolução.
--
-- @module skgl.Display
local M = {}

-- @private @const largura real da tela do PSP (em pixels).
M._DEVICE_WIDTH = 480

-- @private @const Altura real da tela do PSP (em pixels).
M._DEVICE_HEIGHT = 272

-- @private largura da resolução tela do PSP (em pixels).
M._width = M._DEVICE_WIDTH

-- @private Altura da resolução tela do PSP (em pixels).
M._height = M._DEVICE_HEIGHT

-- @private Posição X inicial, relativa à tela do PSP.
M._x = 0

-- @private Posição Y inicial, relativa à tela do PSP.
M._y = 0

---
-- Obtém a largura real da tela do PSP (em *pixels*). Seu valor é inalterável.
-- @return O valor descrito.
function M.getDeviceWidth()
	return M._DEVICE_WIDTH
end

----
-- Obtém a altura real da tela do PSP (em *pixels*). Seu valor é inalterável.
-- @return O valor descrito.
function M.getDeviceHeight()
	return M._DEVICE_HEIGHT
end

----
-- Obtém a largura da resolução tela do PSP (em *pixels*).
-- @return O valor descrito.
function M.getWidth()
	return M._width
end

----
-- Obtém a altura da resolução tela do PSP (em *pixels*).
-- @return O valor descrito.
function M.getHeight()
	return M._height
end

----
-- Obtém a posição X inicial, relativa à tela do PSP.
-- @return O valor descrito.
function M.getX()
  return M._x
end

----
-- Obtém a posição Y inicial, relativa à tela do PSP.
-- @return O valor descrito.
function M.getY()
  return M._y
end

----
-- Calcula e retorna um valor de coordenada X de acordo com a posição da tela.
-- @return O item descrito.
function M.getOffsetX(x)
  return x + M._x
end

----
-- Calcula e retorna um valor de coordenada Y de acordo com a posição da tela.
-- @return O item descrito.
function M.getOffsetY(y)
  return y + M._y
end

----
-- Redimensiona o tamanho da tela, isto é, altera a sua resolução.
-- @param x (***number***) Posição X inicial, relativa à tela do PSP.
-- @param y (***number***) Posição Y inicial, relativa à tela do PSP.
-- @param width (***number***) Largura da resolução tela do PSP (em pixels).
-- @param height (***number***) Altura da resolução tela do PSP (em pixels).
function M.setSize(x, y, width, height)
  M._width = width + x
  M._height = height + y
  M._x = x
  M._y = y
  screen.clip(x, y, width, height)
end

return M
