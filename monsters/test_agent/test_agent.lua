require "/scripts/caos_vm/caos.lua"

function init()
  initCaosVars()

  self.scale = tonumber(config.getParameter("imageScale", 1))
  self.agentName = tostring(config.getParameter("agentName", "NO_AGENT"))
  
  require("/agents/"..self.agentName.."/"..self.agentName..".lua")

  self.last_tick_time = world.time()
  self.killed = false
  self.last_colliding_state = false
  self.TARG = nil
  self.OWNR = entity.id()
  self.random = sb.makeRandomSource(world.time())

  animator.setGlobalTag("scale", self.scale)
  animator.setGlobalTag("sprite_file", self.caos.sprite_file)
  animator.setGlobalTag("agentName", self.agentName)
  animator.setAnimationState("body", "idle")

  mcontroller.setAutoClearControls(false)   -- Fixes gravity override and some other things from being cleared every frame
  updateImageFrame()
end

function update(dt)
  if self.killed then return end

  -- Stop currently running script
  if self.stop_script then
    self.stop_script = false
    script_coroutine = nil
  end
  
  -- Check Collision
  local isColliding = mcontroller.isColliding()
  if self.last_colliding_state ~= isColliding then
    self.last_colliding_state = isColliding
    if isColliding then
      create_coroutine(CAOS.EVENT.COLLIDE)
    end
  end
  
  -- Check Timer
  if self.caos.tick_rate > 0 and world.time() > self.last_tick_time + toSB.ticks(self.caos.tick_rate) then
    self.last_tick_time = world.time()
    create_coroutine(CAOS.EVENT.TIMER)
  end
  
  -- Resume script
  if script_coroutine ~= nil and coroutine.status(script_coroutine) == "suspended" then
    local result, message = coroutine.resume(script_coroutine)
    if not result then
      logInfo("Coroutine finished: %s", message)
    end
  end
end

function interact(args)
  -- TODO interact script
end

function damage(args)
  -- TODO hit script
end

function shouldDie()
  return self.killed
end

function die()
end

function uninit()
end

----------------------------------------- END callbacks

function initCaosVars()
  self.caos = {}
  self.caos.family = tonumber(config.getParameter("family", CAOS.FAMILY.INVALID))
  self.caos.genus = tonumber(config.getParameter("genus", -1))
  self.caos.species = tonumber(config.getParameter("species", -1))
  self.caos.sprite_file = tostring(config.getParameter("sprite_file", "NO_SPRITE"))
  self.caos.image_count = tonumber(config.getParameter("image_count", 0))
  self.caos.first_image = tonumber(config.getParameter("first_image", 0))
  self.caos.plane = tonumber(config.getParameter("plane", 0))

  init_scriptorium_space(self.caos.family, self.caos.genus, self.caos.species)

  self.caos.base_image = 0
  self.caos.pose_image = 0
  self.caos.tick_rate = 0
  self.caos.range_check = 100
end

function killSelf()
  self.killed = true
  -- Attempt to hide it for the delay between this call and the shouldDie() callback
  animator.setAnimationState("body", "invisible")
end

function create_coroutine(event)
  -- Prevent events from interrupting themselves
  if script_coroutine ~= nil and coroutine.status(script_coroutine) ~= "dead" and self.current_event == event then
    return
  end
  
  if scriptorium[self.caos.family][self.caos.genus][self.caos.species][event] ~= nil then
    logInfo("Running event script %s", event)
    self.TARG = self.OWNR
    self.current_event = event
    script_coroutine = coroutine.create(scriptorium[self.caos.family][self.caos.genus][self.caos.species][event])
  end
end
