CAOS = CAOS or {}

-- Direction constants
CAOS.DIRECTIONS = {
  LEFT = 0,
  RIGHT = 1,
  UP = 2,
  DOWN = 3
}

-- Agent attributes
CAOS.ATTRIBUTES = {
  CARRYABLE = 1,
  MOUSEABLE = 2,
  ACTIVATEABLE = 4,
  GREEDY_CABIN = 8,
  INVISIBLE = 16,
  FLOATABLE = 32,
  SUFFER_COLLISIONS = 64,
  SUFFER_PHYSICS = 128,
  CAMERA_SHY = 256,
  OPEN_AIR_CABIN = 512,
  ROTATABLE = 1024,
  PRESENCE = 2048
}

-- Agent permissions
CAOS.PERMISSIONS = {
  ACTIVATE_1 = 1,
  ACTIVATE_2 = 2,
  DEACTIVATE = 4,
  HIT = 8,
  EAT = 16,
  PICK_UP = 32
}

CAOS.TIME_OF_DAY = {
  DAWN = 0,
  MORNING = 1,
  AFTERNOON = 2,
  EVENING = 3,
  NIGHT = 4
}

CAOS.SEASON = {
  SPRING = 0,
  SUMMER = 1,
  AUTUMN = 2,
  WINTER = 3
}

-- Cellular automata (emit)
CAOS.CA_INDEX = {
  SOUND = 0,
  LIGHT = 1,
  HEAT = 2,
  PRECIPITATION = 3,
  NUTRIENT = 4,
  WATER = 5,
  PROTEIN = 6,            -- Fruit
  CARBOHYDRATE = 7,       -- Seeds
  FAT = 8,                -- Food
  FLOWERS = 9,
  MACHINERY = 10,
  EGGS = 11,
  NORN = 12,
  GRENDEL = 13,
  ETTIN = 14,
  NORN_HOME = 15,
  GRENDEL_HOME = 16,
  ETTIN_HOME = 17,
  GADGET = 18
}

CAOS.FAMILY = {
  INVALID = -1,
  UI = 1,
  OBJECT = 2,
  EXTENDED = 3,
  CREATURE = 4
}

CAOS.UI_GENUS = {
  INVISIBLE = 1,
  SYSTEM = 2,
  FAV_SIGN = 3,
  FAV_ICON = 4
}

CAOS.OBJECT_GENUS = {
  SELF = 0,
  HAND = 1,
  DOOR = 2,
  SEED = 3,
  PLANT = 4,
  WEED = 5,
  LEAF = 6,
  FLOWER = 7,
  FRUIT = 8,
  MANKY = 9,          -- bad fruit
  DETRITUS = 10,      -- waste matter
  FOOD = 11,
  BUTTON = 12,
  BUG = 13,
  PEST = 14,
  CRITTER = 15,
  BEAST = 16,
  NEST = 17,
  ANIMAL_EGG = 18,
  WEATHER = 19,
  BAD = 20,
  TOY = 21,
  INCUBATOR = 22,
  DISPENSER = 23,
  TOOL = 24,
  POTION = 25
}

CAOS.EXTENDED_GENUS = {
  ELEVATOR = 1,
  TELEPORTER = 2,
  MACHINERY = 3,
  CREATURE_EGG = 4,
  NORN_HOME = 5,
  GRENDEL_HOME = 6,
  ETTIN_HOME = 7,
  GADGET = 8,
  PORTAL = 9,
  VEHICLE = 10
}

CAOS.CREATURE_GENUS = {
  NORN = 1,
  GRENDEL = 2,
  ETTIN = 3,
  SOMETHING = 4
}

CAOS.UI_SYSTEM = {
  SPEECH_BUBBLE = 10
}

