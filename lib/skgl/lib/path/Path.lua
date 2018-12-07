--[[@meta]]
Path = {
  name = "Path"
}

-- @private Diretório-raíz do interpretador Lua.
Path._root = files.cdir()

-- @private Diretório de bibliotecas.
Path._libraries = Path._root.."/lib"

-- @private Diretório de scripts/workspace.
Path._scripts = Path._root.."/scripts"

-- @private Diretório do projeto atual.
Path._project = Path._root

-- @private Diretório de dados do projeto atual.
Path._data = Path._project.."/data"

-- @private Diretório de código-fonte do projeto atual.
Path._src = Path._project.."/src"

--[[
- Diretório-raíz do interpretador Lua.
-
- @return {string}
--]]
function Path.root()
  return Path._root
end

--[[
- Diretório de bibliotecas.
-
- @return {string}
--]]
function Path.libraries()
  return Path._libraries
end

--[[
- Diretório de scripts/workspace.
-
- @return {string}
--]]
function Path.scripts()
  return Path._scripts
end

--[[
- Diretório do projeto atual.
-
- @return {string}
--]]
function Path.project()
  return Path._project
end

--[[
- Diretório de dados do projeto atual.
-
- @return {string}
--]]
function Path.data()
  return Path._data
end

--[[
- Diretório de código-fonte do projeto atual.
-
- @return {string}
--]]
function Path.src()
  return Path._src
end

--[[
- Carrega uma biblioteca. O diretório deve conter um arquivo "require.lua".
-
- @param {string} library Nome da pasta da biblioteca.
--]]
function Path.require(library)
  dofile(Path.libraries().."/"..library.."/require.lua")
end

--[[
- Abre um projeto. O diretório deve conter um arquivo "script.lua".
-
- @param {string} project Nome da pasta do projeto.
- @param {string} data Nome da pasta de dados (o padrão é "data").
- @param {string} src Nome da pasta de código-fonte (o padrão é "src").
--]]
function Path.open(project, data, src)
  Path._project = Path._scripts.."/"..project
  Path._data = Path._project.."/"..(data or "data")
  Path._src = Path._project.."/"..(src or "src")

  dofile(Path._project.."/script.lua")
end

--[[
- Importa vários arquivos de uma pasta especificada para o projeto, usando como
- base o diretório da pasta de código-fonte.
-
- @param {string} package Nome da pasta do pacote. Pode-se deixar o valor nulo
- para carregar todos os arquivos contidos na própria base do diretório.
--]]
function Path.import(package)
  local importFiles = files.listfiles(Path._src.."/"..(package or ""))

  for key, value in pairs(importFiles) do
    if value.ext == string.lower("lua") then
      dofile(value.path)
    end
  end
end
