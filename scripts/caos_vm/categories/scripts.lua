--------------------
-- CAOS FUNCTIONS --
--------------------

-- This command indicates that the following commands should execute in a single tick - ie the
-- script cannot be interrupted by the script 'scheduler'. This can be important for certain tasks
-- which might leave an agent in an undefined (and dangerous) state if interrupted. The INST state
-- is broken either manually, using a SLOW command, or implictly, if a blocking instruction is
-- encountered (eg WAIT). Blocking instructions force the remainder of the script's timeslice to be
-- discarded.
function inst()
  -- TODO
end

-- Registers a script in the scriptorium.
function scrp(family, genus, species, event, fcn_callback)
  --sb.logInfo("scrp %s %s %s %s", family, genus, species, event)
  init_scriptorium_space(family, genus, species)
  scriptorium[family][genus][species][event] = fcn_callback
end

function lock()
  self.locked = true
end

-- Remove specified script from the scriptorium.
function scrx(family, genus, species, event)
  scriptorium[family][genus][species][event] = nil
end

-- Turn off INST state.
function slow()
  -- TODO
end

-- Stops running the current script. Compare STPT.
function stop()
  self.stop_script = true
  coroutine.yield()
end

-- Stops any currently running script in the target agent. See also STOP.
function stpt()
  caos_targfunction_wrap0("stpt")
end

function unlk()
  self.locked = false
end

function remote_stpt()
  self.stop_script = true
end

-- Block the script for the specified number of ticks. This command does an implicit SLOW.
function wait(ticks)
  logInfo("wait %s", ticks)
  ticks = caos_number_arg(ticks)
  local target_time = toSB.ticks(ticks) + world.time()
  while world.time() < target_time do
    coroutine.yield()
  end
end
