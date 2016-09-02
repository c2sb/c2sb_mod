--require "/scripts/caos_vm/caos.lua"
--require "/monsters/test_agent/balloonplant.lua"
--require("/scripts/util.lua")
require "/scripts/caos_vm/constants.lua"

function init()
  self.family = tonumber(config.getParameter("family", CAOS.FAMILY.INVALID))
  self.genus = tonumber(config.getParameter("genus", -1))
  self.species = tonumber(config.getParameter("species", -1))
  self.sprite_file = config.getParameter("sprite_file", "NOT_FOUND")
  self.image_count = tonumber(config.getParameter("image_count", 0))
  self.first_image = tonumber(config.getParameter("first_image", 0))
  self.plane = tonumber(config.getParameter("plane", 0))
  
  init_scriptorium_space(self.family, self.genus, self.species)
  
  self.base_image = 0
  self.pose_image = 0
  self.killed = false
  self.tick_rate = 0
  self.range_check = 100
  self.last_tick_time = 0
  
  self.last_colliding_state = false
  self.TARG = nil
  self.OWNR = entity.id()
  
  if (self.family == CAOS.FAMILY.INVALID) then
    self.OWNR = nil
    install()
    
    self.killed = true
  end
end

function update(dt)
  -- Check Collision
  local isColliding = mcontroller.isColliding()
  if self.last_colliding_state ~= isColliding then
    self.last_colliding_state = isColliding
    if isColliding then
      create_coroutine(CAOS.EVENT.COLLIDE)
    end
  end
  
  -- Check Timer
  if self.tick_rate > 0 and world.time() > self.last_tick_time + c2sb_ticks(self.tick_rate) then
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

function create_coroutine(event)
  if script_coroutine ~= nil and coroutine.status(script_coroutine) ~= "dead" and self.current_event == event then
    return
  end
  
  if scriptorium[self.family][self.genus][self.species][event] ~= nil then
    logInfo("Running event script %s", event)
    self.TARG = self.OWNR
    self.current_event = event
    script_coroutine = coroutine.create(scriptorium[self.family][self.genus][self.species][event])
  end
end
