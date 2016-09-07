
function playSoundFile(sound_file, repeats, channel)
  repeats = repeats or 0
  channel = channel or 0
  animator.setSoundPool("channel"..channel, {"/agents/sounds/"..sound_file..".ogg"})
  animator.playSound("channel"..channel, repeats)
end

function stopSounds(channel)
  channel = channel or 0
  animator.stopAllSounds("channel"..channel)
end

function setVolume(volume, duration, channel)
  duration = duration or 0
  channel = channel or 0

  animator.setSoundVolume("channel"..channel, volume, duration)
end

--------------------
-- CAOS FUNCTIONS --
--------------------

-- Fade out a controlled sound.
CAOS.TargCmd("fade", function()
  setVolume(0, 1.0)
end)

-- Plays a controlled sound effect emitted from the target. Updates volume and panning as the agent moves.
CAOS.TargCmd("sndc", function(sound_file)
  playSoundFile(sound_file)
end)

-- Play a sound effect audible as if emitted from target's current location.
CAOS.Cmd("snde", function(sound_file)
  sndc(sound_file)
end)

-- Play a sound effect as in SNDC, only the sound is looped.
CAOS.TargCmd("sndl", function(sound_file)
  playSoundFile(sound_file, -1)
end)

-- Stops a controlled sound.
CAOS.TargCmd("stpc", function()
  stopSounds()
end)
