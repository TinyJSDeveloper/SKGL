----
-- Controlador geral dos métodos de entrada (botões e teclas) do PSP; os
-- controles podem ser lidos, checados ou associados sob outros nomes, caso
-- seja necessário para o jogo.
--
-- @classmod skgl.Input
local class = require("middleclass")
local M = class("skgl.Input")

--- Estados de tecla.
M.static.state = {
  IDLE     = 0, -- Tecla inativa.
  PRESSED  = 1, -- Tecla pressionada.
  HELD     = 2, -- Tecla mantida.
  RELEASED = 3  -- Tecla solta.
}

--- Botões do PSP.
M.static.button = {
  SELECT   = M.state.IDLE, -- Botão "*Select*".
  START    = M.state.IDLE, -- Botão "*Start*".
  UP       = M.state.IDLE, -- Botão para cima do *D-Pad*.
  DOWN     = M.state.IDLE, -- Botão para baixo do *D-pad*.
  LEFT     = M.state.IDLE, -- Botão para esquerda do *D-pad*.
  RIGHT    = M.state.IDLE, -- Botão para direita do *D-pad*.
  L        = M.state.IDLE, -- Botão superior esquerdo "*L*".
  R        = M.state.IDLE, -- Botão superior direito "*R*".
  TRIANGLE = M.state.IDLE, -- Botão "*Triângulo*".
  CIRCLE   = M.state.IDLE, -- Botão "*Círculo*".
  CROSS    = M.state.IDLE, -- Botão "*X*".
  SQUARE   = M.state.IDLE  -- Botão "*Quadrado*."
}

--- Estados do(s) analógico(s). O PSP só possui o analógico esquerdo.
M.static.analog = {
    left = {
      x = 0,
      y = 0
    },

    right = {
      x = 0,
      y = 0
    }
}

----
-- Construtor da classe.
-- @function new
function M:initialize()
  --- Teclas associadas (correspondem a um botão).
  self.binding = {
  	select   = "SELECT",   -- Botão "*Select*".
  	start    = "START",    -- Botão "*Start*".
  	up       = "UP",       -- Botão para cima do *D-Pad*.
  	down     = "DOWN",     -- Botão para baixo do *D-pad*.
  	left     = "LEFT",     -- Botão para esquerda do *D-pad*.
  	right    = "RIGHT",    -- Botão para direita do *D-pad*.
  	l        = "L",        -- Botão superior esquerdo "*L*".
  	r        = "R",        -- Botão superior direito "*R*".
  	triangle = "TRIANGLE", -- Botão "*Triângulo*".
  	circle   = "CIRCLE",   -- Botão "*Círculo*".
  	cross    = "CROSS",    -- Botão "*X*".
  	square   = "SQUARE"    -- Botão "*Quadrado*".
  }
end

--- Associa uma tecla.
-- @param name (***string***) Nome da nova tecla associada.
-- @param key (***string***) Tecla a ser associada (@see skgl.Input.static.button).
function M:setBinding(name, key)
	self.binding[name] = key
end

----
-- Obtém o estado de uma tecla associada.
-- @param name (***string***) Nome da tecla (@see skgl.Input.binding).
-- @return O estado da tecla associada (@see skgl.Input.static.state).
function M:getBinding(name)
	return M.button[self.binding[name]]
end

----
-- Obtém o estado do(s) analógico(s).
-- @param name (***string***) Nome do analógico (@see skgl.Input.analog).
-- @return O estado do analógico (em valores X e Y).
function M:getAnalog(name)
  return M.analog[name]
end

----
-- Informa se uma tecla está ou não inativa.
-- @param name (***string***) Nome da tecla (@see skgl.Input.binding).
-- @return O valor descrito.
function M:idle(name)
	return (self:getBinding(name) == M.state.IDLE)
end

----
-- Informa se uma tecla foi ou não pressionada.
-- @param name (***string***) Nome da tecla (@see skgl.Input.binding).
-- @return O valor descrito.
function M:pressed(name)
	return (self:getBinding(name) == M.state.PRESSED)
end

----
-- Informa se uma tecla está ou não mantida.
-- @param name (***string***) Nome da tecla (@see skgl.Input.binding).
-- @return O valor descrito.
function M:held(name)
	return (self:getBinding(name) == M.state.HELD)
end

----
-- Informa se uma tecla foi ou não solta.
-- @param name (***string***) Nome da tecla (@see skgl.Input.binding).
-- @return O valor descrito.
function M:released(name)
	return (self:getBinding(name) == M.state.RELEASED)
end

----
-- Informa se uma tecla está pressionada e/ou mantida.
-- @param name (***string***) Nome da tecla (@see skgl.Input.binding).
-- @return O valor descrito.
function M:pushed(name)
  return (self:getBinding(name) == M.state.PRESSED) or (self:getBinding(name) == M.state.HELD)
end

----
-- Informa o próximo estado de tecla a partir de outro. Usualmente, elas seguem
--  o seguinte ciclo: `IDLE`, `PRESSED`, `HELD`, `RELEASED`, `IDLE`, [...].
-- @param state (***number***) Estado de tecla.
-- @param held (***boolean***) Informa se a tecla está ou não mantida.
-- @return O próximo estado de tecla. (@see skgl.Input.static.state).
function M.static:nextState(state, held)
	-- Botão pressionado...
	if held == true then
		if state == M.state.IDLE or state == nil then
			return M.state.PRESSED

		elseif state == M.state.PRESSED or state == M.state.HELD then
			return M.state.HELD
		end

	-- Botão solto...
	else
		if state == M.state.PRESSED or state == M.state.HELD then
			return M.state.RELEASED

		elseif state == M.state.RELEASED or state == M.state.IDLE then
			return M.state.IDLE
		end
	end
end

----
-- Lê e atualiza os dados de estado de todas as teclas.
function M.static:read()
  buttons.read()

  M.analog.left.x   = buttons.analogx
  M.analog.left.y   = buttons.analogy

	M.button.SELECT   = M:nextState(M.button.SELECT,   buttons.held.select)
	M.button.START    = M:nextState(M.button.START,    buttons.held.start)
	M.button.UP       = M:nextState(M.button.UP,       buttons.held.up)
	M.button.DOWN     = M:nextState(M.button.DOWN,     buttons.held.down)
	M.button.LEFT     = M:nextState(M.button.LEFT,     buttons.held.left)
	M.button.RIGHT    = M:nextState(M.button.RIGHT,    buttons.held.right)
	M.button.L        = M:nextState(M.button.L,        buttons.held.l)
	M.button.R        = M:nextState(M.button.R,        buttons.held.r)
	M.button.TRIANGLE = M:nextState(M.button.TRIANGLE, buttons.held.triangle)
	M.button.CIRCLE   = M:nextState(M.button.CIRCLE,   buttons.held.circle)
	M.button.CROSS    = M:nextState(M.button.CROSS,    buttons.held.cross)
	M.button.SQUARE   = M:nextState(M.button.SQUARE,   buttons.held.square)
end

return M
