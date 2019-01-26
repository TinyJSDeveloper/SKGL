----
-- Representa um evento que pode ser engatilhado no momento apropriado.
--
-- @classmod skgl.Event
local class = require("middleclass")
local M = class("skgl.Event")

----
-- Construtor da classe.
function M:initialize()
  self._triggered = false
end

----
-- Engatilha o evento.
function M:trigger()
  if not self._triggered then
    self._triggered = true
    self:triggered()
  end
end

----
-- Reinicia o evento para que ele possa ser engatilhado novamente.
function M:reset()
  self._triggered = false
end

----
-- Indica se o evento já foi engatilhado.
-- @return O valor descrito.
function M:isTriggered()
  return self._triggered
end

----
-- (***@event***) Evento ao ser engatilhado.
function M:triggered()
end

return M