CAOS.MESSAGE = {
  -- Calls the Activate 1 script. If the message is from a creature, and the permissions set with
  -- BHVR disallow it, then the script is not executed.
  ACTIVATE_1 = 0,
  -- Calls the Activate 2 script. The permissions set with BHVR are checked first.
  ACTIVATE_2 = 1,
  -- Calls the Deactivate script. The permissions set with BHVR are checked first.
  DEACTIVATE = 2,
  -- Calls the Hit script. If the message is from a creature, and the permissions set with BHVR
  -- disallow it, then the message is not sent.
  HIT = 3,
  -- The agent is picked up by the agent that the message was FROM. The permissions set with BHVR
  -- are checked first.
  PICKUP = 4,
  --  If the agent is being carried, then it is dropped.
  DROP = 5,
  -- Calls the Eat script. The permissions set with BHVR are checked first.
  EAT = 12,
  -- Causes a creature to hold hands with the pointer.
  START_HOLD_HANDS = 13,
  -- Causes a creature to stop holding hands with the pointer. Since messages take a tick to be
  -- procesed, calling NOHH is quicker than using this message.
  STOP_HOLD_HANDS = 14
}

CAOS.EVENT = {
  -- Called when the agent receives a deactivate message.
  DEACTIVATE = 0,
  -- Called when the agent receives an activate 1 message. (push)
  ACTIVATE_1 = 1,
  -- Called when the agent receives an activate 2 message. (pull)
  ACTIVATE_2 = 2,
  -- Called when the agent receives a hit message.
  HIT = 3,
  -- Called when the agent has been picked up by something other than a vehicle.
  PICKUP = 4,
  -- Called when the agent has been dropped by something other than a vehicle.
  DROP = 5,
  -- Called when the agent collides with an obstacle. _P1_ and _P2_ are the x and y components of
  -- the collision velocity.
  COLLISION = 6,
  -- Called when a creature walks into a wall.
  BUMP = 7,
  -- The event an object receives when the world starts up
  C2_ENTER_SCOPE = 7,
  -- Called when an agent's presence impacts with another agent's presence (this is assuming both
  -- agents have their presence switched on).
  IMPACT = 8,
  -- Called at a regular time interval, as set by TICK.
  TIMER = 9,
  -- Called on creation.
  CONSTRUCTOR = 10,

  C2_PUSH_LEFT = 10,
  C2_PUSH_RIGHT = 11,
  
  -- Called when the creature eats something.
  EATEN = 12,
  -- Called when a creature starts holding hands with the pointer.
  START_HOLD_HANDS = 13,
  -- Called when a creature stops holding hands with the pointer.
  STOP_HOLD_HANDS = 14,
  
  -- Scripts 16 - 30 are executed on a creature when it decides to do something with its attention
  -- on an ordinary agent (rather than a creature). The script should perform this action.
  -- Quiescent means stand and watch it. The catalogue entry "Action Script To Neuron Mappings"
  -- maps the brain to these scripts, although which scripts require an it object are hard-wired.
  AGENT_QUIESCENT = 16,
  -- Activate 1 it.
  AGENT_ACTIVATE_1 = 17,
  -- Activate 2 it.
  AGENT_ACTIVATE_2 = 18,
  -- Deactivate it.
  AGENT_DEACTIVATE = 19,
  -- Go up and look at it.
  AGENT_APPROACH = 20,
  -- Walk or run away from it.
  AGENT_RETREAT = 21,
  -- Pick it up.
  AGENT_PICKUP = 22,
  -- Drop anything you're carrying.
  AGENT_DROP = 23,
  -- Say what's bothering you.
  AGENT_NEED = 24,
  -- Becoming sleepy.
  AGENT_REST = 25,
  -- Walk idly to west.
  AGENT_WEST = 26,
  -- Walk idly to east.
  AGENT_EAST = 27,
  -- Eat it.
  AGENT_EAT = 28,
  -- Hit it.
  AGENT_HIT = 29,
  -- For future expansion.
  AGENT_UNDEFINED_1 = 30,
  -- For future expansion.
  AGENT_UNDEFINED_2 = 31,

  -- Scripts 32 - 47 are executed on a creature when it decides to do something with its attention
  -- on another creature. Quiescent means stand and twiddle your thumbs.
  CREATURE_QUIESCENT = 32,
  -- Mating script.
  CREATURE_ACTIVATE_1 = 33,
  -- Mating script.
  CREATURE_ACTIVATE_2 = 34,
  -- Deactivate it.
  CREATURE_DEACTIVATE = 35,
  -- Go up and look at it.
  CREATURE_APPROACH = 36,
  -- Walk or run away from it.
  CREATURE_RETREAT = 37,
  -- Pick it up.
  CREATURE_PICKUP = 38,
  -- Drop anything you're carrying.
  CREATURE_DROP = 39,
  -- Say what's bothering you.
  CREATURE_NEED = 40,
  -- Rest or sleep.
  CREATURE_REST = 41,
  -- Walk idly to west.
  CREATURE_WEST = 42,
  -- Walk idly to east.
  CREATURE_EAST = 43,
  -- Eat it.
  CREATURE_EAT = 44,
  -- Hit it.
  CREATURE_HIT = 45,
  -- For future expansion.
  CREATURE_UNDEFINED_1 = 46,
  -- For future expansion.
  CREATURE_UNDEFINED_2 = 47,

  -- POINTER - Left button click causing an Activate 1
  C2_POINTER_ACTIVATE_1 = 50,
  -- POINTER - Left button click causing an Activate 2
  C2_POINTER_ACTIVATE_2 = 51,
  -- POINTER - Left button click causing a Deactivate
  C2_POINTER_DEACTIVATE = 52,
  -- POINTER - Right button click, grab object
  C2_POINTER_PICKUP = 53,
  -- POINTER - Right button click to drop a held object
  C2_POINTER_DROP = 54,
  -- POINTER - Left button click in push pointer mode
  C2_POINTER_PUSH_LEFT = 55,
  -- POINTER - Left button click in push pointer mode
  C2_POINTER_PUSH_RIGHT = 56,

  -- Involuntary action called when the creature flinches.
  FLINCH = 64,
  --  Involuntary action called when the creature lays an egg.
  LAY_EGG = 65,
  -- Involuntary action called when the creature sneezes.
  SNEEZE = 66,
  -- Involuntary action called when the creature coughs.
  COUGH = 67,
  -- Involuntary action called when the creature shivers.
  SHIVER = 68,
  -- Involuntary action called when the creature sleeps.
  SLEEP = 69,
  -- Involuntary action called when the creature faints.
  FAINTING = 70,
  -- Involuntary action for future expansion.
  UNASSIGNED = 71,
  -- Special involuntary action called when a creature dies. Any death animations go here.
  DIE = 72,

  -- Called when a key is pressed and IMSK is set. The key code is sent in _P1_.
  KEY_DOWN = 73,
  -- Called when a key is released and IMSK is set. The key code is sent in _P1_.
  KEY_UP = 74,
  -- Called when the mouse moves and IMSK is set. The new x and y position is sent in _P1_ and _P2_
  MOUSE_MOVED = 75,
  -- Called when a mouse button is pressed and IMSK is set. The button is sent in _P1_ - 1 left,
  -- 2 right, 4 middle.
  MOUSE_DOWN = 76,
  -- Called when a mouse button is released and IMSK is set. The button is sent in _P1_ - 1 left,
  -- 2 right, 4 middle.
  MOUSE_UP = 77,
  -- Called when the mouse wheel is moved and IMSK is set. The delta value is sent in _P1_ - 120
  -- units per 'click'.
  MOUSE_WHEEL = 78,
  -- Called when a translated character is received and IMSK is set. For example, on Japanese
  -- systems the raw key down and up codes can be in Roman characters, but the Input Method Editor
  -- converts them to Japanese characters, which are sent to the game with this message. The
  -- translated key code is sent in _P1_. You can use this for character input, but it is easier
  -- to use PAT: TEXT.
  TRANSLATED_CHAR = 79,
  
  -- Called when the mouse clicks on an agent.
  MOUSE_CLICKED = 92,
  
  -- Called on the pointer when an agent is activated 1. The script has the same classifier as the
  -- agent being activated.
  POINTER_ACTIVATE_1 = 101,
  -- Called on the pointer when an agent is activated 2. The script has the same classifier as the
  -- agent being activated.
  POINTER_ACTIVATE_2 = 102,
  -- Called on the pointer when an agent is deactivated. The script has the same classifier as the
  -- agent being deactivated.
  POINTER_DEACTIVATE = 103,
  -- Called on the pointer when an agent is activated 1. The script has the same classifier as the
  -- agent being activated.
  POINTER_PICKUP = 104,
  -- Called on the pointer when an agent is dropped. The script has the same classifier as the
  -- agent being dropped.
  POINTER_DROP = 105,

  -- Called on the pointer when you manipulate a port.
  POINTER_PORT_SELECT = 110,
  -- Called on the pointer when you complete the connection between two ports.
  POINTER_PORT_CONNECT = 111,
  -- Called on the pointer when you complete the disconnection of two previously connected ports.
  POINTER_PORT_DISCONNECT = 112,
  -- Called on the pointer if you cancel a port change part way through.
  POINTER_PORT_CANCEL = 113,
  -- Called on the pointer if there is some error with the configuration of ports the user is
  -- trying to make.
  POINTER_PORT_ERROR = 114,

  -- Called when the pointer is clicked but there aren't any agents under it.
  POINTER_CLICKED_BACKGROUND = 116,
  -- Called on the pointer to tell it what action clicking would take on the creature under it.
  -- _P1_ says what will happen: 0 means no action or not above a creature, 1 means deactivate
  -- (slap), 2 means activate 1 (tickle).
  POINTER_ACTION_DISPATCH = 117,
  -- Called on an agent when any of its ports are broken as a result of exceeding the maximum
  -- connection distance.
  CONNECTION_BREAK = 118,
  
  -- Called on all agents with this script when the selected creature is changed by NORN. _P1_ is
  -- the new creature, _P2_ is the previously selected creature.
  SELECTED_CREATURE_CHANGED = 120,
  -- Called when an agent has been picked up by a vehicle.
  VEHICLE_PICKUP = 121,
  -- Called when an agent has been dropped by a vehicle.
  VEHICLE_DROP = 122,
  -- Called on all agents with this script whenever the main view is resized.
  WINDOW_RESIZED = 123,
  -- Tells an agent that they have just picked something up.
  GOT_CARRIED_AGENT = 124,
  -- Tells an agent that they have just dropped something.
  LOST_CARRIED_AGENT = 125,
  -- Called when a creature speaks, so scripts can display a speech bubble. Every agent which has
  -- this script is called. _P1_ is the text being spoken, _P2_ is the creature who is speaking.
  MAKE_SPEECH_BUBBLE = 126,
  -- Called whenever there is a new life event, whether an event built into the engine, or a
  -- custom event sent with HIST EVNT. _P1_ is the moniker that the event happened to, _P2_ is the
  -- event number as an index into the events for that moniker.
  LIFE_EVENT = 127,
  -- Called when the world had just been loaded, whether from bootstrap or from a saved file.
  WORLD_LOADED = 128,
  
  -- Connection to the Babel server has been made.
  NET_ONLINE = 135,
  -- Connection to the Babel server is broken.
  NET_OFFLINE = 136,
  -- User chosen with NET: WHON has gone online. _P1_ contains the user's id.
  USER_ONLINE = 137,
  -- User chosen with NET: WHON has gone offline. _P1_ contains the user's id.
  USER_OFFLINE = 138,

  -- Called by the approach command with _P1_ and _P2_ set to the IT object's X and Y coordinates
  -- respectively.
  CREATURE_NAVIGATION_CALLBACK_VALIDATE_IT = 150,
  -- Called by the approach command when you are unable to use the CA because you're outside the
  -- room system.
  CREATURE_NAVIGATION_CALLBACK_OUTSIDE_ROOM_SYSTEM = 151,
  -- Called by the approach command if there is no IT object. _P1_ and _P2_ are set to the X and Y
  -- coordinates of the room's centre with the highest (or lowest if retreating) smell of IT nearby.
  CREATURE_NAVIGATION_CALLBACK_NEIGHBOUR = 152,
  -- As for 152 but called when the best room is a link.
  CREATURE_NAVIGATION_CALLBACK_LINK = 153,
  -- As for 152 but called when the room you're in is already the best one.
  CREATURE_NAVIGATION_CALLBACK_CURRENT_ROOM_BEST = 154,
  
  -- Called when the creature is about to age. _P1_ contains the value of the next age stage.
  CREATURE_AGING_CALLBACK = 160,

  -- Reserved for use in the mating scripts, but not directly used by the engine.
  -- Tells a male to mate.
  MATE = 200,
  
  -- This script specifies the behaviour when an agent tries to do something to an invalid agent.
  -- For example, if you try and access an OVxx with a NULL target. If this script isn't present
  -- for OWNR, you get a run time error. If it is present, that script is called and you can reset
  -- variables as necessary.
  AGENT_EXCEPTION = 255

  -- All events from 256 - 65535 are user defined. This allows objects to employ common methods
  -- across different objects. The events can be triggered using the MESG WRT+ command and/or the
  -- KMSG command.
}

