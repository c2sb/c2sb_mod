
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Returns the value of the down constant.
function down()
  return CAOS.DIRECTIONS.DOWN
end

-- Returns the value of the left constant.
function left()
  return CAOS.DIRECTIONS.LEFT
end

-- Value from 1 to 100. Sets which room boundaries the agent can pass through. The smaller the PERM
-- the more it can go through. DOOR sets the corresponding room boundary permiability. Also used
-- for ESEE, to decide what it can see through.
-- Returns the target's map permiability.
function perm(permiability)
  return caos_targfunction_wrap1("perm", permiability)
end

function remote_perm(permiability)
  if permiability ~= nil then
    self.perm = permiability
  end
  -- TODO other stuff
  return self.perm
end

-- Returns the value of the right constant.
function rght()
  return CAOS.DIRECTIONS.RIGHT
end

-- Returns the value of the up constant.
function _up_()
  return CAOS.DIRECTIONS.UP
end
