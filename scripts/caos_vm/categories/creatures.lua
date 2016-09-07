-- Since we're not currently emulating creatures, most of these will just be placeholders.


--------------------
-- CAOS FUNCTIONS --
--------------------

-- Send stimulus to a specific creature. Can be used from an install script, but the stimulus will
-- be from NULL, so the creature will react but not learn.
CAOS.Cmd("stim_writ")
