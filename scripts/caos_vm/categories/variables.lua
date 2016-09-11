
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Makes a variable positive (its absolute value), so if var is negative var = 0 - var, otherwise
-- var is left alone.
function absv(var)
  var:set(math.abs(var()))
end

-- Returns arccosine of x in degrees.
CAOS.Cmd("acos", function(x)
  return math.acos(x) * 180.0 / math.pi
end)

-- Concatenates two strings, so var = var + append.
CAOS.Cmd("adds", function(var, append)
  var:set(var()..append)
end, 1)

-- Adds two integers or floats, so var = var + sum.
CAOS.Cmd("addv", function(var, sum)
  var:set(var() + sum)
end, 1)

-- Peform a bitwise AND on an integer variable, so var = var & value.
CAOS.Cmd("andv", function(var, value)
  var:set(var() & value)
end, 1)

-- Returns arcsine of x in degrees.
CAOS.Cmd("asin", function(x)
  return math.asin(x) * 180.0 / math.pi
end)

-- Returns arctangent of x in degrees.
CAOS.Cmd("atan", function(x)
  return math.atan(x) * 180.0 / math.pi
end)

-- Deletes the specified GAME variable.
CAOS.Cmd("delg", function(variable_name)
  world.setProperty(variable_name, 0)
end)

-- Divides a variable by an integer or float, so var = var / div. Uses integer division if both
-- numbers are integers, or floating point division otherwise.
CAOS.Cmd("divv", function(var, div)
  var:set(var() / div)
end, 1)

-- A game variable is a global variable which can be referenced by name.
-- eg: SETV GAME "pi" 3.142
-- Game variables are stored as part of the world and so will be saved out in the world file. If a
-- script uses a non-existant game variable, that variable will be created automatically (with
-- value integer zero). Agents, integers, floats and strings can be stored in game variables.
-- Variable names are case sensitive. When a new world is loaded, all the game variables are cleared.
-- There are some conventions for the variable names:
-- engine_ for Creatures Engine
-- cav_ for Creatures Adventures
-- c3_ for Creatures 3
-- 
-- It's important to follow these, as 3rd party developers will just use whatever names they fancy.
-- DELG deletes a game variable. See also the table of engine Game Variables.
CAOS.Cmd("game", function(variable_name)
  local function gameVarGetter(t)
    local result = world.getProperty(t.variable_name, 0)
    if tonumber(result) ~= nil then
      return tonumber(result)
    else
      return result
    end
  end
  
  local function gameVarSetter(t, value)
    world.setProperty(t.variable_name, value)
  end
  
  local var = CAOS.MakeVar("game", gameVarGetter, gameVarSetter)
  var.variable_name = variable_name
  return var
end)

-- Returns the game name. For example "Creatures 3".
gnam = "Starbound"

-- Converts the given string into all lower case letters.
CAOS.Cmd("lowa", function(any_old)
  return any_old:lower()
end)

-- Gives the remainder (or modulus) when a variable is divided by an integer, so var = var % mod.
-- Both values should to be integers.
CAOS.Cmd("modv", function(var, mod)
  var:set(var() % mod)
end, 1)

-- Multiplies a variable by an integer or float, so var = var * mul.
CAOS.Cmd("mulv", function(var, mul)
  var:set(var() * mul)
end, 1)

-- Reverse the sign of the given integer or float variable, so var = 0 - var.
CAOS.Cmd("negv", function(var)
  var:set(-var())
end, 1)

-- Peform a bitwise NOT on an integer variable.
CAOS.Cmd("notv", function(var)
  var:set(~var())
end, 1)

-- Peform a bitwise OR on an integer variable, so var = var | value.
CAOS.Cmd("orrv", function(var, value)
  var:set(var() | value)
end, 1)

-- Returns a random integer between value1 and value2 inclusive of both values. You can use negative
-- values, and have them either way round.
CAOS.Cmd("rand", function(value1, value2)
  if value1 == value2 then
    return value1
  elseif value1 > value2 then
    value1, value2 = value2, value1
  end
  return self.random:randu32() % (value2 - value1 + 1) + value1
end)

CAOS.Cmd("rndv", function(variable, min, max)
  variable:set(rand(min, max))
end, 1)

-- Stores a reference to an agent in a variable.
CAOS.Cmd("seta", function(var, value)
  var:set(value)
end, 1)

-- Sets a variable to a string value.
CAOS.Cmd("sets", function(var, value)
  var:set(value)
end, 1)

-- Stores an integer or float in a variable.
CAOS.Cmd("setv", function(var, value)
  var:set(value)
end, 1)

-- Calculates a square root.
CAOS.Cmd("sqrt", function(value)
  return math.sqrt(value)
end)

-- Subtracts an integer or float from a variable, so var = var - sub.
CAOS.Cmd("subv", function(var, value)
  var:set(var() - value)
end, 1)

-- Converts the given string into all upper case letters.
CAOS.Cmd("uppa", function(any_old)
  return any_old:upper()
end)

-- Returns the first parameter sent to a script.
_p1_ = nil

-- Returns the second parameter sent to a script.
_p2_ = nil
