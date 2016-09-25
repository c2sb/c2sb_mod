function init()
  message.setHandler("applyStatusEffect", function(_, _, effectConfig, duration, sourceEntityId)
      status.addEphemeralEffect(effectConfig, duration, sourceEntityId)
    end)
end

function applyDamageRequest(damageRequest)
  if damageRequest.damageType == "Environment" or damageRequest.damageSourceKind == "caos_status" then
    return {}
  end

  world.callScriptedEntity(entity.id(), "damage")
  return {}
end

function update(dt)
end
