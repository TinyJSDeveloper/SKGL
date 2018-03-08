--[[@meta]]
Audio = {
	__index = Audio,
	__name = "Audio"
}

--[[
- Reproduz um som.
- @param {Sound} snd Som.
- @param {boolean} loop Loop (true/false).
--]]
function Audio.play(snd, loop)
  loop = loop or false
  sound.play(snd)

  if sound.looping(snd) != loop then
    sound.looping()
  end
end

function Audio.stop(snd)
	-- @todo
end

function Audio.pause(snd)
	-- @todo
end
