
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

-- Divides a variable by an integer or float, so var = var / div. Uses integer division if both
-- numbers are integers, or floating point division otherwise.
CAOS.Cmd("divv", function(var, div)
  var:set(var() / div)
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
  var:set(var() % mod)
end, 1)

-- Multiplies a variable by an integer or float, so var = var * mul.
CAOS.Cmd("mulv", function(var, mul)
  var:set(var() * mul)
end, 1)

-- Reverse the sign of the given integer or float variable, so var = 0 - var.
function negv(var)
  var:set(-var())
end

-- Peform a bitwise NOT on an integer variable.
function notv(var)
  var:set(~var())
end

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

function rndv(variable, min, max)
  var:set(rand(min, max))
end

-- Stores a reference to an agent in a variable.
function seta(var, value)
  var:set(value)
end

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
