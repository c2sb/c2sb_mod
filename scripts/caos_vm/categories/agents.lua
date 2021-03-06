function updateFlags()
  if (storage.caos.attributes & CAOS.ATTRIBUTES.CARRYABLE) ~= 0 then
    -- TODO
  end
  if (storage.caos.attributes & CAOS.ATTRIBUTES.MOUSEABLE) ~= 0 then
    -- TODO - Enable/Disable relocateable status
  end
  
  -- CAOS.ATTRIBUTES.ACTIVATEABLE
  monster.setInteractive(
    (storage.caos.attributes & CAOS.ATTRIBUTES.ACTIVATEABLE) ~= 0 or
    (storage.caos.behaviors & CAOS.PERMISSIONS.ACTIVATE_1) ~= 0 or
    (storage.caos.behaviors & CAOS.PERMISSIONS.ACTIVATE_2) ~= 0)
  
  if (storage.caos.attributes & CAOS.ATTRIBUTES.GREEDY_CABIN) ~= 0 then
    -- TODO
  end
  if (storage.caos.attributes & CAOS.ATTRIBUTES.INVISIBLE) ~= 0 then
    -- TODO
  end
  if (storage.caos.attributes & CAOS.ATTRIBUTES.FLOATABLE) ~= 0 then
    -- TODO
  end
  
  -- CAOS.ATTRIBUTES.SUFFER_COLLISIONS
  mcontroller.controlParameters({
    collisionEnabled = (storage.caos.attributes & CAOS.ATTRIBUTES.SUFFER_COLLISIONS) ~= 0
  })
  
  -- CAOS.ATTRIBUTES.SUFFER_PHYSICS
  mcontroller.controlParameters({
    gravityEnabled = (storage.caos.attributes & CAOS.ATTRIBUTES.SUFFER_PHYSICS) ~= 0
  })
  
  if (storage.caos.attributes & CAOS.ATTRIBUTES.CAMERA_SHY) ~= 0 then
    -- TODO
  end
  if (storage.caos.attributes & CAOS.ATTRIBUTES.OPEN_AIR_CABIN) ~= 0 then
    -- TODO
  end
  if (storage.caos.attributes & CAOS.ATTRIBUTES.ROTATABLE) ~= 0 then
    -- TODO
  end
  if (storage.caos.attributes & CAOS.ATTRIBUTES.PRESENCE) ~= 0 then
    -- TODO
  end

  --status.setStatusProperty("invulnerable",
  --  (storage.caos.behaviors & CAOS.PERMISSIONS.HIT) ~= 0 and 1.0 or 0.0)
end

-- A wrapper for world.entityQuery which performs differently based on the given family.
-- i.e. Players and NPCs are considered "creatures" but don't have any specific callbacks.
-- We can (in the future) include other entities that are not a creatures agent.
-- TODO wildcard family
function familyEntityQuery(family, targetEntity, position, positionOrRadius, options)
  local entities = {}
  if family == CAOS.FAMILY.CREATURE then
    entities = world.entityQuery(position, positionOrRadius, {
      withoutEntityId = targetEntity,
      includedTypes = { "npc", "player" },
      boundMode = options.boundMode or "position"
    })
  elseif family == CAOS.FAMILY.OBJECT or family == CAOS.FAMILY.EXTENDED then
    entities = world.entityQuery(position, positionOrRadius, {
      withoutEntityId = targetEntity,
      includedTypes = { "monster" },
      boundMode = options.boundMode or "position",
      callScript = options.callScript,
      callScriptArgs = options.callScriptArgs,
      callScriptResult = options.callScriptResult or true
    })
  else
    sb.logWarn("Family not supported: %s", family)
  end
  return entities
end

--------------------
-- CAOS FUNCTIONS --
--------------------

-- The agent will be drawn alpha blended against the background by the given value - from 256 for
-- invisible to 0 for completely solid. For compound agents set the PART to affect a particular
-- part or to -1 to affect all parts. The second parameter switches alpha blending on (1) or off
-- (0). Alpha graphics are drawn much slower, so use sparingly and turn it off completely rather
-- than using an intensity value of 0 or 256. At the moment alpha channels only work on compressed,
-- non-mirrored, non-zoomed sprites.
CAOS.TargCmd("alph", function(alpha_value, yesorno)
  storage.caos.alpha_value = alpha_value
  storage.caos.alpha_blending = yesorno
  updateImageFrame()
end)

