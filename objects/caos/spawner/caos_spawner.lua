require "/scripts/caos_vm/caos.lua"

function init()
  self.random = sb.makeRandomSource(world.time() + entity.id() * 1000)
  self.caos = {}

  object.setInteractive(true)
end

function onInteraction(args)
  injectAgent("BalloonPlant")
  injectAgent("robot_toy")
  injectAgent("RubberBall")
end

function injectAgent(agentName)
  require("/agents/scripts/"..agentName..".lua")
  self.agentName = agentName
  _ENV[agentName].install()
end

function removeAgent(agentName)
  require("/agents/scripts/"..agentName..".lua")
  self.agentName = agentName
  _ENV[agentName].uninstall()
end
