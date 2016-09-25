-- Since we're not currently emulating creatures, most of these will just be placeholders.

function applyTargStatusEffect(effectName)
  applyStatusEffects(self.TARG, { { effect = effectName, duration = 0.4 } })
end

function setChemicalAdjustmentNegative(chemical, adjustment)
  if chemical == CAOS.CHEM.WOUNDED then
    applyTargStatusEffect("regeneration1")
  elseif chemical == CAOS.CHEM.COLDNESS then
    applyTargStatusEffect("iceblock")
  elseif chemical == CAOS.CHEM.HOTNESS then
    applyTargStatusEffect("burnspray")
  elseif chemical == CAOS.CHEM.HEAVY_METALS
    or chemical == CAOS.CHEM.CYANIDE
    or chemical == CAOS.CHEM.ATP_DECOUPLER then
    applyTargStatusEffect("antidote")
  end
end

function setChemicalAdjustmentPositive(chemical, adjustment)
  if chemical == CAOS.CHEM.WOUNDED then
    applyTargStatusEffect("weakpoison")
  elseif chemical == CAOS.CHEM.HEAVY_METALS
    or chemical == CAOS.CHEM.CYANIDE
    or chemical == CAOS.CHEM.ATP_DECOUPLER then
    applyTargStatusEffect("weakpoison")
  elseif chemical == CAOS.CHEM.EDTA then
    applyTargStatusEffect("antidote")
  end
end


-- Note that it is not possible to directly set player status, so the workaround is to spawn a
-- projectile.
function setChemicalAdjustment(chemical, adjustment)
  if adjustment < 0 then
    setChemicalAdjustmentNegative(chemical, adjustment)
  elseif adjustment > 0 then
    setChemicalAdjustmentPositive(chemical, adjustment)
  end
end

function getChemicalValue(chemical)

  return 0
end

--------------------
-- CAOS FUNCTIONS --
--------------------

-- Adjusts chemical (0 to 255) by concentration -1.0 to +1.0 in the target creature's bloodstream.
-- Returns concentration (0.0 to 1.0) of chemical (1 to 255) in the target creature's bloodstream.
CAOS.Cmd("chem", function(chemical, adjustment)
  if adjustment ~= nil then
    setChemicalAdjustment(chemical, adjustment)
  end
  return getChemicalValue(chemical)
end)

-- Send stimulus to a specific creature. Can be used from an install script, but the stimulus will
-- be from NULL, so the creature will react but not learn.
CAOS.Cmd("stim_writ")
