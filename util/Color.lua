--[[@meta]]
Color = {
  name = "Color"
}

function Color.new(r, g, b)
  --[[@meta]]
  local _self = {
    class = Color
  }

  -- Canal de cor vermelho.
  _self.r = r or 0

  -- Canal de cor amarelo.
  _self.g = g or 0

  -- Canal de cor azul.
  _self.b = b or 0

  --[[
  - Ajusta um valor para que ele seja válido como um canal RGB. O valor
  - retornado deve permanecer entre 0 e 255.
  -
  - @param {number} channel Canal de cor.
  - @return {number}
  --]]
  function _self:adjustChannel(channel)
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
  function _self:retrieve()
    self.r = self:adjustChannel(self.r)
    self.g = self:adjustChannel(self.g)
    self.b = self:adjustChannel(self.b)

    local colorObject = color.new(self.r, self.g, self.b)
    return colorObject
  end

  return _self
end
