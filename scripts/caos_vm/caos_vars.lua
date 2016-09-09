
function CAOS.MakeVar(var_name, getter_implementation, setter_implementation, noResolveArgMask)
  var_name = var_name:lower()
  local cmd = CaosCmd:new {
    name = var_name,
    definition = getter_implementation,
    set = setter_implementation,
    noResolveMask = noResolveArgMask or 0,
    is_caos_var = true
  }
  return cmd
end

function CAOS.VAxx(index)
  local function getter(t)
    self.local_variables = self.local_variables or {}
    return self.local_variables[t.index] or 0
  end

  local function setter(t, value)
    self.local_variables = self.local_variables or {}
    self.local_variables[t.index] = value
  end

  local var_name = string.format("va%02d", index)
  local cmd = CAOS.MakeVar(var_name, getter, setter)
  cmd.index = index

  CAOS.register(var_name, cmd)
end

function CAOS.getCaosVar(index)
  self.caos.variables = self.caos.variables or {}
  return self.caos.variables[index] or 0
end

function CAOS.setCaosVar(index, value)
  self.caos.variables = self.caos.variables or {}
  self.caos.variables[index] = value
end

function CAOS.OVxx(index)
  local function getter(t)
    return world.callScriptedEntity(self.TARG, "CAOS.getCaosVar", t.index)
  end

  local function setter(t, value)
    world.callScriptedEntity(self.TARG, "CAOS.setCaosVar", t.index, value)
  end

  local var_name = string.format("ov%02d", index)
  local cmd = CAOS.MakeVar(var_name, getter, setter)
  cmd.index = index

  CAOS.register(var_name, cmd)
end

function CAOS.MVxx(index)
  local function getter(t)
    return CAOS.getCaosVar(t.index)
  end

  local function setter(t, value)
    CAOS.setCaosVar(t.index, value)
  end

  local var_name = string.format("mv%02d", index)
  local cmd = CAOS.MakeVar(var_name, getter, setter)
  cmd.index = index

  CAOS.register(var_name, cmd)
end

-- Register variable commands
for i = 0, 99 do
  CAOS.VAxx(i)
  CAOS.OVxx(i)
  CAOS.MVxx(i)
end
