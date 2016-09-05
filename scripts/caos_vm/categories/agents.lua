--------------------
-- CAOS FUNCTIONS --
--------------------

-- Set attributes of target. Sum the values in the Attribute Flags table to get the attribute value to pass into this command.
function attr(attributes)
  return caos_targfunction_wrap1("attr", attributes)
end

function remote_attr(flags)
  if flags ~= nil then
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
    
    self.attribute_flags = flags
  end
  return self.attribute_flags
end

-- Set the base image for this agent or part. The index is relative to the first_image specified in
-- the NEW: command. Future POSE/ANIM commands and any ANIM in progress are relative to this new base.
-- Returns the BASE image for the current agent/part. Returns -1 if an invalid part.
function base(index)
  logInfo("base %s", name, index)
  if index ~= nil then
    self.caos.base_image = caos_number_arg(index)
  end
  return self.caos.base_imag
end

-- Sets the creature permissions for target. Sum the entries in the Creature Permissions table to
-- get the value to use.
function bhvr(flags)
  -- Not implemented
  return caos_targfunction_wrap1("bhvr", flags)
end

function remote_bhvr(flags)
  if flags ~= nil then
    -- TODO: implement
    self.behavior_flags = flags
  end
  return self.behavior_flags
end

-- Returns the the agent currently holding the target, or NULL if there is none.
-- Not implemented
function carr()
  logInfo("carr")
  return nil
end

-- Iterate through each agent which conforms to the given classification, setting TARG to point to
-- each valid agent in turn. family, genus and/or species can be zero to act as wildcards. NEXT
-- terminates the block of code which is executed with each TARG. After an ENUM, TARG is set to OWNR.
function enum(family, genus, species, fcn_callback)
  local entities = world.entityQuery(entity.position(), 9999, {
    callScript = "matches_species",
    boundMode = "position",       -- Simple position comparison should take some load off
    callScriptArgs = { family, genus, species }
  })
  
  local originalTarg = self.TARG
  for i,entity in ipairs(entities) do
    self.TARG = entity
    fcn_callback()
  end
  self.TARG = originalTarg
end

function esee(family, genus, species, fcn_callback)
  local target = nil
  local radius = nil
  if (self.OWNR ~= nil) then
    target = self.OWNR
    radius = self.caos.range_check
  else
    target = self.TARG
    radius = rnge()
  end
  if (target == nil) then return {} end
  
  local entities = world.entityQuery(world.entityPosition(target), toSB.coordinate(radius), {
    withoutEntityId = target,
    boundMode = "position",       -- Simple position comparison should take some load off
    callScript = "target_visible",
    callScriptArgs = { entity.position(), family, genus, species }
  })
  
  local originalTarg = self.TARG
  for i,entity in ipairs(entities) do
    self.TARG = entity
    fcn_callback()
  end
  self.TARG = originalTarg
end

-- Returns family of target. See also GNUS, SPCS.
function fmly()
  return caos_targfunction_wrap0("fmly")
end

function remote_fmly()
  return self.caos.family
end

-- Returns genus of target. See also FMLY, SPCS.
function gnus()
  return caos_targfunction_wrap0("gnus")
end

function remote_gnus()
  return self.caos.genus
end

-- Destroys an agent. The pointer won't be destroyed. For creatures, you probably want to use DEAD first.
function kill(target)
  logInfo("kill %s", target)
  target = caos_number_arg(target)
  if target == entity.id() then
    killSelf()
    coroutine.yield()
  else
    world.callScriptedEntity(target, "remote_kill")
  end
end

function remote_kill()
  killSelf()
end

function mesg_writ(agent, message_id)
  mesg_wrt_plus(agent, message_id, nil, nil, 0)
end

function mesg_wrt_plus(agent, message_id, param_1, param_2, delay)
  logInfo("mesg wrt+ %s %s %s %s %s", agent, message_id, param_1, param_2, delay)
  agent = caos_number_arg(agent)
  message_id = caos_number_arg(message_id)
  param_1 = caos_number_arg(param_1)
  param_2 = caos_number_arg(param_2)
  delay = caos_number_arg(delay)

  world.callScriptedEntity(agent, "addMessage", message_id, param_1, param_2, delay)
