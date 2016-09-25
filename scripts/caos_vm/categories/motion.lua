
-- acceleration due to gravity
function updateGravity()
  -- TODO: Figure out what Starbound gravity is _actually_ measured in to come up with a correct formula. This is inaccurate.
  -- For now, we assume starbound gravity is in tiles/s^2 (ship gravity is 80)
  -- Note that ACCG is measured in "pixels per tick squared", where a tick is 1/20 of a second
  --      but we can only set a gravity multiplier, not the gravity itself.
  -- To convert creatures gravity to starbound gravity, we know that: 1 tile = 8 px, 20 tick = 1 s
  -- We also have that newGravity = worldGravity * gravityMultiplier => gravityMultiplier = newGravity / worldGravity
  -- Example: (5 px / tick^2) * (20 tick / s) * (20 tick / s) / (8 px / tile)   =   (250 tiles / s^2)
  -- 3 is called the "bullshit constant", as I've been told Starbound gravity is measured in bullshits
  local newGravity = storage.caos.gravity * 20 * 20 / 8.0 / 3
  mcontroller.controlParameters({
    --gravityMultiplier = newGravity / world.gravity(entity.position())
    airBuoyancy = 1 - newGravity / world.gravity(entity.position())
  })
end

function updateAerodynamics()
  mcontroller.controlParameters({ airFriction = storage.caos.aerodynamics / 10.0 })
end

function updateElasticity()
  mcontroller.controlParameters({ bounceFactor = storage.caos.elasticity / 100.0 })
end

function updateFriction()
  mcontroller.controlParameters({
    normalGroundFriction = storage.caos.friction / 10.0,
    groundFriction = storage.caos.friction / 10.0
  })
end

-------------
-- CAOS FUNCTIONS --
--------------------

-- Set acceleration due to gravity in pixels per tick squared.
-- Returns target's acceleration due to gravity in pixels per tick squared.
CAOS.TargCmd("accg", function(acceleration)

  if acceleration ~= nil then
    storage.caos.gravity = acceleration
    updateGravity()
  end
  return storage.caos.gravity
end)


-- Set aerodynamic factor as a percentage. The velocity is reduced by this factor each tick.
-- Returns aerodynamic factor as a percentage.
CAOS.TargCmd("aero", function(aerodynamics)
  if aerodynamics ~= nil then
    storage.caos.aerodynamics = aerodynamics
    updateAerodynamics()
  end
  return storage.caos.aerodynamics
end)

-- Set the elasticity percentage. An agent with elasticity 100 will bounce perfectly, one with
-- elasticity 0 won't bounce at all.
-- Return the elasticity percentage.
CAOS.TargCmd("elas", function(elasticity)
  if elasticity ~= nil then
    storage.caos.elasticity = elasticity
    updateElasticity()
  end
  return storage.caos.elasticity
end)

-- Returns 1 if target is moving under the influence of gravity, or 0 if it is at rest.
CAOS.TargCmd("fall", function()
  return fromSB.boolean(mcontroller.falling())
end)

-- Set physics friction percentage, normally from 0 to 100. Speed is lost by this amount when an
-- agent slides along the floor.
CAOS.TargCmd("fric", function(friction)
  if friction ~= nil then
    storage.caos.friction = friction
    updateFriction()
  end
  return storage.caos.friction
end)

-- Returns the movement status of the target. 
-- 0 Autonomous
-- 1 Mouse driven
-- 2 Floating
-- 3 In vehicle
-- 4 Carried
CAOS.TargCmd("movs", function()
  -- Not implemented
  return 0
end)

-- Move the target agent by relative distances, which can be negative or positive.
CAOS.Cmd("mvby", function(delta_x, delta_y)
  mvto(getx() + delta_x, gety() + deltay)
end)

-- Move the target agent into a safe map location somewhere in the vicinity of x, y. Only works on
-- autonomous agents - see MOVS. Works like a safe MVFT for creatures.
CAOS.TargCmd("mvsf", function(x, y)
  if not isReasonableMove({x, y}) then return end

  local targetPosition = topLeftPixelsToCenter({ toSB.coordinate(x), toSB.y_coordinate(y) })
  local newPosition = world.resolvePolyCollision(mcontroller.collisionPoly(), targetPosition, 8)
  if newPosition ~= nil then
    mcontroller.setPosition(newPosition)
  end
end)

-- Move the top left corner of the target agent to the given world coordinates. Use MVFT instead to
-- move creatures.
CAOS.TargCmd("mvto", function(x, y)
  if not isReasonableMove({x, y}) then return end
  mcontroller.setPosition(topLeftPixelsToCenter({ toSB.coordinate(x), toSB.y_coordinate(y) }))
end)