ov00 = "ov00"
ov01 = "ov01"
ov02 = "ov02"
ov03 = "ov03"
ov04 = "ov04"
ov05 = "ov05"
ov06 = "ov06"
ov07 = "ov07"
ov08 = "ov08"
ov09 = "ov09"
ov10 = "ov10"
ov11 = "ov11"
ov12 = "ov12"
ov13 = "ov13"
ov14 = "ov14"
ov15 = "ov15"
ov16 = "ov16"
ov17 = "ov17"
ov18 = "ov18"
ov19 = "ov19"
ov20 = "ov20"
ov21 = "ov21"
ov22 = "ov22"
ov23 = "ov23"
ov24 = "ov24"
ov25 = "ov25"
ov26 = "ov26"
ov27 = "ov27"
ov28 = "ov28"
ov29 = "ov29"
ov30 = "ov30"
ov31 = "ov31"
ov32 = "ov32"
ov33 = "ov33"
ov34 = "ov34"
ov35 = "ov35"
ov36 = "ov36"
ov37 = "ov37"
ov38 = "ov38"
ov39 = "ov39"
ov40 = "ov40"
ov41 = "ov41"
ov42 = "ov42"
ov43 = "ov43"
ov44 = "ov44"
ov45 = "ov45"
ov46 = "ov46"
ov47 = "ov47"
ov48 = "ov48"
ov49 = "ov49"
ov50 = "ov50"
ov51 = "ov51"
ov52 = "ov52"
ov53 = "ov53"
ov54 = "ov54"
ov55 = "ov55"
ov56 = "ov56"
ov57 = "ov57"
ov58 = "ov58"
ov59 = "ov59"
ov60 = "ov60"
ov61 = "ov61"
ov62 = "ov62"
ov63 = "ov63"
ov64 = "ov64"
ov65 = "ov65"
ov66 = "ov66"
ov67 = "ov67"
ov68 = "ov68"
ov69 = "ov69"
ov70 = "ov70"
ov71 = "ov71"
ov72 = "ov72"
ov73 = "ov73"
ov74 = "ov74"
ov75 = "ov75"
ov76 = "ov76"
ov77 = "ov77"
ov78 = "ov78"
ov79 = "ov79"
ov80 = "ov80"
ov81 = "ov81"
ov82 = "ov82"
ov83 = "ov83"
ov84 = "ov84"
ov85 = "ov85"
ov86 = "ov86"
ov87 = "ov87"
ov88 = "ov88"
ov89 = "ov89"
ov90 = "ov90"
ov91 = "ov91"
ov92 = "ov92"
ov93 = "ov93"
ov94 = "ov94"
ov95 = "ov95"
ov96 = "ov96"
ov97 = "ov97"
ov98 = "ov98"
ov99 = "ov99"

