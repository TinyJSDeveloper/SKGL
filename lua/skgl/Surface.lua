----
-- Módulo de funções gráficas; usado por toda a biblioteca para desenhar
-- imagens, retângulos, partes de imagens (para *spritesheets*), etc.
--
-- Dependencies: `skgl.Display`
-- @module skgl.Surface
local Display = require("skgl.Display")
local M = {}

----
-- Obtém a largura de uma imagem.
-- @param img (`Image`) Imagem.
-- @return O valor descrito.
function M.getImageWidth(img)
	return image.getw(img)
end

----
-- Obtém a altura de uma imagem.
-- @param img (`Image`) Imagem.
-- @return O valor descrito.
function M.getImageHeight(img)
	return image.geth(img)
end

----
-- Dados os valores de coordenada e dimensões, determina se eles estão dentro
-- da tela.
-- @param x (***number***) Posição X.
-- @param y (***number***) Posição Y.
-- @param width (***number***) Largura.
-- @param height (***number***) Altura.
function M.isInsideScreen(x, y, width, height)
  return (
    Display.getOffsetX(x) < Display.getWidth()  and Display.getOffsetX(x) + width  > Display.getX() and
    Display.getOffsetY(y) < Display.getHeight() and height + Display.getOffsetY(y) > Display.getY()
  )
end

----
-- Desenha um retângulo na tela (somente bordas).
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param width (***number***) Largura do retângulo.
-- @param height (***number***) Altura do retângulo.
-- @param fillColor (`skgl.Color`) Cor de preenchimento.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawRect(x, y, width, height, fillColor, opacity)
	fillColor = fillColor:retrieve()
	draw.rect(Display.getOffsetX(x), Display.getOffsetY(y), width, height, color.a(fillColor, (opacity * 255)))
end

----
-- Desenha um retângulo na tela (totalmente preenchido).
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param width (***number***) Largura do retângulo.
-- @param height (***number***) Altura do retângulo.
-- @param fillColor (`skgl.Color`) Cor de preenchimento.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawFillRect(x, y, width, height, fillColor, opacity)
	fillColor = fillColor:retrieve()
	draw.fillrect(Display.getOffsetX(x), Display.getOffsetY(y), width, height, color.a(fillColor, (opacity * 255)))
end

----
-- Desenha um triângulo na tela (totalmente preenchido).
-- @param x1 (***number***) Posição X do primeiro vértice.
-- @param y1 (***number***) Posição Y do primeiro vértice.
-- @param x2 (***number***) Posição X do segundo vértice.
-- @param y2 (***number***) Posição Y do segundo vértice.
-- @param x3 (***number***) Posição X do terceiro vértice.
-- @param y3 (***number***) Posição Y do terceiro vértice.
-- @param fillColor (`skgl.Color`) Cor de preenchimento.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawFillTriangle(x1, y1, x2, y2, x3, y3, fillColor, opacity)
	fillColor = fillColor:retrieve()
  draw.filltriangle(x1, y1, x2, y2, x3, y3, color.a(fillColor, (opacity * 255)))
end

----
-- Desenha um quadrilátero na tela (totalmente preenchido).
-- @param x1 (***number***) Posição X do primeiro vértice.
-- @param y1 (***number***) Posição Y do primeiro vértice.
-- @param x2 (***number***) Posição X do segundo vértice.
-- @param y2 (***number***) Posição Y do segundo vértice.
-- @param x3 (***number***) Posição X do terceiro vértice.
-- @param y3 (***number***) Posição Y do terceiro vértice.
-- @param x4 (***number***) Posição X do quarto vértice.
-- @param y4 (***number***) Posição Y do quarto vértice.
-- @param fillColor (`skgl.Color`) Cor de preenchimento.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawFillQuad(x1, y1, x2, y2, x3, y3, x4, y4, fillColor, opacity)
  M.drawFillTriangle(x1, y1, x2, y2, x3, y3, fillColor, opacity)
  M.drawFillTriangle(x1, y1, x4, y4, x3, y3, fillColor, opacity)
end

----
-- Desenha uma imagem completa na tela.
-- @param img (`Image`) Imagem.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
function M.drawImage(img, x, y)
  image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y))
end

----
-- Desenha uma imagem completa na tela, incluindo rotação e transparência.
-- @param img (`Image`) Imagem.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param xo (***number***) Posição X de origem (afeta a posição de desenho).
-- @param yo (***number***) Posição Y de origem (afeta a posição de desenho).
-- @param xs (***number***) Escala horizontal da imagem (deixe 1 para manter o tamanho normal).
-- @param ys (***number***) Escala vertical da imagem (deixe 1 para manter o tamanho normal).
-- @param rotation (***number***) Rotaçào (de 0 a 360).
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawImageExtended(img, x, y, xo, yo, xs, ys, rotation, opacity)
  -- Inverter imagem horizontalmente, caso a escala X tenha valor negativo:
  if xs < 0 then
    image.fliph(img)
  end

  -- Inverter imagem verticalmente, caso a escala Y tenha valor negativo:
  if ys < 0 then
    image.flipv(img)
  end

  image.resize(img, (M.getImageWidth(img) * math.abs(xs)), (M.getImageHeight(img) * math.abs(ys)))
  --image.center(img, xo, yo) -- Por alguma razão, isto resulta em crash quando a escala é negativa.
  image.rotate(img, rotation)
  --image.blit(img, x, y, (opacity * 255)) -- Para resolvar o problema acima, esta função foi modificada (ver linha abaixo).
  image.blit(img, (x - xo), (y - yo), (opacity * 255))
  image.reset(img)
end

----
-- Desenha um pedaço de uma imagem na tela.
-- @param img (`Image`) Imagem.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param xs (***number***) Posição X inicial de corte.
-- @param ys (***number***) Posição Y inicial de corte.
-- @param width (***number***) Largura do pedaço.
-- @param height (***number***) Altura do pedaço.
function M.drawImagePart(img, x, y, xs, ys, width, height)
  image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y), xs, ys, width, height)
end

----
-- Desenha um pedaço de uma imagem na tela, incluindo transparência.
-- @param img (`Image`) Imagem.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param xs (***number***) Posição X inicial de corte.
-- @param ys (***number***) Posição Y inicial de corte.
-- @param width (***number***) Largura do pedaço.
-- @param height (***number***) Altura do pedaço.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawImagePartExtended(img, x, y, xs, ys, width, height, opacity)
  if M.isInsideScreen(x, y, width, height) then
    image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y), xs, ys, width, height, (opacity * 255))
  end
end

----
-- Desenha uma cor de fundo para a tela.
-- @param fillColor (`skgl.Color`) Cor de preenchimento.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.drawBackground(fillColor, opacity)
  M.drawFillRect(0, 0, Display.getWidth(), Display.getHeight(), fillColor, opacity)
end

----
-- Desenha todo o conteúdo gerado no decorrer do código, finalizando um *frame*.
function M.flip()
  screen.flip()
end

return M