-- Returns the distance from the agent to the nearest wall that it might collide with in the given
-- direction. Directions are LEFT, RGHT, _UP_, or DOWN. If the distance to the collsion is greater
-- than RNGE then a very large number is returned.
CAOS.TargCmd("obst", function(direction)
  local range = toSB.coordinate(storage.caos.range_check)

  -- Get the x/y end-point, include entity's bounding box
  local entity_x, entity_y = table.unpack(entity.position())
  local targ_x, targ_y = entity_x, entity_y
  local left, top, right, bottom = table.unpack(getBounds())
  if direction == CAOS.DIRECTIONS.LEFT then
    entity_x = entity_x + left
    targ_x = entity_x - range
  elseif direction == CAOS.DIRECTIONS.UP then
    entity_y = entity_y + top
    targ_y = entity_y + range
  elseif direction == CAOS.DIRECTIONS.RIGHT then
    entity_x = entity_x + right
    targ_x = entity_x + range
  elseif direction == CAOS.DIRECTIONS.DOWN then
    entity_y = entity_y + bottom
    targ_y = entity_y - range
  end
  
  local hits = world.collisionBlocksAlongLine({entity_x, entity_y}, {targ_x, targ_y}, {"Block"}, 1)
  if #hits > 0 then
    local dist_x, dist_y = table.unpack(world.distance({entity_x, entity_y}, hits[1]))
    dist_x = math.abs(dist_x)
    dist_y = math.abs(dist_y)

    if direction == CAOS.DIRECTIONS.LEFT then
      return fromSB.coordinate(dist_x - 1)
    elseif direction == CAOS.DIRECTIONS.UP then
      return fromSB.coordinate(dist_y)
    elseif direction == CAOS.DIRECTIONS.RIGHT then
      return fromSB.coordinate(dist_x)
    elseif direction == CAOS.DIRECTIONS.DOWN then
      return fromSB.coordinate(dist_y - 1)
    end

    return 1000000
  else
    return 1000000
  end
end)

-- Returns the relative X distance of the centre point of the second agent from the centre point
-- of the first.
CAOS.Cmd("relx", function(first, second)
  if first == nil or not world.entityExists(first) or second == nil or not world.entityExists(second) then
    return 0
  end
  return fromSB.coordinate(world.distance(world.entityPosition(first), world.entityPosition(second))[1])
end)

-- Returns the relative Y distance of the centre point of the second agent from the centre point
-- of the first.
CAOS.Cmd("rely", function(first, second)
  if first == nil or not world.entityExists(first) or second == nil or not world.entityExists(second) then
    return 0
  end
  return fromSB.y_coordinate(world.distance(world.entityPosition(first), world.entityPosition(second))[2])
end)

-- Test if target can move to the given location and still lie validly within the room system.
-- Returns 1 if it can, 0 if it can't.
CAOS.TargCmd("tmvt", function(x, y)
  if isReasonableMove({x, y}) then
    local left, top, right, bottom = table.unpack(getBounds())
    x, y = table.unpack(topLeftPixelsToCenter({ toSB.coordinate(x), toSB.y_coordinate(y) }))
    return fromSB.boolean(not world.rectCollision({left + x, top + y, right + x, bottom + y}))
  else
    return 0
  end
end)

-- Set velocity, measured in pixels per tick.
CAOS.TargCmd("velo", function(x_velocity, y_velocity)
  mcontroller.setVelocity({ toSB.velocity(x_velocity), toSB.y_velocity(y_velocity) })
end)

-- Horizontal velocity in pixels per tick - floating point.
CAOS.register(CAOS.MakeVar("velx",
  function(t)
    if self.TARG == nil or not world.entityExists(self.TARG) then return 0 end
    return fromSB.velocity(world.entityVelocity(self.TARG)[1])
  end,
  function(t, value)
    if self.TARG == nil or not world.entityExists(self.TARG) then return end
    local oldVelo = world.entityVelocity(self.TARG)
    world.callScriptedEntity(self.TARG, "mcontroller.setVelocity", { toSB.velocity(value), oldVelo[2] })
  end)
)

-- Vertical velocity in pixels per tick - floating point.
CAOS.register(CAOS.MakeVar("vely",
  function(t)
    if self.TARG == nil or not world.entityExists(self.TARG) then return 0 end
    return fromSB.y_velocity(world.entityVelocity(self.TARG)[2])
  end,
  function(t, value)
    if self.TARG == nil or not world.entityExists(self.TARG) then return end
    local oldVelo = world.entityVelocity(self.TARG)
    world.callScriptedEntity(self.TARG, "mcontroller.setVelocity", { oldVelo[1], toSB.y_velocity(value) })
  end)
)

-- Returns the direction of the last wall the agent collided with. Directions are LEFT, RGHT,
-- _UP_, or DOWN.
CAOS.Cmd("wall", function()
  -- TODO This is a stub
  return CAOS.DIRECTIONS.DOWN
end)
