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
  self.random = sb.makeRandomSource(world.time() + entity.id() * 10000)
  self.messages = {}

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
  
  if not self.locked then
    -- Only create one coroutine this frame
    local is_coroutine_created = (
      checkCollision()
      or checkTimer()
      or checkMessages()
      or checkActivate())
  end
  
  -- Resume script
  if isScriptActive() and coroutine.status(script_coroutine) == "suspended" then
    local result, message = coroutine.resume(script_coroutine)
    if not result then
      sb.logError("Coroutine failed: %s", message)
    end
  elseif not isScriptActive() then
    self.locked = false
  end
  self.last_velocity = mcontroller.velocity()
end

function interact(args)
  self.interacted = true
end

function damage(args)
  self.damaged = true
end

function shouldDie()
  return self.killed
end

function die()
end

function uninit()
end

----------------------------------------- END callbacks -----------------------------------------

----------------------------------------- EVENT CHECKS -----------------------------------------
function checkCollision()
  local isColliding = mcontroller.isColliding()
  if self.last_colliding_state ~= isColliding then
    self.last_colliding_state = isColliding
    if isColliding then
      return create_coroutine(CAOS.EVENT.COLLISION, self.last_velocity[1], -self.last_velocity[2])
    end
  end
  return false
end

function checkTimer()
  if self.caos.tick_rate > 0 and world.time() > self.last_tick_time + toSB.ticks(self.caos.tick_rate) then
    self.last_tick_time = world.time()
    -- Timer shouldn't interrupt other scripts
    if isScriptActive() then return false end
    return create_coroutine(CAOS.EVENT.TIMER)
  end
  return false
end

function checkMessages()
  local result = false
  -- Create a coroutine from the next message that should be triggered
  for i = 1, #self.messages do
    if self.messages[i].execute_at <= world.time() then
      result = create_coroutine(self.messages[i].message_id, self.messages[i].param_1, self.messages[i].param_2, self.messages[i].from_entity)
      if result then
        break
      end
    end
  end

  -- Remove all other messages that would otherwise be triggered (conflict)
  -- NOTE: I have no idea if this is the correct behaviour
  for i = #self.messages, 1, -1 do
    if self.messages[i].execute_at <= world.time() then
      table.remove(self.messages, i)
    end
  end
  return result
end

function checkActivate()
  if self.interacted then
    self.interacted = false

    -- Randomly choose an activate event
    local event = CAOS.EVENT.ACTIVATE_1
    if self.random:randu32() % 2 == 0 then
      event = CAOS.EVENT.ACTIVATE_2
    end

    return create_coroutine(event)
  end
  return false
end

----------------------------------------- Other functions -----------------------------------------

-- Initializes caos-related values/variables
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
  self.caos.range_check = 500
end

-- Kills the agent
function killSelf()
  self.killed = true
  -- Attempt to hide it for the delay between this call and the shouldDie() callback
  animator.setAnimationState("body", "invisible")
end

-- Checks if an event script is currently running
function isScriptActive()
  return script_coroutine ~= nil and coroutine.status(script_coroutine) ~= "dead"
end

-- Creates a coroutine for the given event. Returns true if the event script exists and is not
-- already running, and false if the event was not created.
function create_coroutine(event, param1, param2, from_entity)
  if scriptorium[self.caos.family][self.caos.genus][self.caos.species][event] ~= nil then
    logInfo("Running event script %s", event)
    self.TARG = self.OWNR
    self.current_event = event
    _p1_ = param1
    _p2_ = param2
    from = from_entity
    script_coroutine = coroutine.create(scriptorium[self.caos.family][self.caos.genus][self.caos.species][event])
    return true
  end
  return false
end
