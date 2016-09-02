function init()
  object.setInteractive(true)
end

function onInteraction(args)
  world.spawnMonster("test_agent", object.toAbsolutePosition({0, 6}))
end

