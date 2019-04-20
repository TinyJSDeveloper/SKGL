----
-- Uma cena usada pelo jogo; Pode representar telas, menus, estágios de jogo,
-- etc.
--
-- Uma cena é composta por vários objetos do tipo `skgl.Group`, que são usados
-- como camadas. Apenas grupos são suportados, por isso, para adicionar um
-- objeto à cena (como um *sprite*, por exemplo), é necessário primeiro
-- adicioná-lo a um grupo, e depois inserir este grupo à cena.
--
-- As cenas também possuem uma funcionalidade de câmera: somado às
-- funcionalidades de posicionamento relativo e *parallax* dos grupos, é
-- possível criar um *side scroller* com muita facilidade.
--
-- Extends `skgl.Array`
--
-- Dependencies: `skgl.Array`, `skgl.Display`, `skgl.Graphics`
-- @classmod skgl.Scene
local Array = require("skgl.Array")
local Display = require("skgl.Display")
local Graphics = require("skgl.Graphics")
local M = Array:subclass("skgl.Scene")

----
-- Construtor da classe.
-- @param width (***number***) Largura do cenário (usado pela câmera).
-- @param height (***number***) Altura do cenário (usado pela câmera).
-- @function new
function M:initialize(width, height)
  -- Inicializar superclasse:
  Array.initialize(self)

  --- Posição X da câmera.
  self.cameraX = 0

  --- Posição Y da câmera.
  self.cameraY = 0

  --- Determina se a posição X da câmera deve permanecer presa a área do cenário ou não.
  self.cameraLockX = true

  --- Determina se a posição Y da câmera deve permanecer presa a área do cenário ou não.
  self.cameraLockY = true

  --- Dimensão de largura do cenário (usado pela câmera).
  self.width = width or Display.getWidth()

  --- Dimensão de altura do cenário (usado pela câmera).
  self.height = height or Display.getHeight()

  --- Cor de fundo (quando nulo, sua cor é transparente).
  self.color = nil

  --- Transparência (de 0.0 a 1.0). Vale apenas para a cor de fundo.
  self.opacity = 1.0

  -- @private Cache contendo todos os objetos presentes na cena, em todos os grupos.
  self._itemCache = {}

  -- @private Cache contendo todos os grupos que compõem esta cena.
  self._groupCache = {}
end

----
-- Obtém uma Array contendo todos os objetos de uma determinada classe
-- presentes na cena, em todos os grupos.
-- @param className (***string***) Nome da classe.
-- @return O valor descrito.
function M:classItems(className)
  if self._itemCache[className] ~= nil then
    return self._itemCache[className]
  else
    return Array:new()
  end
end

----
-- Adiciona um item no cache geral de todos os objetos presentes na cena.
-- @param item (***any***) Item.
-- @return O item inserido.
function M:cacheItem(item)
  -- Nome de classe padrão:
  local className = "Object"

  -- O cache de objetos é catalogado pelo nome das classes:
  if item.class ~= nil and item.class.name ~= nil then
    className = item.class.name
  end

  -- Catálogo de objetos da classe:
  local classList = self._itemCache[className]

  -- Quando o catálogo não existe, ele é criado automaticamente:
  if classList == nil then
    classList = Array:new()
    self._itemCache[className] = classList
  end

  -- Adicionar o item no cache:
  return classList:push(item)
end

----
-- Adiciona um grupo no cache geral de todos os grupos que compõem esta cena.
-- @param group (`skgl.Group`) Grupo a ser cacheado (deve conter uma *id*).
-- @return O grupo inserido.
function M:cacheGroup(group)
  if group.id ~= nil and self._groupCache[group.id] == nil then
    self._groupCache[group.id] = group
  end

  return self._groupCache[group.id]
end

----
-- Obtém um grupo desta cena, através de sua ID.
-- @param id (***string***) ID do grupo.
-- @return O valor descrito; ou nada, caso não exista.
function M:getGroup(id)
  return self._groupCache[id]
end

----
-- Remove todos os objetos catalogados no cache da cena.
function M:clearCache()
  self._itemCache = {}
  self._groupCache = {}
end

