
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

function CAOS.debugArg(arg)
  if type(arg) == "function" then
    return "<function>"
  elseif type(arg) == "table" and arg.is_caos_command then
    return arg.name
  elseif type(arg) == "table" and arg.is_caos_var then
    return arg.name
  end
  return tostring(arg)
end

function CAOS.debugArgList(args)
  local result = {}
  for i, arg in ipairs(args) do
    table.insert(result, CAOS.debugArg(arg))
  end
  return table.concat(result, " ")
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
      argString = CAOS.debugArgList(args)
      sb.logInfo("[%s:%s,%s,%s] %s %s", entity.id(),
                                        storage.caos.family,
                                        storage.caos.genus,
                                        storage.caos.species,
                                        t.name,
                                        argString)
    end

    -- Store the last n calls so that we can find out where we are in the script
    self.recent_commands = self.recent_commands or {}
    if #self.recent_commands >= 10 then
      table.remove(self.recent_commands, 1)
    end
    table.insert(self.recent_commands, t.name.." "..CAOS.debugArgList(args))

    -- Resolve args (calls functions, retrieves variables, etc)
    for i = 1, args.n do
      if ((1 << (i-1)) & t.noResolveMask) == 0 then
        args[i] = CAOS.resolveVariable(args[i])
      end
    end

    -- Next, determine how it's operated.
    local result = nil
    if t.operateOn == "OWNR" then
      if t.is_caos_var then
        result = t.definition(t, table.unpack(args))
      else
        result = t.definition(table.unpack(args))
      end
    elseif t.operateOn == "TARG" then
      if self.TARG ~= nil and not world.entityExists(self.TARG) then
        local recent_commands = table.concat(self.recent_commands, "\n  ")
        error("Invalid TARG was \""..tostring(self.TARG).."\" on call to "..t.name.."; Script="..storage.agentName.."; Recent: \n  "..recent_commands)
      end
      if t.is_caos_var then
        result = world.callScriptedEntity(self.TARG, t.name..".definition", t, table.unpack(args))
      else
        result = world.callScriptedEntity(self.TARG, t.name..".definition", table.unpack(args))
      end
    end

    -- Uncomment this to behave like Creatures 1 ???
    --if not self.instant and not self.locked and not t.is_caos_var then
    --  coroutine.yield()
    --end
    return result
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
function CAOS.register(command)
  -- CAOS is case insensitive, but the prominent conventions are either all-upper or all-lower
  local name = command.name:lower()
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
  CAOS.register(cmd)
end

function CAOS.TargCmd(command_name, implementation, noResolveArgMask)
  CAOS.Cmd(command_name, implementation, noResolveArgMask, "TARG")
end