function animStringToArray(anim_string)
  local poses = {}
  for s in string.gmatch(anim_string, "%S+") do
    table.insert(poses, tonumber(s))
  end
  return poses
end

-- Specify a list of POSEs such as [1 2 3] to animate the current agent/part. Put 255 at the end to
-- continually loop. The first number after the 255 is an index into the animation string where the
-- looping restarts from - this defaults to 0 if not specified. e.g. [0 1 2 10 11 12 255 3] would
-- loop just the 10, 11, 12 section.
-- NOTE: anim doesn't support strings, but it's easier to convert a CAOS list to string by adding
-- and extra set of square brackets!
CAOS.TargCmd("anim", function(pose_list)
  if type(pose_list) == "string" then
    pose_list = animStringToArray(pose_list)
  end

  storage.animation = pose_list
  storage.animation_index = 0
end)

CAOS.Cmd("anms", function(anim_string)
  anim(anim_string)
end)

-- Set attributes of target. Sum the values in the Attribute Flags table to get the attribute value
-- to pass into this command.
CAOS.TargCmd("attr", function(attributes)
  if attributes ~= nil then
    storage.caos.attributes = attributes
    updateFlags()
  end
  return storage.caos.attributes
end)

-- Set the base image for this agent or part. The index is relative to the first_image specified in
-- the NEW: command. Future POSE/ANIM commands and any ANIM in progress are relative to this new base.
-- Returns the BASE image for the current agent/part. Returns -1 if an invalid part.
CAOS.Cmd("base", function(index)
  if index ~= nil then
    storage.caos.base_image = index
  end
  return storage.caos.base_imag
end)

-- Sets the creature permissions for target. Sum the entries in the Creature Permissions table to
-- get the value to use.
CAOS.TargCmd("bhvr", function(flags)
  if flags ~= nil then
    storage.caos.behaviors = flags
    updateFlags()
  end
  return storage.caos.behaviors
end)

CAOS.Cmd("call", function(event_no, param_1, param_2)
  local call_fn = CAOS.scriptorium[storage.caos.family][storage.caos.genus][storage.caos.species][event_no]
  if call_fn ~= nil then
    -- Save state
    local oldP1 = _p1_
    local oldP2 = _p2_
    local oldVariables = self.local_variables
    local oldInstantState = self.instant

    -- Reset state
    _p1_ = param_1
    _p2_ = param_2
    self.local_variables = {}
    
    -- Make the call
    call_fn()

    -- Restore state
    _p1_ = oldP1
    _p2_ = oldP2
    self.local_variables = oldVariables
    self.instant = oldInstantState
  end
end)

-- Returns the the agent currently holding the target, or NULL if there is none.
-- Not implemented
CAOS.TargCmd("carr", function()
  return nil
end)

-- Iterate through each agent which conforms to the given classification, setting TARG to point to
-- each valid agent in turn. family, genus and/or species can be zero to act as wildcards. NEXT
-- terminates the block of code which is executed with each TARG. After an ENUM, TARG is set to OWNR.
CAOS.Cmd("enum", function(family, genus, species, fcn_callback)
  local entities = familyEntityQuery(family, nil, entity.position(), 9999, {
    callScript = "matches_species",
    callScriptArgs = { family, genus, species }
  })
  
  for _, entityId in pairs(entities) do
    self.TARG = entityId
    fcn_callback()
  end
  self.TARG = self.OWNR
end, 1 << 3)

-- As ENUM, except only enumerates through agents which OWNR can see. An agent can see another if
-- it is within RNGE, its PERM allows it to see through all intervening walls, and for creatures
-- ATTR Invisible isn't set. See also STAR and SEEE. In install scripts, when there is no OWNR,
-- TARG is used instead.
CAOS.Cmd("esee", function(family, genus, species, fcn_callback)
  -- When OWNR is null we use TARG instead
  local oldOwnr = self.OWNR
  if self.OWNR == nil then
    self.OWNR = self.TARG
  end

  local entities = familyEntityQuery(family, self.OWNR,
    world.entityPosition(self.OWNR),
    toSB.coordinate(storage.caos.range_check),
    {
      callScript = "target_visible",
      callScriptArgs = { self.OWNR, family, genus, species }
    })

  for _, entityId in pairs(entities) do
    if entity.entityInSight(entityId) then
      self.TARG = entityId
      fcn_callback()
    end
  end
  self.OWNR = oldOwnr
  self.TARG = self.OWNR
end, 1 << 3)

