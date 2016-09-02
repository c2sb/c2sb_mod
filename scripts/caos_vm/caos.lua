require("/scripts/caos_vm/constants.lua")
require("/scripts/util.lua")

----------------------
-- HELPER FUNCTIONS --
----------------------

function logInfo(fmt, ...)
  sb.logInfo("[%s:%s,%s,%s] "..fmt, entity.id(), self.family, self.genus, self.species, ...)
end

function updateImageFrame()
  assert(type(self.first_image) == "number", "first_image is not a number")
  assert(type(self.base_image) == "number", "base_image is not a number")
  assert(type(self.pose_image) == "number", "pose_image is not a number")
  animator.setGlobalTag("frame", tostring(self.first_image + self.base_image + self.pose_image))
end

function getv(variable)
  if (variable:len() ~= 4) then
    logInfo("getv invalid variable: %s", variable)
    return 0
  end
  
  local variable_name = variable:gsub("^%l", string.lower)
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
  else
    logInfo("getv has nil target, prefix: %s, number: %s", variable_prefix, variable_number)
    return 0
  end
end


function remote_getv(variable_id)
  self.variables = self.variables or {}
  return self.variables[variable_id] or 0
end

-- This can be used to alter the tick behaviour if agents execute too quickly or slowly
-- NOTE: It's noted that a creatures tick is about 50ms (1/20 of a second). Starbound is timed in seconds (as a float value).
function c2sb_ticks(ticks)
  return ticks / 60.0
end

function bool_to_int(value)
  if value then
    return 1
  end
  return 0
end

function matches_species(family, genus, species)
  if family ~= 0 and family ~= self.family then
    return false
  end
  
  if genus ~= 0 and genus ~= self.genus then
    return false
  end
  
  return species == 0 or species == self.species
end

function esee_wrap(family, genus, species, fcn_callback)
  local target = nil
  local radius = nil
  if (self.OWNR ~= nil) then
    target = self.OWNR
    radius = self.range_check
  else
    target = self.TARG
    radius = rnge()
  end
  if (target == nil) then return {} end
  
  local entities = world.entityQuery(world.entityPosition(target), radius, {
    withoutEntityId = target,
    callScript = "matches_species",
    callScriptArgs = { family, genus, species }
  })
  
  local originalTarg = self.TARG
  for entity in entities do
    self.TARG = entity
    fcn_callback()
  end
  self.TARG = originalTarg
end

function init_scriptorium_space(family, genus, species)
  if scriptorium == nil then scriptorium = {} end
  if scriptorium[family] == nil then scriptorium[family] = {} end
  if scriptorium[family][genus] == nil then scriptorium[family][genus] = {} end
  if scriptorium[family][genus][species] == nil then scriptorium[family][genus][species] = {} end
end

--------------------
-- CAOS FUNCTIONS --
--------------------

function scrp(family, genus, species, event, fcn_callback)
  --sb.logInfo("scrp %s %s %s %s", family, genus, species, event)
  init_scriptorium_space(family, genus, species)
  scriptorium[family][genus][species][event] = fcn_callback
end

function new_simp(family_, genus_, species_, sprite_file_, image_count_, first_image_, plane_)
  logInfo("new: simp %s %s %s \"%s\" %s %s %s", family_, genus_, species_, sprite_file_, image_count_, first_image_, plane_)
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
  logInfo("attr %s", flags)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_attr", flags)
end

function elas(elasticity_percentage)
  logInfo("elas %s", elasticity_percentage)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_elas", elasticity_percentage)
end

function fric(friction)
  logInfo("fric %s", friction)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_fric", friction)
end

function accg(gravity_pixels)
  logInfo("accg %s", gravity_pixels)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_accg", gravity_pixels)
end

function perm(permiability)
  logInfo("perm %s", permiability)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_perm", permiability)
end

function pose(pose_index)
  logInfo("pose %s", pose_index)
  if (self.TARG == nil) then return end
  return world.callScriptedEntity(self.TARG, "remote_pose", pose_index)
end

