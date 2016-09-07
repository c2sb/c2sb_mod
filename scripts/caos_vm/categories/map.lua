
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Returns the value of the down constant.
down = CAOS.DIRECTIONS.DOWN

-- Returns the value of the left constant.
left = CAOS.DIRECTIONS.LEFT

-- Value from 1 to 100. Sets which room boundaries the agent can pass through. The smaller the PERM
-- the more it can go through. DOOR sets the corresponding room boundary permiability. Also used
-- for ESEE, to decide what it can see through.
-- Returns the target's map permiability.
CAOS.TargCmd("perm", function(permiability)
  if permiability ~= nil then
    self.perm = permiability
  end
  -- TODO other stuff
  return self.perm
end)

-- Returns the value of the right constant.
right = CAOS.DIRECTIONS.RIGHT

-- Returns the value of the up constant.
_up_ = CAOS.DIRECTIONS.UP
