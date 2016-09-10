
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Jumps to a subroutine defined by SUBR. Execution will continue at the instruction after the
-- GSUB when the subroutine hits a RETN command.
CAOS.Cmd("gsub", function(destination)
  -- Checking for undefined behaviour. These will be slow, but could eliminate headaches.
  assert(destination ~= nil, "GSUB: Destination is undefined. Did you forget to move the SUBR above this call?")
  for key, value in pairs(_ENV) do
    assert(value ~= destination, "GSUB: Destination should be local scope. Did you forget to move the SUBR above this call?")
  end

  destination()
end, 1)

-- Loop through a block of code a number of times. Must have a matching REPE command to close
-- the block.
CAOS.Cmd("reps", function(count, fcn_callback)
  for i = 1, count do
    fcn_callback()
  end
end, 1 << 1)
