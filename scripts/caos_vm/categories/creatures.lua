-- Since we're not currently emulating creatures, most of these will just be placeholders.


--------------------
-- CAOS FUNCTIONS --
--------------------

-- Adjusts chemical (0 to 255) by concentration -1.0 to +1.0 in the target creature's bloodstream.
-- Returns concentration (0.0 to 1.0) of chemical (1 to 255) in the target creature's bloodstream.
CAOS.Cmd("chem")

-- Send stimulus to a specific creature. Can be used from an install script, but the stimulus will
-- be from NULL, so the creature will react but not learn.
CAOS.Cmd("stim_writ")