-- As ENUM, except only enumerates through agents which OWNR is touching. Agents are said to be
-- touching if their bounding rectangles overlap. See also TTAR. In install scripts, when there is
-- no OWNR, TARG is used instead.
CAOS.Cmd("etch", function(family, genus, species, fcn_callback)
  -- When OWNR is null we use TARG instead
  local oldOwnr = self.OWNR
  if self.OWNR == nil then
    self.OWNR = self.TARG
  end

  local bounds = getWorldBounds(self.OWNR)

  local entities = familyEntityQuery(family, self.OWNR,
    { bounds[1], bounds[4] }, -- left, bottom
    { bounds[3], bounds[2] }, -- right, top
    {
      boundMode = "collisionarea",
      callScript = "matches_species",
      callScriptArgs = { family, genus, species }
    })

  if #entities > 0 then
    sb.logInfo("%s etch = %s", storage.agentName, #entities)
  end
  
  for _, entityId in pairs(entities) do
    self.TARG = entityId
    fcn_callback()
  end
  self.OWNR = oldOwnr
  self.TARG = self.OWNR
end, 1 << 3)

-- Returns family of target. See also GNUS, SPCS.
CAOS.TargCmd("fmly", function()
  return storage.caos.family
end)

-- This command sets the frame rate on the TARG agent. If it is a compound agent, then the part
-- affected can be set with the PART command. Valid rates are from 1 to 255. 1 is Normal rate, 2
-- is half speed etc...
CAOS.TargCmd("frat", function(framerate)
  setFrameRate(framerate)
end)

-- If we're processing a message, this is the OWNR who sent the message. NULL if the message was
-- sent from an injected script or an install script. If the message was sent over the network
-- using NET: WRIT, then this contains the user id of the sender, as a string.
from = nil

-- Returns genus of target. See also FMLY, SPCS.
CAOS.TargCmd("gnus", function()
  return storage.caos.genus
end)

CAOS.TargCmd("hght", function()
  local bounds = getBounds()
  return fromSB.coordinate(bounds[2] - bounds[4])
end)

-- Destroys an agent. The pointer won't be destroyed. For creatures, you probably want to use DEAD first.
CAOS.Cmd("kill", function(target)
  if target == entity.id() then
    killSelf()
    coroutine.yield()
  else
    world.callScriptedEntity(target, "killSelf")
  end
end)

-- Send a message to another agent. The message_id is from the table of Message Numbers; remember
-- that early Message Numbers differ slightly from Script Numbers. If used from an install script,
-- then FROM for the message to NULL rather than OWNR.
CAOS.Cmd("mesg_writ", function(agent, message_id)
  mesg_wrt_plus(agent, message_id, nil, nil, 0)
end)

-- Send a message with parameters to another agent. Waits delay ticks before sending the message.
-- The message_id is from the table of Message Numbers.
CAOS.Cmd("mesg_wrt_plus", function(agent, message_id, param_1, param_2, delay)
  -- SPECIAL CASE: Speech bubble
  -- TODO: Support speech bubble factory (or should we even bother?)
  -- TODO: Support delay
  if agent == -1 and message_id == 126 then
    world.callScriptedEntity(param_2, "monster.say", param_1)
  else
    world.callScriptedEntity(agent, "addMessage", self.OWNR, message_id, param_1, param_2, delay)
  end
end)

-- Returns whether the lawn was cut last Sunday or not.
CAOS.Cmd("mows", function()
  return 1
end)

-- Create a new simple agent, using the specified sprite file. The agent will have image_count
-- sprites available, starting at first_image in the file. The plane is the screen depth to show
-- the agent at - the higher the number, the nearer the camera.
CAOS.Cmd("new_simp", function(family, genus, species, sprite_file, image_count, first_image, plane)
  local size = getImageSize(sprite_file, first_image)
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
    ["agentName"] = storage.agentName
  })
