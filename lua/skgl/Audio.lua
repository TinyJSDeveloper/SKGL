----
-- Representa um objeto de áudio, mas não substitui o `sound` do *ONELua*;
-- este objeto é usado apenas para pré-carregamento, em um `skgl.AssetManager`.
--
-- O áudio funciona melhor com *bitrate* de 128kbps.
--
-- @classmod skgl.Audio
local class = require("middleclass")
local M = class("skgl.Audio")

----
-- Construtor da classe.
-- @param path (***string***) Diretório completo do recurso.
-- @param id (***string***) Identificador dado a este recurso.
function M:initialize(path, id)
  --- Diretório completo do recurso.
  self.path = path or nil

  --- ID deste recurso.
  self.id = id or nil

  --- Recurso real.
  self.resource = nil

  --- Indica se o carregamento já foi requisitado.
  self.loading = false
end

----
-- Carrega o recurso.
function M:load()
  if not self.loading then
    self.resource = sound.load(self.path)
    self.loading = true
  end
end

----
-- Obtém este recurso.
-- @return O valor descrito.
function M:get()
  return self.resource
end

return M
