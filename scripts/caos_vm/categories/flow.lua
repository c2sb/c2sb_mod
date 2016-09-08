
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Loop through a block of code a number of times. Must have a matching REPE command to close
-- the block.
CAOS.Cmd("reps", function(count, fcn_callback)
  for i = 1, count do
    fcn_callback()
  end
end, 1 << 1)
