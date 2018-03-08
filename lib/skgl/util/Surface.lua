--[[@meta]]
Surface = {
	__index = Surface,
	__name = "Surface"
}

--[[
- @return {number} Largura da tela.
--]]
function Surface.getScreenWidth()
	return 480
end

--[[
- @return {number} Altura da tela.
--]]
function Surface.getScreenHeight()
	return 272
end

--[[
- @return {number} Retorna a largura da imagem.
- @param {Image} img Imagem.
--]]
function Surface.getImageWidth(img)
	return image.getw(img)
end

--[[
- @return {number} Retorna a altura da imagem.
- @param {Image} img Imagem.
--]]
function Surface.getImageHeight(img)
	return image.geth(img)
end

--[[
- @return {Color} Retorna um objeto de cor RGBA.
- @param {number} r Vermelho (red).
- @param {number} g Verde (green).
- @param {number} b Azul (blue).
- @param {number} a Transparência (alpha).
--]]
function Surface.getColor(r, g, b, a)
	return color.new(r, g, b, (a or 255))
end

--[[
- Desenha um retângulo.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} width Largura do retângulo.
- @param {number} height Altura do retângulo.
- @param {Color} fillColor Cor de preenchimento (ver Surface.getColor()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawRect(x, y, width, height, fillColor, opacity)
	opacity = opacity or 1
	draw.rect(x, y, width, height, fillColor, color.a(fillColor, (opacity * 255)))
end

--[[
- Desenha um retângulo com preenchimento.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} width Largura do retângulo.
- @param {number} height Altura do retângulo.
- @param {Color} fillColor Cor de preenchimento (ver Surface.getColor()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawFillRect(x, y, width, height, fillColor, opacity)
	opacity = opacity or 1
	draw.fillrect(x, y, width, height, color.a(fillColor, (opacity * 255)))
end

--[[
- Desenha uma imagem completa na tela.
- @param {Image} img Imagem.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
--]]
function Surface.drawImage(img, x, y)
  image.blit(img, x, y)
end

--[[
- Desenha um pedaço de uma imagem na tela.
- @param {Image} img Imagem.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} xs Posição X inicial de corte.
- @param {number} ys Posição Y inicial de corte.
- @param {number} width Largura do pedaço.
- @param {number} height Altura do pedaço.
--]]
function Surface.drawImagePart(img, x, y, xs, ys, width, height)
  image.blit(img, x, y, xs, ys, width, height)
end

--[[
- Desenha um pedaço de uma imagem na tela, incluindo transparência.
- @param {Image} img Imagem.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} xs Posição X inicial de corte.
- @param {number} ys Posição Y inicial de corte.
- @param {number} width Largura do pedaço.
- @param {number} height Altura do pedaço.
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawImagePartExtended(img, x, y, xs, ys, width, height, opacity)
	opacity = opacity or 1
  image.blit(img, x, y, xs, ys, width, height, (opacity * 255))
end
