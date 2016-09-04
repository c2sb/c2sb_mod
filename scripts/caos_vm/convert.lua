fromSB = {}
toSB = {}

fromSB.coordinate = function(value)
  return value * 16.0
end

toSB.coordinate = function(value)
  return value / 16.0
end

fromSB.y_coordinate = function(value)
  return -fromSB.coordinate(value)
end

toSB.y_coordinate = function(value)
  return -toSB.coordinate(value)
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