function setv(variable, value)
  logInfo("setv %s %s", variable, value)
  if (variable:len() ~= 4) then
    logInfo("setv invalid variable: %s", variable)
    return
  end
  
  local variable_name = variable:gsub("^%l", string.lower)
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
  logInfo("tick %s", tick_rate)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_tick", tick_rate)
end

function rand(value1, value2)
  logInfo("rand %s %s", value1, value2)
  return sb.staticRandomI32Range(value1, value2)
end

function wait(ticks)
  logInfo("wait %s", ticks)
  local actual_ticks = c2sb_ticks(ticks)
  util.wait(actual_ticks)
end

function kill(target)
  logInfo("kill %s", target)
  world.callScriptedEntity(target, "remote_kill")
end

function posx()
  logInfo("posx")
  if (self.TARG == nil) then return 0 end
  return world.callScriptedEntity(self.TARG, "remote_posx")
end

function posy()
  logInfo("posy")
  if (self.TARG == nil) then return 0 end
  return world.callScriptedEntity(self.TARG, "remote_posy")
end

function addv(variable, value)
  logInfo("addv %s %s", variable, value)
  setv(variable, getv(variable) + value)
end

function velo(x_velocity, y_velocity)
  logInfo("velo %s %s", x_velocity, y_velocity)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_velo", x_velocity, y_velocity)
end

function fall()
  logInfo("fall")
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_fall")
end

-- Not implemented
function carr()
  logInfo("carr")
  return nil
end

function rnge(range)
  logInfo("rnge %s", range)
  if (self.TARG == nil) then return end
  return world.callScriptedEntity(self.TARG, "remote_rnge", range)
end

function targ(target)
  logInfo("targ %s", target)
  if target ~= nil then
    self.TARG = target
  end
  return self.TARG
end

function ownr()
  logInfo("ownr")
  return self.OWNR
end

---------------------------
-- CAOS REMOTE FUNCTIONS --
---------------------------

function remote_attr(flags)
  if (flags & CAOS.ATTRIBUTES.CARRYABLE) ~= 0 then
    -- TODO
  end
  if (flags & CAOS.ATTRIBUTES.MOUSEABLE) ~= 0 then
    -- TODO
  end
  
  -- CAOS.ATTRIBUTES.ACTIVATEABLE
  monster.setInteractive((flags & CAOS.ATTRIBUTES.ACTIVATEABLE) ~= 0)
  
  if (flags & CAOS.ATTRIBUTES.GREEDY_CABIN) ~= 0 then
    -- TODO
  end
  if (flags & CAOS.ATTRIBUTES.INVISIBLE) ~= 0 then
    -- TODO
  end
  if (flags & CAOS.ATTRIBUTES.FLOATABLE) ~= 0 then
    -- TODO
  end
  
  -- CAOS.ATTRIBUTES.SUFFER_COLLISIONS
  mcontroller.controlParameters({
    collisionEnabled = (flags & CAOS.ATTRIBUTES.SUFFER_COLLISIONS) ~= 0
  })
  
  -- CAOS.ATTRIBUTES.SUFFER_PHYSICS
  mcontroller.controlParameters({
    gravityEnabled = (flags & CAOS.ATTRIBUTES.SUFFER_PHYSICS) ~= 0
  })
  
  if (flags & CAOS.ATTRIBUTES.CAMERA_SHY) ~= 0 then
    -- TODO
  end
  if (flags & CAOS.ATTRIBUTES.OPEN_AIR_CABIN) ~= 0 then
    -- TODO
  end
  if (flags & CAOS.ATTRIBUTES.ROTATABLE) ~= 0 then
    -- TODO
  end
  if (flags & CAOS.ATTRIBUTES.PRESENCE) ~= 0 then
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
    self.last_tick_time = world.time()
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

function remote_velo(x_velocity, y_velocity)
  return mcontroller.setVelocity({x_velocity, y_velocity})
end

function remote_fall()
  return bool_to_int(mcontroller.falling())
end

function remote_rnge(range)
  if range ~= nil then
    self.range_check = range
  end
  return self.range_check
end
