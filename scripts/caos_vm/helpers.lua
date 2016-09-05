----------------------
-- HELPER FUNCTIONS --
----------------------

function logInfo(fmt, ...)
  sb.logInfo("[%s:%s,%s,%s] "..fmt, entity.id(), self.caos.family, self.caos.genus, self.caos.species, ...)
end

function updateImageFrame()
  assert(type(self.caos.first_image) == "number", "first_image is not a number")
  assert(type(self.caos.base_image) == "number", "base_image is not a number")
  assert(type(self.caos.pose_image) == "number", "pose_image is not a number")
  
  local frameno = self.caos.first_image + self.caos.base_image + self.caos.pose_image
  if self.lastframeno == frameno then return end  -- because frame updates might be expensive
  self.lastframeno = frameno
  
  -- Set the frame
  animator.setGlobalTag("frameno", frameno)
  
  -- Retrieve properties for the current image
  local image_size = root.imageSize("/monsters/test_agent/atlas.png:"..tostring(frameno))
  local image_bounds = root.nonEmptyRegion("/monsters/test_agent/atlas.png:"..tostring(frameno))
  
  -- Set the collision polygon
  local center_x = image_size[1] / 2
  local center_y = image_size[2] / 2
  local left = toSB.coordinate(image_bounds[1] - center_x)
  local top = toSB.coordinate(image_bounds[2] - center_y)
  local right = toSB.coordinate(image_bounds[3] - center_x)
  local bottom = toSB.coordinate(image_bounds[4] - center_y)
  
  local collision_poly =  { {left, top}, {right, top}, {right, bottom}, {left, bottom} }
  mcontroller.controlParameters({
    collisionPoly = collision_poly
  })
  
  -- Resolve collision issues, if any (i.e. getting stuck under the floor is a common one)
  local newPosition = world.resolvePolyCollision(collision_poly, mcontroller.position(), 16)
  if newPosition ~= nil then
    mcontroller.setPosition(newPosition)
  end
end

function matches_species(family, genus, species)
  if family ~= 0 and family ~= self.caos.family then
    return false
  end
  
  if genus ~= 0 and genus ~= self.caos.genus then
    return false
  end
  
  return species == 0 or species == self.caos.species
end

function init_scriptorium_space(family, genus, species)
  if scriptorium == nil then scriptorium = {} end
  if scriptorium[family] == nil then scriptorium[family] = {} end
  if scriptorium[family][genus] == nil then scriptorium[family][genus] = {} end
  if scriptorium[family][genus][species] == nil then scriptorium[family][genus][species] = {} end
end

function caos_number_arg(argument)
  if type(argument) == "string" then
    return getv(argument)
  end
  return argument
end

function caos_targfunction_wrap0(name)
  logInfo("%s", name)
  if (self.TARG == nil) then
    logInfo("ERROR: TARG is null")
    return 0
  end
  return world.callScriptedEntity(self.TARG, "remote_"..name)
end

function caos_targfunction_wrap1(name, arg1)
  logInfo("%s %s", name, arg1)
  if (self.TARG == nil) then
    logInfo("ERROR: TARG is null")
    return 0
  end
  arg1 = caos_number_arg(arg1)
  return world.callScriptedEntity(self.TARG, "remote_"..name, arg1)
end

function isReasonableMove(entityId, targetCaosPosition)
  local targPosition = world.entityPosition(entityId)
  if world.magnitude(targPosition, {toSB.coordinate(targetCaosPosition[1]), toSB.y_coordinate(targetCaosPosition[2])}) > 1024 then
    return false
  end
  return true
end
