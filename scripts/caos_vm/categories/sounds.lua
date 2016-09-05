
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
function fade()
  world.callScriptedEntity(self.TARG, "setVolume", 0, 2.0)
end

-- Plays a controlled sound effect emitted from the target. Updates volume and panning as the agent moves.
function sndc(sound_file)
  -- TODO load string variables
  world.callScriptedEntity(self.TARG, "playSoundFile", sound_file)
end

-- Play a sound effect audible as if emitted from target's current location.
function snde(sound_file)
  -- TODO load string variables
  sndc(sound_file)
end

-- Play a sound effect as in SNDC, only the sound is looped.
function sndl(sound_file)
  -- TODO load string variables
  world.callScriptedEntity(self.TARG, "playSoundFile", sound_file, -1)
end

-- Stops a controlled sound.
function stpc()
  world.callScriptedEntity(self.TARG, "stopSounds")
end
