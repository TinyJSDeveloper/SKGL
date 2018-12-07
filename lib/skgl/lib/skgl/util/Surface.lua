--[[@meta]]
Surface = {
  name = "Surface"
}

-- @todo
Surface._drawCalls = 0

--[[
- @return {number} Retorna a largura da imagem.
-
- @param {Image} img Imagem.
--]]
function Surface.getImageWidth(img)
	return image.getw(img)
end

--[[
- @return {number} Retorna a altura da imagem.
-
- @param {Image} img Imagem.
--]]
function Surface.getImageHeight(img)
	return image.geth(img)
end

--[[
- Dados os valores de coordenada e dimensões, determina se eles estão dentro
- da tela.
-
- @param {number} x Posição X.
- @param {number} y Posição Y.
- @param {number} width Largura.
- @param {number} height Altura.
-
- @return {boolean}
--]]
function Surface.isInsideScreen(x, y, width, height)
  return (
    Display.getOffsetX(x) < Display.getWidth()  and Display.getOffsetX(x) + width  > Display.getX() and
    Display.getOffsetY(y) < Display.getHeight() and height + Display.getOffsetY(y) > Display.getY()
  )
end

--[[
- Desenha um retângulo na tela (somente bordas).
-
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} width Largura do retângulo.
- @param {number} height Altura do retângulo.
- @param {Color} fillColor Cor de preenchimento (ver Color:retrieve()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawRect(x, y, width, height, fillColor, opacity)
	draw.rect(Display.getOffsetX(x), Display.getOffsetY(y), width, height, fillColor, color.a(fillColor, (opacity * 255)))
end

--[[
- Desenha um retângulo na tela (totalmente preenchido).
-
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} width Largura do retângulo.
- @param {number} height Altura do retângulo.
- @param {Color} fillColor Cor de preenchimento (ver Color:retrieve()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawFillRect(x, y, width, height, fillColor, opacity)
	draw.fillrect(Display.getOffsetX(x), Display.getOffsetY(y), width, height, fillColor, color.a(fillColor, (opacity * 255)))
end

--[[
- Desenha um triângulo na tela (totalmente preenchido).
-
- @param {number} x1 Posição X do primeiro vértice.
- @param {number} y1 Posição Y do primeiro vértice.
- @param {number} x2 Posição X do segundo vértice.
- @param {number} y2 Posição Y do segundo vértice.
- @param {number} x3 Posição X do terceiro vértice.
- @param {number} y3 Posição Y do terceiro vértice.
- @param {Color} fillColor Cor de preenchimento (ver Color:retrieve()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawFillTriangle(x1, y1, x2, y2, x3, y3, fillColor, opacity)
  draw.filltriangle(x1, y1, x2, y2, x3, y3, fillColor, color.a(fillColor, (opacity * 255)))
end

--[[
- Desenha um quadrilátero na tela (totalmente preenchido).
-
- @param {number} x1 Posição X do primeiro vértice.
- @param {number} y1 Posição Y do primeiro vértice.
- @param {number} x2 Posição X do segundo vértice.
- @param {number} y2 Posição Y do segundo vértice.
- @param {number} x3 Posição X do terceiro vértice.
- @param {number} y3 Posição Y do terceiro vértice.
- @param {number} x4 Posição X do quarto vértice.
- @param {number} y4 Posição Y do quarto vértice.
- @param {Color} fillColor Cor de preenchimento (ver Color:retrieve()).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawFillQuad(x1, y1, x2, y2, x3, y3, x4, y4, fillColor, opacity)
  Surface.drawFillTriangle(x1, y1, x2, y2, x3, y3, fillColor, opacity)
  Surface.drawFillTriangle(x1, y1, x4, y4, x3, y3, fillColor, opacity)
end

--[[
- Desenha uma imagem completa na tela.
-
- @param {Image} img Imagem.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
--]]
function Surface.drawImage(img, x, y)
  image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y))
end

--[[
- Desenha uma imagem completa na tela, incluindo rotação e transparência.
-
- @param {Image} img Imagem.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} xo Posição X de origem (afeta a posição de desenho).
- @param {number} yo Posição Y de origem (afeta a posição de desenho).
- @param {number} xs Escala horizontal da imagem (deixe 1 para manter o tamanho normal).
- @param {number} ys Escala vertical da imagem (deixe 1 para manter o tamanho normal).
- @param {number} rotation Rotaçào (de 0 a 360).
- @param {number} opacity Transparência (de 0.0 a 1.0).
--]]
function Surface.drawImageExtended(img, x, y, xo, yo, xs, ys, rotation, opacity)
  -- Inverter imagem horizontalmente, caso a escala X tenha valor negativo:
  if xs < 0 then
    image.fliph(img)
  end

  -- Inverter imagem verticalmente, caso a escala Y tenha valor negativo:
  if ys < 0 then
    image.flipv(img)
  end

  image.resize(img, (Surface.getImageWidth(img) * math.abs(xs)), (Surface.getImageHeight(img) * math.abs(ys)))
  image.center(img, xo, yo)
  image.rotate(img, rotation)
  image.blit(img, x, y, (opacity * 255))
  image.reset(img)
end

--[[
- Desenha um pedaço de uma imagem na tela.
-
- @param {Image} img Imagem.
- @param {number} x Posição X de desenho.
- @param {number} y Posição Y de desenho.
- @param {number} xs Posição X inicial de corte.
- @param {number} ys Posição Y inicial de corte.
- @param {number} width Largura do pedaço.
- @param {number} height Altura do pedaço.
--]]
function Surface.drawImagePart(img, x, y, xs, ys, width, height)
  image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y), xs, ys, width, height)
end

--[[
- Desenha um pedaço de uma imagem na tela, incluindo transparência.
-
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
  if Surface.isInsideScreen(x, y, width, height) then
    image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y), xs, ys, width, height, (opacity * 255))
    Surface._drawCalls = (Surface._drawCalls + 1) -- @todo
  end
end

--[[
- Desenha todo o conteúdo gerado no decorrer do código, finalizando um frame.
--]]
function Surface.flip()
  --screen.print(200,0,tostring(Surface._drawCalls))
  screen.flip()
  Surface._drawCalls = 0 -- @todo
end