end)
function new.simp(_, family, genus, species, sprite_file, image_count, first_image, plane)
  new_simp(family, genus, species, sprite_file, image_count, first_image, plane)
end

-- Returns a null agent pointer.
null = nil

-- Wait until the current agent/part's ANIMation is over before continuing. Looping anims stop this
-- command terminating until the animation is changed to a non-looping one.
CAOS.Cmd("over", function()
  while storage.animation ~= nil do
    coroutine.yield()
  end
end)

-- Returns the agent who's virtual machine the script is running on. Returns NULL for injected or
-- install scripts.
CAOS.Cmd("ownr", function()
  return self.OWNR
end)

-- Sets the target agent's principal drawing plane. The higher the value, the nearer the camera.
-- For compound agents, the principal plane is the one for the automatically made first part. The
-- plane of other parts is relative to this one.
-- Returns the screen depth plane of the principal part.
CAOS.TargCmd("plne", function(plane)
  -- TODO partially implemented
  if plane ~= nil then
    storage.caos.plane = plane
  end
  return storage.caos.plane
end)

-- Returns bottom position of target's bounding box.
CAOS.TargCmd("posb", function()
  local bounds = getBounds()
  return fromSB.y_coordinate(entity.position()[2] + bounds[4])
end)

-- Specify a frame in the sprite file for the target agent/part. Relative to any index specified by BASE.
-- Return the current POSE of the target agent/part, or -1 if invalid part.
CAOS.TargCmd("pose", function(pose_index)
  if (pose_index ~= nil) then
    storage.caos.pose_image = pose_index
    storage.animation = nil
    storage.animation_index = 0
    updateImageFrame()
  end
  return storage.caos.pose_image
end)

-- Returns left position of target's bounding box.
CAOS.TargCmd("posl", function()
  local bounds = getBounds()
  return fromSB.coordinate(entity.position()[1] + bounds[1])
end)

-- Returns right position of target's bounding box.
CAOS.TargCmd("posr", function()
  local bounds = getBounds()
  return fromSB.coordinate(entity.position()[1] + bounds[3])
end)

-- Returns top position of target's bounding box.
CAOS.TargCmd("post", function()
  local bounds = getBounds()
  return fromSB.y_coordinate(entity.position()[2] + bounds[2])
end)

-- Returns X position of centre of target.
CAOS.TargCmd("posx", function()
  return fromSB.coordinate(entity.position()[1])
end)

-- Returns Y position of centre of target.
CAOS.TargCmd("posy", function()
  return fromSB.y_coordinate(entity.position()[2])
end)

-- Set the relative x and y coordinate of the handle that target is picked up by, for the given
-- pose. This pose is measured from the absolute base specified in the NEW: command, rather than
-- the relative base specified by the BASE command. Pose -1 sets the same point for all poses.
-- Returns the x or y coordinate of the handle that target is picked up by for the given pose.
-- x_or_y is 1 for x, 2 for y. The pose is measured from the absolute base specified in the NEW:
-- command, rather than the relative base specified by the BASE command.
CAOS.TargCmd("puhl")

-- Sets the distance that the target can see and hear, and the distance used to test for potential
-- collisions. See also ESEE, OBST.
-- Returns the target's range. See ESEE, OBST.
CAOS.TargCmd("rnge", function(distance)
  if distance ~= nil then
    storage.caos.range_check = distance
  end
  return storage.caos.range_check
end)

