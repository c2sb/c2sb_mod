require "/scripts/caos_vm/caos.lua"

function init()
  self.random = sb.makeRandomSource(world.time() + entity.id() * 1000)
  self.caos = {}

  object.setInteractive(true)
end

function onInteraction(args)
  injectAgent("snotrock")
  injectAgent("trapper")
  injectAgent("tuba")
  injectAgent("WeatherGenerator2")
  injectAgent("NG_Eastertribble")
  injectAgent("Botanoid")
  injectAgent("BalloonPlant")
  injectAgent("robot_toy")
  injectAgent("RubberBall")
  injectAgent("Roamer")
end

function loadAgentScript(agentName)
  self.loaded = self.loaded or {}
  if not self.loaded[agentName] then
    _ENV[agentName] = {}
    require("/agents/scripts/"..agentName..".lua")
    self.loaded[agentName] = true
  end
end

function injectAgent(agentName)
  self.agentName = agentName
  loadAgentScript(agentName)
  _ENV[agentName].install()
end

function removeAgent(agentName)
  self.agentName = agentName
  loadAgentScript(agentName)
  _ENV[agentName].uninstall()
end
