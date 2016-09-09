
-- Resolves a variable. If var is a function, then it is called with no args. If var is a table,
-- then it calls it (call override in the table). Otherwise var is returned.
function CAOS.resolveVariable(var)
  if type(var) == "function" then
    return var()
  elseif type(var) == "table" and var.is_caos_command then
    return var()
  elseif type(var) == "table" and var.is_caos_var then
    return var()
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
  is_caos_command = true,
  -- Only warn that a command isn't implemented once

  __call = function(t, ...)
    if t.definition == nil then
      if not world.getProperty("CAOS.warned."..t.name) then
        world.setProperty("CAOS.warned."..t.name, true)
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
      if t.is_caos_var then
        return t.definition(t, table.unpack(args))
      else
        return t.definition(table.unpack(args))
      end
    elseif operateOn == "TARG" then
      if t.is_caos_var then
        return world.callScriptedEntity(self.TARG, t.name..".definition", t, table.unpack(args))
      else
        return world.callScriptedEntity(self.TARG, t.name..".definition", table.unpack(args))
      end
    end
  end,

  __lt = function(t, obj)
    return CAOS.resolveVariable(t) < CAOS.resolveVariable(obj)
  end,

  __le = function(t, obj)
    return CAOS.resolveVariable(t) <= CAOS.resolveVariable(obj)
  end
}

-- Creates a new CaosCmd with the given table o.
function CaosCmd.new(self, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Register a CAOS command in the environment table
function CAOS.register(name, command)
  -- CAOS is case insensitive, but the prominent conventions are either all-upper or all-lower
  name = name:lower()
  if name ~= "type" then
    _ENV[name] = command
  end
  _ENV[name:upper()] = command
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
  CAOS.register(command_name, cmd)
end

function CAOS.TargCmd(command_name, implementation, noResolveArgMask)
  CAOS.Cmd(command_name, implementation, noResolveArgMask, "TARG")
end

function CAOS.ConditionalTargCmd(command_name, implementation, noResolveArgMask)
  CAOS.Cmd(command_name, implementation, noResolveArgMask, "CTARG")
end
