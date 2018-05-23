--[[@meta]]
Input = {
  name = "Input"
}

-- Possíveis estados de tecla.
Input.state = {
  IDLE     = 0,
  PRESSED  = 1,
  HELD     = 2,
  RELEASED = 3
}

-- Teclas do console.
Input.button = {
	SELECT   = Input.state.IDLE,
	START    = Input.state.IDLE,
  UP       = Input.state.IDLE,
  DOWN     = Input.state.IDLE,
  LEFT     = Input.state.IDLE,
  RIGHT    = Input.state.IDLE,
	L        = Input.state.IDLE,
	R        = Input.state.IDLE,
	TRIANGLE = Input.state.IDLE,
	CIRCLE   = Input.state.IDLE,
	CROSS    = Input.state.IDLE,
	SQUARE   = Input.state.IDLE
}

-- Teclas associadas (correspondem a um botão).
Input.binding = {
	select   = "SELECT",
	start    = "START",
	up       = "UP",
	down     = "DOWN",
	left     = "LEFT",
	right    = "RIGHT",
	l        = "L",
	r        = "R",
	triangle = "TRIANGLE",
	circle   = "CIRCLE",
	cross    = "CROSS",
	square   = "SQUARE"
}

--[[
- Associa uma tecla.
-
- @param {string} name Nome da tecla.
- @param {string} key Tecla a ser associada (ver Input.button).
--]]
function Input.setBinding(name, key)
	Input.binding[name] = key
end

--[[
- Obtém o estado de uma tecla associada.
-
- @param {string} name Nome da tecla (ver Input.binding).
- @return {number}
--]]
function Input.getBinding(name)
	return Input.button[Input.binding[name]]
end

--[[
- Informa se uma tecla está ou não está livre.
-
- @param {string} name Nome da tecla (ver Input.binding).
- @return {boolean}
--]]
function Input.idle(name)
	return (Input.getBinding(name) == Input.state.IDLE)
end

--[[
- Informa se uma tecla foi ou não pressionada.
-
- @param {string} name Nome da tecla (ver Input.binding).
- @return {boolean}
--]]
function Input.pressed(name)
	return (Input.getBinding(name) == Input.state.PRESSED)
end

--[[
- Informa se uma tecla está ou não sendo pressionada até agora.
-
- @param {string} name Nome da tecla (ver Input.binding).
- @return {boolean}
--]]
function Input.held(name)
	return (Input.getBinding(name) == Input.state.HELD)
end

--[[
- Informa se uma tecla foi ou não solta.
-
- @param {string} name Nome da tecla (ver Input.binding).
- @return {boolean}
--]]
function Input.released(name)
	return (Input.getBinding(name) == Input.state.RELEASED)
end

--[[
- Informa o próximo estado de tecla. Usualmente, elas seguem um ciclo, como
- este, por exemplo: IDLE >> PRESSED >> HELD >> RELEASED >> IDLE >> [...]
-
- @param {number} state Estado de tecla.
- @param {boolean} held Diz se a tecla está sendo pressionada ou não.
- @return {number}
--]]
function Input.nextState(state, held)
	-- Botão pressionado...
	if held == true then
		if state == Input.state.IDLE or state == nil then
			return Input.state.PRESSED

		elseif state == Input.state.PRESSED or state == Input.state.HELD then
			return Input.state.HELD
		end

	-- Botão solto...
	else
		if state == Input.state.PRESSED or state == Input.state.HELD then
			return Input.state.RELEASED

		elseif state == Input.state.RELEASED or state == Input.state.IDLE then
			return Input.state.IDLE
		end
	end
end

--[[
- Atualiza os dados de estado de todas as teclas.
--]]
function Input.read()
  buttons.read()

	Input.button.SELECT   = Input.nextState(Input.button.SELECT,   buttons.held.select)
	Input.button.START    = Input.nextState(Input.button.START,    buttons.held.start)
	Input.button.UP       = Input.nextState(Input.button.UP,       buttons.held.up)
	Input.button.DOWN     = Input.nextState(Input.button.DOWN,     buttons.held.down)
	Input.button.LEFT     = Input.nextState(Input.button.LEFT,     buttons.held.left)
	Input.button.RIGHT    = Input.nextState(Input.button.RIGHT,    buttons.held.right)
	Input.button.L        = Input.nextState(Input.button.L,        buttons.held.l)
	Input.button.R        = Input.nextState(Input.button.R,        buttons.held.r)
	Input.button.TRIANGLE = Input.nextState(Input.button.TRIANGLE, buttons.held.triangle)
	Input.button.CIRCLE   = Input.nextState(Input.button.CIRCLE,   buttons.held.circle)
	Input.button.CROSS    = Input.nextState(Input.button.CROSS,    buttons.held.cross)
	Input.button.SQUARE   = Input.nextState(Input.button.SQUARE,   buttons.held.square)
end
