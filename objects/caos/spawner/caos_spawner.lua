function init()
  object.setInteractive(true)
end

function onInteraction(args)
  world.spawnMonster("test_agent", entity.position())
end