-- Randomly chooses an agent which matches the given classifier, and targets it.
CAOS.Cmd("rtar", function(family, genus, species)
  -- Special case for speech bubble factory
  if family == 1 and genus == 2 and species == 10 then
    self.TARG = -1
    return
  end

  local entities = familyEntityQuery(family, nil, entity.position(), 9999, {
    callScript = "matches_species",
    callScriptArgs = { family, genus, species }
  })

  if #entities > 0 then
    self.TARG = entities[self.random:randu32() % #entities + 1]
  else
    self.TARG = nil
  end
end)

-- Returns species of target. See also FMLY, GNUS.
CAOS.TargCmd("spcs", function()
  return storage.caos.species
end)

-- This sets the TARG variable to the agent specified.
-- Returns current target, on whom many commands act.
CAOS.Cmd("targ", function(agent)
  if agent ~= nil then
    self.TARG = agent
  end
  -- We reserve TARG < 0 for special cases
  if self.TARG ~= nil and self.TARG >= 0 and not world.entityExists(self.TARG) then
    self.TARG = nil
  end
  return self.TARG
end)

-- Start agent timer, calling Timer script every tick_rate ticks. Set to 0 to turn off the timer.
-- Returns the current timer rate set by the command TICK.
CAOS.TargCmd("tick", function(tick_rate)
  if (tick_rate ~= nil) then
    storage.caos.tick_rate = tick_rate
    self.last_tick_time = world.time()
  end
  return storage.caos.tick_rate
end)

-- Like TINT but only tints the current frame. The other frames are no longer available in the
-- gallery, it becomes a one frame sprite file. Original display engine only.
CAOS.Cmd("tino", function(red_tint, green_tint, blue_tint, rotation, swap)
  tint(red_tint, green_tint, blue_tint, rotation, swap)
end)

-- This tints the TARG agent with the r,g,b tint and applies the colour rotation and swap as per
-- pigment bleed genes. Specify the PART first for compound agents. The tinted agent or part now
-- uses a cloned gallery, which means it takes up more memory, and the save world files are larger.
-- However it also no longer needs the sprite file. Also, tinting resets camera shy and other
-- properties of the gallery. See TINO for a quicker version that tints only one frame.
-- Returns a tint value for an agent - currently it works only on Skeletal Creatures.
-- Attribute can be:
-- 1 - Red
-- 2 - Green
-- 3 - Blue
-- 4 - Rotation
-- 5 - Swap
CAOS.TargCmd("tint", function(red_tint, green_tint, blue_tint, rotation, swap)
  if green_tint == nil and blue_tint == nil and rotation == nil and swap == nil then
    local attribute = red_tint
    if attribute == 1 then
      return storage.caos.red_tint
    elseif attribute == 2 then
      return storage.caos.green_tint
    elseif attribute == 3 then
      return storage.caos.blue_tint
    elseif attribute == 4 then
      return storage.caos.rotation
    elseif attribute == 5 then
      return storage.caos.swap
    end
    return 0
  end
  storage.caos.red_tint = red_tint
  storage.caos.green_tint = green_tint
  storage.caos.blue_tint = blue_tint
  storage.caos.rotation = rotation
  storage.caos.swap = swap
  updateImageFrame()
end)

-- Counts the number of agents in the world matching the classifier.
CAOS.Cmd("totl", function(family, genus, species)
  local entities = familyEntityQuery(family, nil, entity.position(), 9999, {
    callScript = "matches_species",
    callScriptArgs = { family, genus, species }
  })

  return #entities
end)

-- Returns 1 if the two specified agents are touching, or 0 if they are not. Agents are said to
-- be touching if their bounding rectangles overlap.
CAOS.Cmd("touc", function(first, second)
  if first == nil or not world.entityExists(first) or second == nil or not world.entityExists(second) then
    return 0
  end
  local boundsA = getWorldBounds(first)
  local boundsB = getWorldBounds(second)

  return fromSB.boolean(
    (boundsA[1] <= boundsB[3] and boundsA[3] >= boundsB[1]) and
    (boundsA[2] >= boundsB[4] and boundsA[4] <= boundsB[2])
    )
end)

CAOS.Cmd("ttar", function(family, genus, species)
  local bounds = getWorldBounds(self.OWNR)

  local entities = familyEntityQuery(family, self.OWNR,
    { bounds[1], bounds[4] }, -- left, bottom
    { bounds[3], bounds[2] }, -- right, top
    {
      boundMode = "collisionarea",
      callScript = "matches_species",
      callScriptArgs = { family, genus, species }
    })
  sb.logInfo("%s ttar = %s", storage.agentName, #entities)

  if #entities > 0 then
    self.TARG = entities[self.random:randu32() % #entities + 1]
  else
    self.TARG = nil
  end
end)

-- This returns the equivalent of "uname -a" on compatible systems, or a description of your
-- operating system on others. This is a descriptive string and should not be taken as fixed format,
-- or parseable.
CAOS.Cmd("ufos", function()
  -- Assume this is our super cool OS
  return "FakeOS 3000"
end)

CAOS.TargCmd("wdth", function()
  local bounds = getBounds()
  return fromSB.coordinate(bounds[3] - bounds[1])
end)

