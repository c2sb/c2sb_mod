fromSB = {}
toSB = {}

-- One Starbound tile is 8 pixels
fromSB.coordinate = function(value)
  return (value * 8.0) / self.scale
end

toSB.coordinate = function(value)
  return (value * self.scale) / 8.0
end

fromSB.y_coordinate = function(value)
  return -fromSB.coordinate(value)
end

toSB.y_coordinate = function(value)
  return -toSB.coordinate(value)
end

-- Creatures: Pixels per tick
-- Starbound: Tiles per second
-- Note: Exclude scale in this calculation
fromSB.velocity = function(value)
  return (value * 8.0) / 20
end

toSB.velocity = function(value)
  -- 20 ticks per second
  return (value * 20) / 8.0
end

fromSB.y_velocity = function(value)
  return -fromSB.velocity(value)
end

toSB.y_velocity = function(value)
  return -toSB.velocity(value)
end

fromSB.boolean = function(value)
  if value == false then
    return 0
  else
    return 1
  end
end

toSB.boolean = function(value)
  if value == 0 then
    return false
  else
    return true
  end
end

-- NOTE: It's noted that a creatures tick is about 50ms (1/20 of a second). Starbound is timed in seconds (as a float value).
fromSB.ticks = function(value)
  return value * 20.0
end

toSB.ticks = function(value)
  return value / 20.0
end

fromSB.volume = function(value)
  return math.floor(value * 10000) - 10000
end

toSB.volume = function(value)
  return (value + 10000) / 10000.0
end
