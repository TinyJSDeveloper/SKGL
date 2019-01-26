----
-- Abstração do `color` do *ONELua*; representa uma cor RGB (sem o *alpha*) e
-- permite a alteração de seus valores diretamente, sem o uso de funções.
--
-- @classmod skgl.Color
local class = require("middleclass")
local M = class("skgl.Color")

----
-- Construtor da classe.
-- @param r (***number***) Canal de cor vermelho.
-- @param g (***number***) Canal de cor verde.
-- @param b (***number***) Canal de cor azul.
-- @function new
function M:initialize(r, g, b)
  --- Canal de cor vermelho.
  self.r = r or 0

  --- Canal de cor verde.
  self.g = g or 0

  --- Canal de cor azul.
  self.b = b or 0

  -- @private Cache do último objeto de cor gerado.
  self._cache = nil
end

-- Ajusta um valor para que ele seja válido como um canal RGB. O valor
-- retornado deve permanecer entre 0 e 255.
-- @param channel (***number***) Canal de cor.
-- @return O valor do canal de cor com seu valor ajustado (entre 0 e 255).
function M:adjustChannel(channel)
  if channel < 0 then
    return 0
  elseif channel > 255 then
    return 255
  end

  return channel
end

----
-- Obtém um objeto `color` do *ONELua*, usando como base os mesmos valores
-- (cores) deste objeto.
-- @return O valor descrito.
function M:retrieve()
  self.r = self:adjustChannel(self.r)
  self.g = self:adjustChannel(self.g)
  self.b = self:adjustChannel(self.b)

  if self._cache ~= nil then
    if color.r(self._cache) == self.r and
       color.g(self._cache) == self.g and
       color.b(self._cache) == self.b then
      return self._cache
    end
  end

  self._cache = color.new(self.r, self.g, self.b)
  return self._cache
end

return M
