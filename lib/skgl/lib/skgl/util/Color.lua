--[[@meta]]
Color = {
  name = "Color"
}

--[[
- @class Color
-
- @param {number} r Canal de cor vermelho.
- @param {number} g Canal de cor verde.
- @param {number} b Canal de cor azul.
--]]
function Color.new(r, g, b)
  --[[@meta]]
  local def = {
    class = Color
  }

  --[[
  - @constructor
  --]]
  function def:__init__()
    -- Canal de cor vermelho.
    self.r = r or 0

    -- Canal de cor verde.
    self.g = g or 0

    -- Canal de cor azul.
    self.b = b or 0
  end

  --[[
  - Ajusta um valor para que ele seja válido como um canal RGB. O valor
  - retornado deve permanecer entre 0 e 255.
  -
  - @param {number} channel Canal de cor.
  -
  - @return {number}
  --]]
  function def:adjustChannel(channel)
    if channel < 0 then
      return 0
    elseif channel > 255 then
      return 255
    end

    return channel
  end

  --[[
  - Obtém um objeto de cor usado pelo ONELua, usando como base os valores
  - (cores) deste objeto.
  -
  - @return {object}
  --]]
  function def:retrieve()
    self.r = self:adjustChannel(self.r)
    self.g = self:adjustChannel(self.g)
    self.b = self:adjustChannel(self.b)

    local colorObject = color.new(self.r, self.g, self.b)
    return colorObject
  end

  def:__init__()
  return def
end
