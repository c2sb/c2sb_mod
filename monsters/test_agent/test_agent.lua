--require "/scripts/caos_vm/caos.lua"
--require "/monsters/test_agent/balloonplant.lua"
--require("/scripts/util.lua")
require "/scripts/caos_vm/constants.lua"

function init()
  self.family = config.getParameter("family", CAOS.FAMILY.INVALID)
  self.genus = config.getParameter("genus", -1)
  self.species = config.getParameter("species", -1)
  self.sprite_file = config.getParameter("sprite_file", "NOT_FOUND")
  self.image_count = config.getParameter("image_count", 0)
  self.first_image = config.getParameter("first_image", 0)
  self.plane = config.getParameter("plane", 0)
  self.base_image = 0
  self.pose_image = 0
  self.killed = false
  self.tick_rate = 0
  
  if (self.family == CAOS.FAMILY.INVALID) then
    -- TODO Run install script
    
    self.killed = true
  end
end

function update(dt)
  -- TODO
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
