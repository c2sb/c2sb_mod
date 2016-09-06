-------------
-- CAOS FUNCTIONS --
--------------------

-- Set acceleration due to gravity in pixels per tick squared.
-- Returns target's acceleration due to gravity in pixels per tick squared.
function accg(acceleration)
  return caos_targfunction_wrap1("accg", acceleration)
end

-- TODO: Figure out what Starbound gravity is _actually_ measured in to come up with a correct formula. This is inaccurate.
-- For now, we assume starbound gravity is in tiles/s^2 (ship gravity is 80)
-- Note that ACCG is measured in "pixels per tick squared", where a tick is 1/20 of a second
--      but we can only set a gravity multiplier, not the gravity itself.
-- To convert creatures gravity to starbound gravity, we know that: 1 tile = 8 px, 20 tick = 1 s
-- We also have that newGravity = worldGravity * gravityMultiplier => gravityMultiplier = newGravity / worldGravity
-- Example: (5 px / tick^2) * (20 tick / s) * (20 tick / s) / (8 px / tile)   =   (250 tiles / s^2)
function remote_accg(gravity_pixels)
  if gravity_pixels ~= nil then
    self.gravity = gravity_pixels
    local newGravity = gravity_pixels * 20 * 20 / 8.0
    mcontroller.controlParameters({
      gravityMultiplier = newGravity / world.gravity(entity.position())
    })
  end
  return self.gravity
end


-- Set aerodynamic factor as a percentage. The velocity is reduced by this factor each tick.
-- Returns aerodynamic factor as a percentage.
function aero(aerodynamics)
  return caos_targfunction_wrap1("aero", aerodynamics)
end

function remote_aero(aerodynamics)
  if aerodynamics ~= nil then
    self.aerodynamics = aerodynamics
    mcontroller.controlParameters({ airFriction = aerodynamics })
  end
  return self.aerodynamics
end

-- Set the elasticity percentage. An agent with elasticity 100 will bounce perfectly, one with
-- elasticity 0 won't bounce at all.
-- Return the elasticity percentage.
function elas(elasticity)
  return caos_targfunction_wrap1("elas", elasticity)
end

function remote_elas(elasticity_percentage)
  if elasticity_percentage ~= nil then
    self.elasticity = elasticity_percentage
    mcontroller.controlParameters({ bounceFactor = elasticity_percentage / 100.0 })
  end
  return self.elasticity
end

-- Returns 1 if target is moving under the influence of gravity, or 0 if it is at rest.
function fall()
  return caos_targfunction_wrap0("fall")
end

function remote_fall()
  return fromSB.boolean(mcontroller.falling())
end

-- Set physics friction percentage, normally from 0 to 100. Speed is lost by this amount when an
-- agent slides along the floor.
function fric(friction)
  return caos_targfunction_wrap1("fric", friction)
end

-- Return physics friction percentage.
function remote_fric(friction)
  if friction ~= nil then
    self.friction = friction
    mcontroller.controlParameters({ groundFriction = friction })
  end
  return self.friction
end

-- Move the target agent into a safe map location somewhere in the vicinity of x, y. Only works on
-- autonomous agents - see MOVS. Works like a safe MVFT for creatures.
function mvsf(x, y)
  logInfo("mvsf %s %s", x, y)
  x = caos_number_arg(x)
  y = caos_number_arg(y)
  if (self.TARG == nil) then return end
  
  world.callScriptedEntity(self.TARG, "remote_mvsf", x, y)
end

function remote_mvsf(x, y)
  if not isReasonableMove({x, y}) then return end

  local newPosition = world.resolvePolyCollision(mcontroller.collisionPoly(), { toSB.coordinate(x), toSB.y_coordinate(y) }, 16)
  if newPosition ~= nil then
    mcontroller.setPosition(topLeftPixelsToCenter(newPosition))
  end
end

-- Move the top left corner of the target agent to the given world coordinates. Use MVFT instead to
-- move creatures.
function mvto(x, y)
  logInfo("mvto %s %s", x, y)
  x = caos_number_arg(x)
  y = caos_number_arg(y)
  if (self.TARG == nil) then return end

  world.callScriptedEntity(self.TARG, "remote_mvto", x, y)
end

function remote_mvto(x, y)
  if not isReasonableMove({x, y}) then return end
  mcontroller.setPosition(topLeftPixelsToCenter({ toSB.coordinate(x), toSB.y_coordinate(y) }))
end

-- Set velocity, measured in pixels per tick.
function velo(x_velocity, y_velocity)
  logInfo("velo %s %s", x_velocity, y_velocity)
  x_velocity = caos_number_arg(x_velocity)
  y_velocity = caos_number_arg(y_velocity)
  if (self.TARG == nil) then return end
  world.callScriptedEntity(self.TARG, "remote_velo", x_velocity, y_velocity)
end

function remote_velo(x_velocity, y_velocity)
  mcontroller.setVelocity({ toSB.velocity(x_velocity), toSB.y_velocity(y_velocity) })
end

-- Horizontal velocity in pixels per tick - floating point.
function velx()
  logInfo("velx")
  if (self.TARG == nil) then return 0 end
  return fromSB.velocity(world.entityVelocity(self.TARG)[1])
end

-- Vertical velocity in pixels per tick - floating point.
function vely()
  logInfo("vely")
  if (self.TARG == nil) then return 0 end
  return fromSB.y_velocity(world.entityVelocity(self.TARG)[2])
end