mv00 = "mv00"
mv01 = "mv01"
mv02 = "mv02"
mv03 = "mv03"
mv04 = "mv04"
mv05 = "mv05"
mv06 = "mv06"
mv07 = "mv07"
mv08 = "mv08"
mv09 = "mv09"
mv10 = "mv10"
mv11 = "mv11"
mv12 = "mv12"
mv13 = "mv13"
mv14 = "mv14"
mv15 = "mv15"
mv16 = "mv16"
mv17 = "mv17"
mv18 = "mv18"
mv19 = "mv19"
mv20 = "mv20"
mv21 = "mv21"
mv22 = "mv22"
mv23 = "mv23"
mv24 = "mv24"
mv25 = "mv25"
mv26 = "mv26"
mv27 = "mv27"
mv28 = "mv28"
mv29 = "mv29"
mv30 = "mv30"
mv31 = "mv31"
mv32 = "mv32"
mv33 = "mv33"
mv34 = "mv34"
mv35 = "mv35"
mv36 = "mv36"
mv37 = "mv37"
mv38 = "mv38"
mv39 = "mv39"
mv40 = "mv40"
mv41 = "mv41"
mv42 = "mv42"
mv43 = "mv43"
mv44 = "mv44"
mv45 = "mv45"
mv46 = "mv46"
mv47 = "mv47"
mv48 = "mv48"
mv49 = "mv49"
mv50 = "mv50"
mv51 = "mv51"
mv52 = "mv52"
mv53 = "mv53"
mv54 = "mv54"
mv55 = "mv55"
mv56 = "mv56"
mv57 = "mv57"
mv58 = "mv58"
mv59 = "mv59"
mv60 = "mv60"
mv61 = "mv61"
mv62 = "mv62"
mv63 = "mv63"
mv64 = "mv64"
mv65 = "mv65"
mv66 = "mv66"
mv67 = "mv67"
mv68 = "mv68"
mv69 = "mv69"
mv70 = "mv70"
mv71 = "mv71"
mv72 = "mv72"
mv73 = "mv73"
mv74 = "mv74"
mv75 = "mv75"
mv76 = "mv76"
mv77 = "mv77"
mv78 = "mv78"
mv79 = "mv79"
mv80 = "mv80"
mv81 = "mv81"
mv82 = "mv82"
mv83 = "mv83"
mv84 = "mv84"
mv85 = "mv85"
mv86 = "mv86"
mv87 = "mv87"
mv88 = "mv88"
mv89 = "mv89"
mv90 = "mv90"
mv91 = "mv91"
mv92 = "mv92"
mv93 = "mv93"
mv94 = "mv94"
mv95 = "mv95"
mv96 = "mv96"
mv97 = "mv97"
mv98 = "mv98"
mv99 = "mv99"

