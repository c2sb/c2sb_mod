----------------------
-- HELPER FUNCTIONS --
----------------------

function getImageSize(spriteFile, frameNumber)
  return root.imageSize("/agents/images/"..spriteFile.."/"..spriteFile.."_"..tostring(frameNumber)..".png")
end

-- Updates the agent's bounds based on its current sprite_file and first_image
function updateBounds()
  local image_size = getImageSize(storage.caos.sprite_file, storage.caos.first_image)

  -- Set the collision polygon
  local half_width = image_size[1] / 2
  local half_height = image_size[2] / 2
  local left = toSB.coordinate(-half_width)
  local top = toSB.coordinate(half_height)
  local right = toSB.coordinate(half_width)
  local bottom = toSB.coordinate(-half_height)

  -- Set the local bounds for script use. This is important because mcontroller.controlParameters
  -- doesn't appear to update immediately.
  self.bounds = { left, top, right, bottom }

  -- Update Starbound collision
  local collision_poly =  { {left, top}, {right, top}, {right, bottom}, {left, bottom} }
  mcontroller.controlParameters({
    collisionPoly = collision_poly
  })
end

-- Retrieves the agent's bounds based on its image. Calculates its bounds if it has not already
-- done so.
function getBounds()
  if not self.bounds then
    updateBounds()
  end
  return self.bounds
end

-- Retrieves an entity's bounding box in world coordinates. Must be another creatures agent.
function getWorldBounds(entityId)
  local position = world.entityPosition(entityId)
  local bounds = world.callScriptedEntity(entityId, "getBounds")

  return { position[1] + bounds[1], position[2] + bounds[2], position[1] + bounds[3], position[2] + bounds[4] }
end

function updateImageFrame()
  assert(type(storage.caos.first_image) == "number", "first_image is not a number")
  assert(type(storage.caos.base_image) == "number", "base_image is not a number")
  assert(type(storage.caos.pose_image) == "number", "pose_image is not a number")
  
  local frameno = storage.caos.first_image + storage.caos.base_image + storage.caos.pose_image
  
  -- Set the frame
  animator.setGlobalTag("frameno", frameno)
  animator.setGlobalTag("color_multiply", string.format("%02X%02X%02X%02X",
    math.min(storage.caos.red_tint, 255),
    math.min(storage.caos.green_tint, 255),
    math.min(storage.caos.blue_tint, 255),
    255 - math.min(storage.caos.alpha_value, 255)))
  animator.setGlobalTag("hue_shift", string.format("%d", (storage.caos.rotation - 128) / 256 * 360 ))
end

function addMessage(from_entity, message_id, param_1, param_2, delay)
  table.insert(self.messages, {
      ["from_entity"] = from_entity,
      ["message_id"] = message_id,
      ["param_1"] = param_1,
      ["param_2"] = param_2,
      ["execute_at"] = world.time() + toSB.ticks(delay)
    })
end

-- Sets the frame rate using Creatures values as the rate.
function setFrameRate(rate)
  storage.frame_rate = rate or 1

  -- Update delta is in frames.
  -- Starbound: 60fps
  -- Creatures: 20fps
  -- Note: We can't modify the update delta unfortunately because we need to listen for collisions
  --script.setUpdateDelta(3 * rate)
  self.sb_frame_rate = 3 * rate
end

-- Given the object's top left position, returns the center
function topLeftPixelsToCenter(position)
  local bounds = getBounds()
  return { position[1] - bounds[1], position[2] - bounds[2] }
end

function matches_species(family, genus, species)
  if family ~= 0 and family ~= storage.caos.family then
    return false
  end
  
  if genus ~= 0 and genus ~= storage.caos.genus then
    return false
  end
  
  return species == 0 or species == storage.caos.species
end

function target_visible(entityId, family, genus, species)
  return matches_species(family, genus, species) and entity.entityInSight(entityId)
end

function init_scriptorium_space(family, genus, species)
  if CAOS.scriptorium == nil then CAOS.scriptorium = {} end
  if CAOS.scriptorium[family] == nil then CAOS.scriptorium[family] = {} end
  if CAOS.scriptorium[family][genus] == nil then CAOS.scriptorium[family][genus] = {} end
  if CAOS.scriptorium[family][genus][species] == nil then CAOS.scriptorium[family][genus][species] = {} end
end

function isReasonableMove(targetCaosPosition)
  local targPosition = entity.position()
  if world.magnitude(targPosition, {toSB.coordinate(targetCaosPosition[1]), toSB.y_coordinate(targetCaosPosition[2])}) > 1024 then
    return false
  end
  return true
end

-- Apply status effects using an invisible projectile that spawns on top of the target
function applyStatusEffects(entityId, effects)
  world.spawnProjectile("caosStatusApplier",
    world.entityPosition(entityId),
    0,
    {0, 0},
    false,
    { statusEffects = effects })
end
