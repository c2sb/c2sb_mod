----------------------
-- HELPER FUNCTIONS --
----------------------

function getv(variable)
  if (variable:len() ~= 4) then
    logInfo("getv invalid variable: %s", variable)
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
    return self[variable_name] or 0
  end
  
  if (target ~= nil) then
    return world.callScriptedEntity(target, "remote_getv", variable_number)
  else
    logInfo("getv has nil target, prefix: %s, number: %s", variable_prefix, variable_number)
    return 0
  end
end

function remote_getv(variable_id)
  self.variables = self.variables or {}
  return self.variables[variable_id] or 0
end

--------------------
-- CAOS FUNCTIONS --
--------------------

-- Makes a variable positive (its absolute value), so if var is negative var = 0 - var, otherwise
-- var is left alone.
function absv(var)
  logInfo("absv %s", var)
  setv(var, math.abs(getv(var)))
end

-- Returns arccosine of x in degrees.
function acos(x)
  logInfo("acos %s", x)
  x = caos_number_arg(x)
  return math.acos(x) * 180.0 / math.pi
end

-- Concatenates two strings, so var = var + append.
function adds(var, append)
  logInfo("adds %s %s", var, append)
  setv(var, getv(var)..append)
end

-- Adds two integers or floats, so var = var + sum.
function addv(var, sum)
  logInfo("addv %s %s", var, sum)
  sum = caos_number_arg(sum)
  setv(var, getv(var) + sum)
end

-- Peform a bitwise AND on an integer variable, so var = var & value.
function andv(var, value)
  logInfo("andv %s %s", var, value)
  value = caos_number_arg(value)
  setv(var, getv(var) & value)
end

-- Returns arcsine of x in degrees.
function asin(x)
  logInfo("asin %s", x)
  x = caos_number_arg(x)
  return math.asin(x) * 180.0 / math.pi
end

-- Returns arctangent of x in degrees.
function atan(x)
  logInfo("atan %s", x)
  x = caos_number_arg(x)
  return math.atan(x) * 180.0 / math.pi
end

-- Divides a variable by an integer or float, so var = var / div. Uses integer division if both
-- numbers are integers, or floating point division otherwise.
function divv(var, div)
  logInfo("divv %s %s", var, div)
  div = caos_number_arg(div)
  setv(var, getv(var) / div)
end

-- Returns the game name. For example "Creatures 3".
function gnam()
  return "Starbound"
end

-- Converts the given string into all lower case letters.
function lowa(any_old)
  any_old:lower()
end

-- Gives the remainder (or modulus) when a variable is divided by an integer, so var = var % mod.
-- Both values should to be integers.
function modv(var, mod)
  logInfo("modv %s %s", var, mod)
  mod = caos_number_arg(mod)
  setv(var, getv(var) % mod)
end

-- Multiplies a variable by an integer or float, so var = var * mul.
function mulv(var, mul)
  logInfo("mulv %s %s", var, mul)
  mul = caos_number_arg(mul)
  setv(var, getv(var) * mul)
end

-- Reverse the sign of the given integer or float variable, so var = 0 - var.
function negv(var)
  logInfo("negv %s", var)
  setv(var, -getv(var))
end

-- Peform a bitwise NOT on an integer variable.
function notv(var)
  logInfo("notv %s", var)
  setv(var, ~getv(var))
end

-- Peform a bitwise OR on an integer variable, so var = var | value.
function orrv(var, value)
  logInfo("orrv %s %s", var, value)
  value = caos_number_arg(value)
  setv(var, getv(var) | value)
end

-- Returns a random integer between value1 and value2 inclusive of both values. You can use negative
-- values, and have them either way round.
function rand(value1, value2)
  --logInfo("rand %s %s", value1, value2)
  value1 = caos_number_arg(value1)
  value2 = caos_number_arg(value2)
  
  if value1 == value2 then
    return value1
  elseif value1 > value2 then
    value1, value2 = value2, value1
  end
  return self.random:randu32() % (value2 - value1) + value1
end

function rndv(variable, min, max)
  setv(variable, rand(min, max))
end

-- Stores a reference to an agent in a variable.
function seta(var, value)
  setv(var, value)
end

-- Stores an integer or float in a variable.
function setv(var, value)
  if (var:len() ~= 4) then
    logInfo("setv invalid variable: %s", var)
    return
  end
  
  value = caos_number_arg(value)
  
  local var_name = var:gsub("^%l", string.lower)
  local var_prefix = var_name:sub(1, 2)
  local var_number = var_name:sub(3, 4)
  
  local target = nil
  if (var_prefix == "ov") then
    target = self.TARG
  elseif (var_prefix == "mv") then
    target = self.OWNR
  elseif (var_prefix == "va") then
    self[var_name] = value
  end
  
  if (target ~= nil) then
    world.callScriptedEntity(target, "remote_setv", var_number, value)
  end
end

function remote_setv(variable_id, value)
  self.variables = self.variables or {}
  self.variables[variable_id] = value
end

-- Calculates a square root.
function sqrt(value)
  value = caos_number_arg(value)
  return math.sqrt(value)
end

-- Subtracts an integer or float from a variable, so var = var - sub.
function subv(variable, value)
  logInfo("subv %s %s", variable, value)
  value = caos_number_arg(value)
  setv(variable, getv(variable) - value)
end

-- Converts the given string into all upper case letters.
function uppa(any_old)
  any_old:upper()
end

-- Returns the first parameter sent to a script.
_p1_ = nil

-- Returns the second parameter sent to a script.
_p2_ = nil
