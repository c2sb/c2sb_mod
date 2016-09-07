-- NOTES
--  * Y values need to be inverted. Starbound: y=0 is the world bottom; Creatures: y=0 is the world top
-- 
--
CAOS = CAOS or {}
--CAOS.DEBUG = true

-- These are for holding on to the CAOS colon-syntax commands
brn = {}
dbg = {}
net = {}
new = {}
pat = {}
prt = {}


-- Resolves a variable. If var is a function, then it is called with no args. If var is a table,
-- then it calls it (call override in the table). Otherwise var is returned.
function CAOS.resolveVariable(var)
  if type(var) == "function" then
    return var()
  elseif type(var) == "table" and var.T == "CMD" then
    return var()
  elseif type(var) == "string" and var:len() == 4 then
    -- TEMPORARY: Variables!
    local var_prefix = var:sub(1, 2):lower()
    if var_prefix == "ov" or var_prefix == "mv" or var_prefix == "va" then
      return getv(var)
    end
  end
  return var
end

-- CAOS command object, used to store command information such as how it operates.
CaosCmd = {
-- Extend/override these values
  -- Name of the command, used in debugging
  name = nil,
  -- Where the command is executed.
  --    OWNER = Runs in the local script context.
  --    TARGET = First resolves its arguments, then calls world.callScriptedEntity.
  operateOn = "OWNR",
  -- The function definition, as it appears to the final callee
  definition = nil,
  -- Indicates parameter numbers that shouldn't be resolved
  noResolveMask = 0,

-- Private use
  -- Used to determine the purpose of this hash
  T = "CMD",
  -- Only warn that a command isn't implemented once
  warnOnce = false,

  __call = function(t, ...)
    if t.definition == nil then
      if not t.warnOnce then
        t.warnOnce = true
        sb.logWarn("CAOS function %s is not implemented.", t.name)
      end
      return
    end

    local args = table.pack(...)

    -- Log the call
    if CAOS.DEBUG then
      local pcallResult, argString = pcall(table.concat, args, " ")
      if not pcallResult then
        argString = "(failed to resolve args)"
      end
      sb.logInfo("[%s:%s,%s,%s] %s %s", entity.id(),
                                        self.caos.family,
                                        self.caos.genus,
                                        self.caos.species,
                                        t.name,
                                        argString)
    end

    -- Resolve args (calls functions, retrieves variables, etc)
    for i = 1, args.n do
      if ((1 << (i-1)) & t.noResolveMask) == 0 then
        args[i] = CAOS.resolveVariable(args[i])
      end
    end

    local operateOn = t.operateOn
    -- Conditional targ
    if operateOn == "CTARG" then
      if self.OWNR ~= nil then
        operateOn = "OWNR"
      else
        operateOn = "TARG"
      end
    end

    -- Next, determine how it's operated.
    if operateOn == "OWNR" then
      return t.definition(table.unpack(args))
    elseif operateOn == "TARG" then
      return world.callScriptedEntity(self.TARG, t.name..".definition", table.unpack(args))
    end
  end
}

-- Creates a new CaosCmd with the given table o.
function CaosCmd.new(self, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function CAOS.Cmd(command_name, implementation, noResolveArgMask, operateOnTarget)
  command_name = command_name:lower()
  operateOnTarget = operateOnTarget or "OWNR"
  local cmd = CaosCmd:new {
    name = command_name,
    definition = implementation,
    operateOn = operateOnTarget,
    noResolveMask = noResolveArgMask or 0
  }

  -- CAOS is case insensitive, but there's no point covering every case combination
  if command_name ~= "type" then
    _ENV[command_name] = cmd
  end
  _ENV[command_name:upper()] = cmd
end

function CAOS.TargCmd(command_name, implementation, noResolveArgMask)
  CAOS.Cmd(command_name, implementation, noResolveArgMask, "TARG")
end

function CAOS.ConditionalTargCmd(command_name, implementation, noResolveArgMask)
  CAOS.Cmd(command_name, implementation, noResolveArgMask, "CTARG")
end


-- Include all CAOS constants, helpers, and commands
require("/scripts/caos_vm/constants.lua")
require("/scripts/caos_vm/convert.lua")
require("/scripts/caos_vm/helpers.lua")
require("/scripts/caos_vm/categories/agents.lua")
require("/scripts/caos_vm/categories/brain.lua")
require("/scripts/caos_vm/categories/camera.lua")
require("/scripts/caos_vm/categories/cdplayer.lua")
require("/scripts/caos_vm/categories/compounds.lua")
require("/scripts/caos_vm/categories/creatures.lua")
require("/scripts/caos_vm/categories/debug.lua")
require("/scripts/caos_vm/categories/files.lua")
require("/scripts/caos_vm/categories/flow.lua")
require("/scripts/caos_vm/categories/genetics.lua")
require("/scripts/caos_vm/categories/history.lua")
require("/scripts/caos_vm/categories/input.lua")
require("/scripts/caos_vm/categories/map.lua")
require("/scripts/caos_vm/categories/motion.lua")
require("/scripts/caos_vm/categories/net.lua")
require("/scripts/caos_vm/categories/ports.lua")
require("/scripts/caos_vm/categories/resources.lua")
require("/scripts/caos_vm/categories/scripts.lua")
require("/scripts/caos_vm/categories/sounds.lua")
require("/scripts/caos_vm/categories/time.lua")
require("/scripts/caos_vm/categories/variables.lua")
require("/scripts/caos_vm/categories/vehicles.lua")
require("/scripts/caos_vm/categories/world.lua")