----
-- Renderiza a cena na tela.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:render(delta)
  -- Desenhar a cor de fundo, caso tenha sido definida:
  if self.color ~= nil then
    self:drawBackground(self.color, self.opacity)
  end

  -- Limpar o cache de objetos:
  self:clearCache()

  -- Cachear todos os grupos e seus objetos...
  self:foreach(function(key, value, index)
    self:cacheGroup(value)

    value:foreach(function(key, value, index)
      self:cacheItem(value)
    end)
  end)

  -- Percorrer todos os grupos...
  self:foreach(function(key, value, index)
    value.parent = self

    -- Executar evento de "update" e desenhar o conteúdo do grupo na tela...
    self:adjustCamera(value)
    value:setDelta(delta)
    value:update(delta)
    value:draw(delta)
  end)

  -- Executar evento de "update":
  self:update(delta)
end

----
-- Desenha uma cor de fundo para a cena.
-- @param color (`skgl.Color`) Cor.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M:drawBackground(color, opacity)
  if self.color ~= nil then
    Graphics.screen.fill(color, opacity)
  end
end

----
-- Ajusta a câmera para um grupo especificado.
-- @param group (`skgl.Group`) Grupo.
function M:adjustCamera(group)
  -- Calcular posicionamento de ajuste da tela do console:
  local displayWidth  = Display.getWidth()  + Display.getX()
  local displayHeight = Display.getHeight() + Display.getY()

  -- Obter as posições X e Y do centro da tela:
  local centerX = (displayWidth  / 2) - Display.getX()
  local centerY = (displayHeight / 2) - Display.getY()

  -- Posicionamento de scroll (X):
  if group.scrollHorizontally == true then

    if self.cameraLockX == true then
      -- Quando estiver muito para a esquerda...
      if self.cameraX < centerX then
        self.cameraX = centerX
      end

      -- Quando estiver muito para a direita...
      if self.cameraX > (self.width - centerX) then
        self.cameraX = (self.width - centerX)
      end
    end

    -- Movimento parallax X rápido (útil para foregrounds):
    if group.parallaxX > 0 then
      group.x = -(((self.cameraX) + centerX) * group.parallaxX)

    -- Movimento X padrão:
    elseif group.parallaxX == 0 then
      group.x = -(self.cameraX) + centerX

    -- Movimento parallax X lento (útil para backgrounds):
    elseif group.parallaxX < 0 then
      group.x = -(((self.cameraX) + centerX) / group.parallaxX)
    end

  end

  -- Posicionamento de scroll (Y):
  if group.scrollVertically == true then

    if self.cameraLockY == true then
      -- Quando estiver muito para cima...
      if self.cameraY < centerY then
        self.cameraY = centerY
      end

      -- Quando estiver muito para baixo...
      if self.cameraY > (self.height - centerY) then
        self.cameraY = (self.height - centerY)
      end
    end

    -- Movimento parallax Y rápido (útil para foregrounds):
    if group.parallaxY > 0 then
      group.y = -(((self.cameraY) + centerY) * group.parallaxY)

    -- Movimento Y padrão:
    elseif group.parallaxY == 0 then
      group.y = -(self.cameraY) + centerY

    -- Movimento parallax Y lento (útil para backgrounds):
  elseif group.parallaxY < 0 then
      group.y = -(((self.cameraY)	+ centerY) / group.parallaxY)
    end

  end

end

----
-- Define as configurações de travamento da câmera além da área do cenário.
-- @param lockX (***boolean***) Trava ou destrava a posição X da câmera além da área do cenário.
-- @param lockY (***boolean***) Trava ou destrava a posição Y da câmera além da área do cenário.
function M:setCameraLock(lockX, lockY)
  self.cameraLockX = lockX or false
  self.cameraLockY = lockY or false
end

----
-- Focaliza a câmera para exibir uma determinada posição.
-- @param x (***number***) Posição X da câmera.
-- @param y (***number***) Posição Y da câmera.
function M:lookAt(x, y)
  self.cameraX = x or self.cameraX
  self.cameraY = y or self.cameraY
end

----
-- (***@event***) Evento chamado a cada quadro.
-- @param delta (***number***) Variação de tempo (*delta time*).
function M:update(delta)
end

return M
