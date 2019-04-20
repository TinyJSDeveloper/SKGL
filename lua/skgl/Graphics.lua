----
-- Módulo de funções gráficas; usado por toda a biblioteca para desenhar
-- imagens, retângulos, partes de imagens (para *spritesheets*), etc.
--
-- Dependencies: `skgl.Display`
-- @module skgl.Graphics
local Display = require("skgl.Display")
local M = {
	rectangle = {}, -- Funções de desenho envolvendo quadrados e retângulos.
	triangle  = {}, -- Funções de desenho envolvendo triângulos.
	quad      = {}, -- Funções de desenho envolvendo quadriláteros.
	image     = {}, -- Funções de desenho envovlendo imagens.
	screen    = {}  -- Funções envolvendo a tela.
}

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
function M.rectangle.draw(x, y, width, height, fillColor, opacity)
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
function M.rectangle.fill(x, y, width, height, fillColor, opacity)
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
function M.triangle.fill(x1, y1, x2, y2, x3, y3, fillColor, opacity)
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
function M.quad.fill(x1, y1, x2, y2, x3, y3, x4, y4, fillColor, opacity)
  M.triangle.fill(x1, y1, x2, y2, x3, y3, fillColor, opacity)
  M.triangle.fill(x1, y1, x4, y4, x3, y3, fillColor, opacity)
end

----
-- Desenha uma imagem completa na tela.
-- @param img (`Image`) Imagem.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
function M.image.draw(img, x, y)
  image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y))
end

----
-- Desenha uma imagem completa na tela, incluindo rotação e transparência.
-- @param img (`Image`) Imagem.
-- @param x (***number***) Posição X de desenho.
-- @param y (***number***) Posição Y de desenho.
-- @param xs (***number***) Escala horizontal da imagem (deixe 1 para manter o tamanho normal).
-- @param ys (***number***) Escala vertical da imagem (deixe 1 para manter o tamanho normal).
-- @param rotation (***number***) Rotaçào (de 0 a 360).
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
-- @param autoCenterOrigins (***boolean***) Quando ativado, centraliza as posições de origem da imagem automaticamente. O valor padrão é "`true`".
-- @param xo (***number***) Posição X de origem (afeta a posição de desenho).
-- @param yo (***number***) Posição Y de origem (afeta a posição de desenho).
function M.image.drawExtended(img, x, y, xs, ys, rotation, opacity, autoCenterOrigins, xo, yo)
  -- Inverter imagem horizontalmente, caso a escala X tenha valor negativo:
  if xs < 0 then
    image.fliph(img)
  end

  -- Inverter imagem verticalmente, caso a escala Y tenha valor negativo:
  if ys < 0 then
    image.flipv(img)
  end

	-- Observação:
	--
	-- Por alguma razão, usar a função "image.fliph()" antes destas
	-- faz o jogo travar. Sendo assim, para manter a funcionalidade quando for
	-- necessário, infelizmente uma anulará as outras e vice-versa.
	if xs >= 0 then

		-- Centralizar imagem com base nas posições de origem. Opcionalmente, os
		-- valores também podem ser definidos manualmente:
		if autoCenterOrigins == false then
			image.center(img, (xo or 0), (yo or 0))
		else
			image.center(img, (M.getImageWidth(img) / 2), (M.getImageHeight(img) / 2))
		end

		-- Rotacionar imagem:
		image.rotate(img, rotation)

	-- Quando uma das funcionalidades puder ser reimplementada para funcionar
	-- junto com a "image.fliph()", ela será executada aqui.
	else

		-- Centralizar imagem com base nas posições de origem:
		x = x + ((M.getImageWidth(img)  * xs) / 2)
		if ys < 0 then y = y + ((M.getImageHeight(img) * ys) / 2)
							else y = y - ((M.getImageHeight(img) * ys) / 2) end

	end

	-- Redimensionar imagem:
	image.resize(img, (M.getImageWidth(img) * math.abs(xs)), (M.getImageHeight(img) * math.abs(ys)))

	-- Desenhar imagem:
	--image.blit(img, (x - xo), (y - yo), (opacity * 255))
	image.blit(img, x, y, (opacity * 255))

	-- Reverter alterações feitas na imagem:
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
function M.image.part(img, x, y, xs, ys, width, height)
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
function M.image.partExtended(img, x, y, xs, ys, width, height, opacity)
  if M.isInsideScreen(x, y, width, height) then
    image.blit(img, Display.getOffsetX(x), Display.getOffsetY(y), xs, ys, width, height, (opacity * 255))
  end
end

----
-- Desenha uma cor de fundo para a tela.
-- @param fillColor (`skgl.Color`) Cor de preenchimento.
-- @param opacity (***number***) Transparência (de 0.0 a 1.0).
function M.screen.fill(fillColor, opacity)
  M.rectangle.fill(0, 0, Display.getWidth(), Display.getHeight(), fillColor, opacity)
end

----
-- Desenha todo o conteúdo gerado no decorrer do código, finalizando um *frame*.
function M.screen.flip()
  screen.flip()
end

return M