va00 = "va00"
va01 = "va01"
va02 = "va02"
va03 = "va03"
va04 = "va04"
va05 = "va05"
va06 = "va06"
va07 = "va07"
va08 = "va08"
va09 = "va09"
va10 = "va10"
va11 = "va11"
va12 = "va12"
va13 = "va13"
va14 = "va14"
va15 = "va15"
va16 = "va16"
va17 = "va17"
va18 = "va18"
va19 = "va19"
va20 = "va20"
va21 = "va21"
va22 = "va22"
va23 = "va23"
va24 = "va24"
va25 = "va25"
va26 = "va26"
va27 = "va27"
va28 = "va28"
va29 = "va29"
va30 = "va30"
va31 = "va31"
va32 = "va32"
va33 = "va33"
va34 = "va34"
va35 = "va35"
va36 = "va36"
va37 = "va37"
va38 = "va38"
va39 = "va39"
va40 = "va40"
va41 = "va41"
va42 = "va42"
va43 = "va43"
va44 = "va44"
va45 = "va45"
va46 = "va46"
va47 = "va47"
va48 = "va48"
va49 = "va49"
va50 = "va50"
va51 = "va51"
va52 = "va52"
va53 = "va53"
va54 = "va54"
va55 = "va55"
va56 = "va56"
va57 = "va57"
va58 = "va58"
va59 = "va59"
va60 = "va60"
va61 = "va61"
va62 = "va62"
va63 = "va63"
va64 = "va64"
va65 = "va65"
va66 = "va66"
va67 = "va67"
va68 = "va68"
va69 = "va69"
va70 = "va70"
va71 = "va71"
va72 = "va72"
va73 = "va73"
va74 = "va74"
va75 = "va75"
va76 = "va76"
va77 = "va77"
va78 = "va78"
va79 = "va79"
va80 = "va80"
va81 = "va81"
va82 = "va82"
va83 = "va83"
va84 = "va84"
va85 = "va85"
va86 = "va86"
va87 = "va87"
va88 = "va88"
va89 = "va89"
va90 = "va90"
va91 = "va91"
va92 = "va92"
va93 = "va93"
va94 = "va94"
va95 = "va95"
va96 = "va96"
va97 = "va97"
va98 = "va98"
va99 = "va99"
