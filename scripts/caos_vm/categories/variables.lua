----------------------
-- HELPER FUNCTIONS --
----------------------

function getv(variable)
  assert(type(variable) == "string")
  if (variable:len() ~= 4) then
    sb.logInfo("getv invalid variable: %s", variable)
    return 0
  end
  
  local variable_name = variable:gsub("^%l", string.lower)
  local variable_prefix = variable_name:sub(1, 2)
  local variable_number = variable_name:sub(3, 4)
  
  local target = nil
  if (variable_prefix == "ov") then
    target = self.TARG
  elseif (variable_prefix == "mv") then
    target = self.OWNR
  elseif (variable_prefix == "va") then
    self.local_variables = self.local_variables or {}
    return self.local_variables[variable_name] or 0
  end
  
  if (target ~= nil) then
    return world.callScriptedEntity(target, "remote_getv", variable_number)
  else
    sb.logInfo("getv has nil target, prefix: %s, number: %s", variable_prefix, variable_number)
    return 0
  end
end

function remote_getv(variable_id)
  self.caos.variables = self.caos.variables or {}
  return self.caos.variables[variable_id] or 0
end

--------------------
-- CAOS FUNCTIONS --
--------------------

-- Makes a variable positive (its absolute value), so if var is negative var = 0 - var, otherwise
-- var is left alone.
function absv(var)
  setv(var, math.abs(getv(var)))
end

-- Returns arccosine of x in degrees.
CAOS.Cmd("acos", function(x)
  return math.acos(x) * 180.0 / math.pi
end)

-- Concatenates two strings, so var = var + append.
CAOS.Cmd("adds", function(var, append)
  setv(var, getv(var)..append)
end, 1)

-- Adds two integers or floats, so var = var + sum.
CAOS.Cmd("addv", function(var, sum)
  setv(var, getv(var) + sum)
end, 1)

-- Peform a bitwise AND on an integer variable, so var = var & value.
CAOS.Cmd("andv", function(var, value)
  setv(var, getv(var) & value)
end, 1)

-- Returns arcsine of x in degrees.
CAOS.Cmd("asin", function(x)
  return math.asin(x) * 180.0 / math.pi
end)

-- Returns arctangent of x in degrees.
CAOS.Cmd("atan", function(x)
  return math.atan(x) * 180.0 / math.pi
end)

-- Divides a variable by an integer or float, so var = var / div. Uses integer division if both
-- numbers are integers, or floating point division otherwise.
CAOS.Cmd("divv", function(var, div)
  setv(var, getv(var) / div)
end, 1)

-- Returns the game name. For example "Creatures 3".
gnam = "Starbound"

-- Converts the given string into all lower case letters.
CAOS.Cmd("lowa", function(any_old)
  return any_old:lower()
end)

-- Gives the remainder (or modulus) when a variable is divided by an integer, so var = var % mod.
-- Both values should to be integers.
CAOS.Cmd("modv", function(var, mod)
  setv(var, getv(var) % mod)
end, 1)

-- Multiplies a variable by an integer or float, so var = var * mul.
CAOS.Cmd("mulv", function(var, mul)
  setv(var, getv(var) * mul)
end, 1)

-- Reverse the sign of the given integer or float variable, so var = 0 - var.
function negv(var)
  setv(var, -getv(var))
end

-- Peform a bitwise NOT on an integer variable.
function notv(var)
  setv(var, ~getv(var))
end

-- Peform a bitwise OR on an integer variable, so var = var | value.
CAOS.Cmd("orrv", function(var, value)
  setv(var, getv(var) | value)
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

function rndv(variable, min, max)
  setv(variable, rand(min, max))
end

-- Stores a reference to an agent in a variable.
function seta(var, value)
  setv(var, value)
end

-- Stores an integer or float in a variable.
CAOS.Cmd("setv", function(var, value)
  if (var:len() ~= 4) then
    sb.logInfo("setv invalid variable: %s", var)
    return
  end
  
  local var_name = var:gsub("^%l", string.lower)
  local var_prefix = var_name:sub(1, 2)
  local var_number = var_name:sub(3, 4)
  
  local target = nil
  if (var_prefix == "ov") then
    target = self.TARG
  elseif (var_prefix == "mv") then
    target = self.OWNR
  elseif (var_prefix == "va") then
    self.local_variables = self.local_variables or {}
    self.local_variables[var_name] = value
  end
  
  if (target ~= nil) then
    world.callScriptedEntity(target, "remote_setv", var_number, value)
  end
end, 1)

function remote_setv(variable_id, value)
  self.caos.variables = self.caos.variables or {}
  self.caos.variables[variable_id] = value
end

-- Calculates a square root.
CAOS.Cmd("sqrt", function(value)
  return math.sqrt(value)
end)

-- Subtracts an integer or float from a variable, so var = var - sub.
CAOS.Cmd("subv", function(var, value)
  setv(var, getv(var) - value)
end, 1)

-- Converts the given string into all upper case letters.
CAOS.Cmd("uppa", function(any_old)
  return any_old:upper()
end)

-- Returns the first parameter sent to a script.
_p1_ = nil

-- Returns the second parameter sent to a script.
_p2_ = nil
