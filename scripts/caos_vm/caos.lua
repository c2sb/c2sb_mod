require("/scripts/caos_vm/constants.lua")
require("/scripts/util.lua")
self.TARG = nil
self.OWNR = nil

----------------------
-- HELPER FUNCTIONS --
----------------------

function updateImageFrame()
  animator.setGlobalTag("frame", tostring(self.first_image + self.base_image + self.pose_image))
end

function getv(variable)
  if (variable:len() ~= 4) then return
  
  local variable_name = variable:gsub("^%l", string.upper)
  local variable_prefix = variable_name:sub(1, 2)
  local variable_number = variable_name:sub(3, 4)
  
  local target = nil
  if (variable_prefix == "ov") then
    target = self.TARG
  elseif (variable_prefix == "mv") then
    target = self.OWNR
  elseif (variable_prefix == "va") then
    return self[variable_name] or 0
  end
  
  if (target ~= nil) then
    return world.callScriptedEntity(target, "remote_getv", variable_number)
  end
end


function remote_getv(variable_id)
  self.variables = self.variables or {}
  return self.variables[variable_id] or 0
end

-- I don't know what a Starbound tick is, so just assume it's one second
-- This can be used to alter the tick behaviour if agents execute too quickly
-- NOTE: It's noted that a creatures tick is about 50ms (1/20 of a second)
function c2sb_ticks(ticks)
  return ticks / 20.0
end

--------------------
-- CAOS FUNCTIONS --
--------------------

function new_simp(family_, genus_, species_, sprite_file_, image_count_, first_image_, plane_)
  self.TARG = world.spawnMonster("test_agent", mcontroller.position(), {
    family = family_,
    genus = genus_,
    species = species_,
    sprite_file = sprite_file_,
    image_count = image_count_,
    first_image = first_image_,
    plane = plane_
  })
end

function attr(flags)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_attr", flags)
end

function elas(elasticity_percentage)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_elas", elasticity_percentage)
end

function fric(friction)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_fric", friction)
end

function accg(gravity_pixels)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_accg", gravity_pixels)
end

function perm(permiability)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_perm", permiability)
end

function pose(pose_index)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_pose", pose_index)
end

function setv(variable, value)
  if (variable:len() ~= 4) then return
  
  local variable_name = variable:gsub("^%l", string.upper)
  local variable_prefix = variable_name:sub(1, 2)
  local variable_number = variable_name:sub(3, 4)
  
  local target = nil
  if (variable_prefix == "ov") then
    target = self.TARG
  elseif (variable_prefix == "mv") then
    target = self.OWNR
  elseif (variable_prefix == "va") then
    self[variable_name] = value
  end
  
  if (target ~= nil) then
    world.callScriptedEntity(target, "remote_setv", variable_number, value)
  end
end

function tick(tick_rate)
  if (self.TARG == nil) then return
  world.callScriptedEntity(self.TARG, "remote_tick", tick_rate)
end

function rand(value1, value2)
  return sb.staticRandomI32Range(value1, value2)
end

function wait(ticks)
  local actual_ticks = c2sb_ticks(ticks)
  util.wait(actual_ticks)
end

function kill(target)
  world.callScriptedEntity(target, "remote_kill")
end

function posx()
  if (self.TARG == nil) then return 0
  return world.callScriptedEntity(self.TARG, "remote_posx")
end

function posy()
  if (self.TARG == nil) then return 0
  return world.callScriptedEntity(self.TARG, "remote_posy")
end

---------------------------
-- CAOS REMOTE FUNCTIONS --
---------------------------

function remote_attr(flags)
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.CARRYABLE) ~= 0 ) then
    -- TODO
  end
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.MOUSEABLE) ~= 0 ) then
    -- TODO
  end
  
  -- CAOS.ATTRIBUTES.ACTIVATEABLE
  monster.setInteractive(bit32.band(attributes, CAOS.ATTRIBUTES.ACTIVATEABLE) ~= 0)
  
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.GREEDY_CABIN) ~= 0 ) then
    -- TODO
  end
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.INVISIBLE) ~= 0 ) then
    -- TODO
  end
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.FLOATABLE) ~= 0 ) then
    -- TODO
  end
  
  -- CAOS.ATTRIBUTES.SUFFER_COLLISIONS
  mcontroller.controlParameters({
    collisionEnabled = (bit32.band(attributes, CAOS.ATTRIBUTES.SUFFER_COLLISIONS) ~= 0)
  })
  
  -- CAOS.ATTRIBUTES.SUFFER_PHYSICS
  mcontroller.controlParameters({
    gravityEnabled = (bit32.band(attributes, CAOS.ATTRIBUTES.SUFFER_PHYSICS) ~= 0)
  })
  
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.CAMERA_SHY) ~= 0 ) then
    -- TODO
  end
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.OPEN_AIR_CABIN) ~= 0 ) then
    -- TODO
  end
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.ROTATABLE) ~= 0 ) then
    -- TODO
  end
  if ( bit32.band(attributes, CAOS.ATTRIBUTES.PRESENCE) ~= 0 ) then
    -- TODO
  end
end

function remote_elas(elasticity_percentage)
  mcontroller.controlParameters({bounceFactor = elasticity_percentage / 100.0})
end

function remote_fric(friction)
  mcontroller.controlParameters({groundFriction = friction})
end

function remote_accg(gravity_pixels)
  mcontroller.controlParameters({gravityMultiplier = gravity_pixels / world.gravity(mcontroller.position()) })
end

function remote_perm(permiability)
  self.perm = permiability
  -- TODO other stuff
end

function remote_pose(pose_index)
  if (pose_index ~= nil) then
    self.pose_image = pose_index
    updateImageFrame()
  end
  return self.pose_image
end

function remote_setv(variable_id, value)
  self.variables = self.variables or {}
  self.variables[variable_id] = value
end

function remote_tick(tick_rate)
  if (tick_rate ~= nil) then
    self.tick_rate = tick_rate
  end
  return self.tick_rate
end

function remote_kill()
  self.killed = true
end

function remote_posx()
  return mcontroller.xPosition()
end

function remote_posy()
  return mcontroller.yPosition()
end

