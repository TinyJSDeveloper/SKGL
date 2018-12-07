--[[@meta]]
Game = {
  name = "Game"
}

-- @private Lista de cenas.
Game._scenes = Array.new()

--[[
- Obtém a cena atual em uso, isto é, a última inserida na lista.
-
- @return {Scene}
--]]
function Game.getCurrentScene()
  local lastIndex = Game._scenes:length() - 1
  return Game._scenes:get(lastIndex)
end

--[[
- Substitui a cena atual por outra.
-
- @param {Scene} scene Cena a ser substituída.
--]]
function Game.replaceScene(scene)
  local lastIndex = Game._scenes:length() - 1
  Game._scenes:set(lastIndex, scene)
end

--[[
- Remove uma cena da lista.
-
- @param {Scene} scene Cena.
--]]
function Game.removeScene(scene)
  Game._scenes:removeItems({scene})
end

--[[
- Insere uma nova cena na lista. Ela também se tornará a cena atual em uso.
-
- @param {Scene} scene Cena.
--]]
function Game.pushScene(scene)
  Game._scenes:push(scene)
end

--[[
- Remove a cena atual em uso da lista. Se existir uma cena no índice anterior,
- esta assumirá o seu lugar.
--]]
function Game.popScene()
  Game._scenes:pop()
end

--[[
- Executa o game loop sobre uma cena.
-
- @param {Clock} clock Cronômetro de tempo.
- @param {Scene} scene Cena a ser renderizada.
--]]
function Game.loop(clock, scene)
  -- Obter tempo atual e o tempo salvo no frame anterior:
  local newTime = clock:getTime()
  local oldTime = clock:getSavedTime()

  -- Obter o valor da variação de tempo:
  local delta = newTime - oldTime
  local sceneDelta = 1

  -- Iniciar o cronômetro e salvar o tempo cronometrado até agora:
  clock:start()
  clock:save()

  -- Ler teclas e renderizar a cena:
  Input.read()
  scene:render(sceneDelta)
end