end

-- Returns whether the lawn was cut last Sunday or not.
function mows()
  return 1
end

-- Create a new simple agent, using the specified sprite file. The agent will have image_count
-- sprites available, starting at first_image in the file. The plane is the screen depth to show
-- the agent at - the higher the number, the nearer the camera.
function new_simp(family, genus, species, sprite_file, image_count, first_image, plane)
  logInfo("new: simp %s %s %s \"%s\" %s %s %s", family, genus, species, sprite_file, image_count, first_image, plane)
  family = caos_number_arg(family)
  genus = caos_number_arg(genus)
  species = caos_number_arg(species)
  image_count = caos_number_arg(image_count)
  first_image = caos_number_arg(first_image)
  plane = caos_number_arg(plane)

  local size = getImageSize(self.agentName, sprite_file, first_image)
  local position = entity.position()
  position = { position[1], position[2] + size[2] / 8.0 }
  
  self.TARG = world.spawnMonster("test_agent", position, {
    ["family"] = family,
    ["genus"] = genus,
    ["species"] = species,
    ["sprite_file"] = sprite_file,
    ["image_count"] = image_count,
    ["first_image"] = first_image,
    ["plane"] = plane,
    ["agentName"] = self.agentName
  })
end

-- Returns a null agent pointer.
function null()
  return nil
end

-- Returns the agent who's virtual machine the script is running on. Returns NULL for injected or
-- install scripts.
function ownr()
  return self.OWNR
end

-- Specify a frame in the sprite file for the target agent/part. Relative to any index specified by BASE.
-- Return the current POSE of the target agent/part, or -1 if invalid part.
function pose(pose_index)
  return caos_targfunction_wrap1("pose", pose_index)
end

function remote_pose(pose_index)
  if (pose_index ~= nil) then
    self.caos.pose_image = pose_index
    updateImageFrame()
  end
  return self.caos.pose_image
end

-- Returns X position of centre of target.
function posx()
  logInfo("posx")
  if (self.TARG == nil) then return 0 end
  return fromSB.coordinate(world.entityPosition(self.TARG)[1])
end

-- Returns Y position of centre of target.
function posy()
  logInfo("posy")
  if (self.TARG == nil) then return 0 end
  return fromSB.y_coordinate(world.entityPosition(self.TARG)[2])
end

-- Sets the distance that the target can see and hear, and the distance used to test for potential
-- collisions. See also ESEE, OBST.
-- Returns the target's range. See ESEE, OBST.
function rnge(distance)
  return caos_targfunction_wrap1("rnge", distance)
end

function remote_rnge(distance)
  if distance ~= nil then
    self.caos.range_check = distance
  end
  return self.caos.range_check
end

-- Returns species of target. See also FMLY, GNUS.
function spcs()
  return caos_targfunction_wrap0("spcs")
end

function remote_spcs()
  return self.caos.species
end

-- This sets the TARG variable to the agent specified.
-- Returns current target, on whom many commands act.
function targ(agent)
  logInfo("targ %s", agent)
  agent = caos_number_arg(agent)
  if agent ~= nil then
    self.TARG = agent
  end
  return self.TARG
end

-- Start agent timer, calling Timer script every tick_rate ticks. Set to 0 to turn off the timer.
-- Returns the current timer rate set by the command TICK.
function tick(tick_rate)
  return caos_targfunction_wrap1("tick", tick_rate)
end

function remote_tick(tick_rate)
  if (tick_rate ~= nil) then
    self.caos.tick_rate = tick_rate
    self.last_tick_time = world.time()
  end
  return self.caos.tick_rate
end

-- This returns the equivalent of "uname -a" on compatible systems, or a description of your
-- operating system on others. This is a descriptive string and should not be taken as fixed format,
-- or parseable.
function ufos()
  -- Assume this is our super cool OS
  return "FakeOS 3000"
end
