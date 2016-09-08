-------------
-- CAOS FUNCTIONS --
--------------------

-- Set acceleration due to gravity in pixels per tick squared.
-- Returns target's acceleration due to gravity in pixels per tick squared.
CAOS.TargCmd("accg", function(acceleration)
  -- TODO: Figure out what Starbound gravity is _actually_ measured in to come up with a correct formula. This is inaccurate.
  -- For now, we assume starbound gravity is in tiles/s^2 (ship gravity is 80)
  -- Note that ACCG is measured in "pixels per tick squared", where a tick is 1/20 of a second
  --      but we can only set a gravity multiplier, not the gravity itself.
  -- To convert creatures gravity to starbound gravity, we know that: 1 tile = 8 px, 20 tick = 1 s
  -- We also have that newGravity = worldGravity * gravityMultiplier => gravityMultiplier = newGravity / worldGravity
  -- Example: (5 px / tick^2) * (20 tick / s) * (20 tick / s) / (8 px / tile)   =   (250 tiles / s^2)
  if acceleration ~= nil then
    self.gravity = acceleration
    local newGravity = acceleration * 20 * 20 / 8.0 / 2
    mcontroller.controlParameters({
      gravityMultiplier = newGravity / world.gravity(entity.position())
    })
  end
  return self.gravity
end)


-- Set aerodynamic factor as a percentage. The velocity is reduced by this factor each tick.
-- Returns aerodynamic factor as a percentage.
CAOS.TargCmd("aero", function(aerodynamics)
  if aerodynamics ~= nil then
    self.aerodynamics = aerodynamics
    mcontroller.controlParameters({ airFriction = aerodynamics / 100.0 })
  end
  return self.aerodynamics
end)

-- Set the elasticity percentage. An agent with elasticity 100 will bounce perfectly, one with
-- elasticity 0 won't bounce at all.
-- Return the elasticity percentage.
CAOS.TargCmd("elas", function(elasticity)
  if elasticity ~= nil then
    self.elasticity = elasticity
    mcontroller.controlParameters({ bounceFactor = elasticity / 100.0 })
  end
  return self.elasticity
end)

-- Returns 1 if target is moving under the influence of gravity, or 0 if it is at rest.
CAOS.TargCmd("fall", function()
  return fromSB.boolean(mcontroller.falling())
end)

-- Set physics friction percentage, normally from 0 to 100. Speed is lost by this amount when an
-- agent slides along the floor.
CAOS.TargCmd("fric", function(friction)
  if friction ~= nil then
    self.friction = friction
    mcontroller.controlParameters({ groundFriction = friction / 100.0 })
  end
  return self.friction
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

  local newPosition = world.resolvePolyCollision(mcontroller.collisionPoly(), { toSB.coordinate(x), toSB.y_coordinate(y) }, 8)
  if newPosition ~= nil then
    mcontroller.setPosition(topLeftPixelsToCenter(newPosition))
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
CAOS.TargCmd("obst", function(direction))
  local x, y = table.unpack(entity.position())
  local range = toSB.coordinate(self.caos.range_check)
  if direction == CAOS.DIRECTIONS.LEFT then
    x = x - range
  elseif direction == CAOS.DIRECTIONS.UP then
    y = y + range
  elseif direction == CAOS.DIRECTIONS.RIGHT then
    x = x + range
  elseif direction == CAOS.DIRECTIONS.DOWN then
    y = y - range
  end
  
  local hits = world.collisionBlocksAlongLine(entity.position(), {x, y}, nil, 1)
  if #hits > 0 then
    local distance = world.magnitude(entity.position(), hits[1])
    return fromSB.coordinate(distance)
  else
    return 1000000
  end
end)

-- Test if target can move to the given location and still lie validly within the room system.
-- Returns 1 if it can, 0 if it can't.
CAOS.TargCmd("tmvt", function(x, y)
  if isReasonableMove({x, y}) then
    local left, top, right, bottom = table.unpack(mcontroller.boundBox())
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
CAOS.Cmd("velx", function()
  return fromSB.velocity(world.entityVelocity(self.TARG)[1])
end)

-- Vertical velocity in pixels per tick - floating point.
CAOS.Cmd("vely", function()
  return fromSB.y_velocity(world.entityVelocity(self.TARG)[2])
end)
