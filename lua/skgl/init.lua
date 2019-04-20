local M = {}

M.Class = require("middleclass")

M.Asset = require("skgl.Audio")
M.Image == require("skgl.Image")

M.AssetManager = require("skgl.AssetManager")
M.Event = require("skgl.Event")
M.LoadingScene = require("skgl.LoadingScene")

M.BoundingBox = require("skgl.BoundingBox")

M.Group = require("skgl.Group")
M.Scene = require("skgl.Scene")
M.Core = require("skgl.Core")

M.GBATileMap = require("skgl.GBATileMap")
M.Sprite = require("skgl.Sprite")
M.SpriteFont = require("skgl.SpriteFont")
M.TileMap = require("skgl.TileMap")
M.TileSprite = require("skgl.TileSprite")

M.Array = require("skgl.Array")
M.Clock = require("skgl.Clock")
M.Color = require("skgl.Color")
M.Display = require("skgl.Display")
M.Graphics = require("skgl.Graphics")
M.Input = require("skgl.Input")

function M:import(t)
  for key, value in pairs(self) do
    if key ~= "import" then
      _G[key] = value
    end
  end
end

return M
