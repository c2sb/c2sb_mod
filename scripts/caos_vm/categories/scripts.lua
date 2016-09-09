--------------------
-- CAOS FUNCTIONS --
--------------------

-- This command indicates that the following commands should execute in a single tick - ie the
-- script cannot be interrupted by the script 'scheduler'. This can be important for certain tasks
-- which might leave an agent in an undefined (and dangerous) state if interrupted. The INST state
-- is broken either manually, using a SLOW command, or implictly, if a blocking instruction is
-- encountered (eg WAIT). Blocking instructions force the remainder of the script's timeslice to be
-- discarded.
CAOS.Cmd("inst", function()
  self.instant = true
end)

-- Registers uninstall script
function rscr(fcn_callback)
  CAOS.uninstall = CAOS.uninstall or {}
  CAOS.uninstall[self.agentName] = fcn_callback
end

-- Registers a script in the scriptorium.
-- Note: Must not be constructed.
function scrp(family, genus, species, event, fcn_callback)
  init_scriptorium_space(family, genus, species)
  scriptorium[family][genus][species][event] = fcn_callback
end

CAOS.Cmd("lock", function()
  self.locked = true
end)

-- Remove specified script from the scriptorium.
function scrx(family, genus, species, event)
  scriptorium[family][genus][species][event] = nil
end

-- Turn off INST state.
CAOS.Cmd("slow", function()
  self.instant = false
  coroutine.yield()
end)

-- Stops running the current script. Compare STPT.
CAOS.Cmd("stop", function()
  self.stop_script = true
  coroutine.yield()
end)

-- Stops any currently running script in the target agent. See also STOP.
CAOS.TargCmd("stpt", function()
  self.stop_script = true
end)

CAOS.Cmd("unlk", function()
  self.locked = false
end)

-- Block the script for the specified number of ticks. This command does an implicit SLOW.
CAOS.Cmd("wait", function(ticks)
  self.instant = false
  local target_time = toSB.ticks(ticks) + world.time()
  while world.time() < target_time do
    coroutine.yield()
  end
end)
