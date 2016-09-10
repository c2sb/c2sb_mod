
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Returns the value of the down constant.
down = CAOS.DIRECTIONS.DOWN

-- Target now constantly emits an amount of a CA into the room it is in.
-- TODO
CAOS.TargCmd("emit")

-- Returns the room id at point x,y on the map. If the point is outside the room system,
-- it returns -1.
-- TODO
CAOS.TargCmd("grap", function(x, y)
  return -1
end)

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

-- Returns the id of the room containing the midpoint of the specified agent.
-- TODO
CAOS.Cmd("room")

-- Sets the type of a room. The meaning of the types depends on the game. RATE also uses the room
-- type.
-- TODO
CAOS.Cmd("rtyp")

-- Returns the value of the up constant.
_up_ = CAOS.DIRECTIONS.UP
