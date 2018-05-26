--[[@meta]]
Display = {
  name = "Display"
}

--[[
- Obtém a dimensão de largura da tela.
-
- @return {number} Retorna a dimensão de largura da tela.
--]]
function Display.getWidth()
	return 480
end

--[[
- Obtém a dimensão de altura da tela.
-
- @return {number} Retorna a dimensão de altura da tela.
--]]
function Display.getHeight()
	return 272
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
