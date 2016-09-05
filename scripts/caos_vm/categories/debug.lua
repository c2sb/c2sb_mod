
--------------------
-- CAOS FUNCTIONS --
--------------------

-- Causes a division by zero exception in the processor, to test the engine's error handling routines.
function bang()
  return 1 / 0
end

-- Confirms that a condition is true. If it isn't, it displays a runtime error dialog.
function dbg_asrt(condition)
  assert(condition)
end

-- Send a string to the debug log - use DBG: POLL to retrieve.
function dbg_outs(value)
  -- TODO string variables
  sb.logInfo("%s", value)
end

-- Lists all command names to the output stream.
function help()
  sb.logInfo("help was called, but this is a stub")
end

-- Outputs help on the given command to the output stream.
function mann(command)
  sb.logInfo("mann was called, but this is a stub")
end

-- Windows only. Sends information about the memory allocated to the output stream. In order, these
-- are the Memory Load (unknown), Total Physical (size in bytes of physical memory), Available
-- Physical (free physical space), Total Page File (maximum possible size of page file), Available
-- Page File (size in bytes of space available in paging file), Total Virtual (size of user mode
-- portion of the virtual address space of the engine), Available Virtual (size of unreserved and
-- uncommitted memory in the user mode portion of the virtual address space of the engine).
function memx()
  -- Assume we're not using Windows... done.
end
