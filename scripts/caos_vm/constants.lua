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

CAOS.ROOMTYPE = {
  -- Heat and light travel well, nutrients and water do not.
  ATMOSPHERE = 0,
  -- Insulates against heat, but permits water to drip through.
  WOODEN_WALKWAY = 1,
  --  Less permeable to more CA than a wooden walkway.
  CONCRETE_WALKWAY = 2,
  INDOOR_CONCRETE = 3,
  OUTDOOR_CONCRETE = 4,
  -- Fairly permeable to most CA.
  NORMAL_SOIL = 5,
  -- Retains more moisture than normal soil.
  BOGGY_SOIL = 6,
  -- Loses more moisture than normal soil.
  DRAINED_SOIL = 7,
  -- Restrictive to heat.
  FRESH_WATER = 8,
  -- Restrictive to heat.
  SALT_WATER = 9,
  -- Loses the smell of machinery.
  ETTIN_HOME = 10
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

CAOS.SOUND_CHANNEL = {
  EFFECT = 0,
  MIDI = 1,
  GENERATED_MUSIC = 2
}

CAOS.CHEM = {
  -- An unknown chemical that takes no part in Norn biochemistry.
  UNKNOWNASE = 0,
  -- Produced when Norn is suffocating or drowning, and sugars cannot be combusted into carbon
  -- dioxide. Causes slight injury to the muscle organ
  LACTATE = 1,
  -- Late stage digestion product. Part of energy production metabolism
  PYRUVATE = 2,
  -- All food is broken down into glucose eventually to make energy
  GLUCOSE = 3,
  -- Starch storage chemical.
  GLYCOGEN = 4,
  -- Food source, found mainly in seeds, but also in small amounts in fruit
  STARCH = 5,
  -- A stage in the breakdown of fat
  FATTY_ACID = 6,
  -- Bi-product of the breakdown of fat
  CHOLESTEROL = 7,
  -- A stage in the breakdown of fat
  TRIGLYCERIDE = 8,
  -- Long term fat storage chemical
  ADIPOSE_TISSUE = 9,
  -- Food source found in food and to a lesser extent, in fruit
  FAT = 10,
  -- Long term protein storage chemical
  MUSCLE_TISSUE = 11,
  -- Food source, found in fruit and food
  PROTEIN = 12,
  -- Protein is broken down into amino acid when digested
  ANIMO_ACID = 13,
  -- Produced when a Norn goes downhill, and makes it adopt a 'going downhill' gait
  DOWNATROPHIN = 17,
  -- Produced when a Norn goes uphill, and makes it adopt a 'going uphill' gait
  UPATROPHIN = 18,
  -- Bi-product of digestion. Removed from the body by the lungs
  DISSOLVED_CARBON_DIOXIDE = 24,
  -- Waste product from protein digestion. Controls urination (yes, Norns do...)
  UREA = 25,
  -- Waste product from protein digestion, and a mild poison. Is turned into the safer chemical,
  -- Urea, for excretion.
  AMMONIA = 26,
  -- Indicates the presence of breathable air, with water produces oxygen.
  AIR = 29,
  -- Used to break down glucose and make energy.
  OXYGEN = 30,
  -- Bi-product of the Norn's metabolism, and also used as a coolant
  WATER = 33,
  -- One of the final products of glucose breakdown
  ENERGY = 34,
  -- Ultimate energy source for all functions in the Norn's body
  ATP = 35,
  -- Energy depleted form of ATP
  ADP = 36,
  -- Produced when the Norn is fertile, and ready to mate. Needs a creature of the right species
  -- and sex to become sex drive
  AROUSAL_POTENTIAL = 39,
  -- Lowers the sex drive when the Norn is not ready to mate for any reason
  LIBIDO_LOWERER = 40,
  -- This Is produced when a creature senses another creature of the correct Species and sex, the
  -- presence of this chemical triggers the convert of arousal potential into sex drive.
  OPPOSITE_SEX = 41,
  -- American spelling: Estrogen. Controls fertility in females
  OESTROGEN = 46,
  -- Produced during pregnancy. Eggs are laid when it is as its peak, and it prevents the Norn
  -- becoming pregnant again when it already is!
  PROGESTERONE = 48,
  -- Controls fertility in males.
  TESTOSTERONE = 53,
  -- Theoretically controls production of testosterone, but not actually used in C3
  INHIBIN = 54,
  -- A poison: slowly eats away the immune system. It also can cause mutations in unborn children.
  HEAVY_METALS = 66,
  -- A severe poison: slows down the creation of ATP
  CYANIDE = 67,
  -- Slows down the rate of the organ that controls energy status in the Norn. It also upsets
  -- regulatory functions, such as maintenance of hunger, etc.
  BELLADONNA = 68,
  -- Injected by biting insects, slowly destroys fat reserves (adipose tissue).
  GEDDONASE = 69,
  -- Quickly destroys the main glucose reserve (glycogen).
  GLYCOTOXIN = 70,
  -- Causes sleepiness, in case you couldn't guess. A side effect of some infections
  SLEEP_TOXIN = 71,
  -- Causes a high temperature and shivering. A side effect of some infections
  FEVER_TOXIN = 72,
  -- Causes sneezing. A side effect of some infections
  HISTAMINE_A = 73,
  -- Causes coughing. A side effect of some infections
  HISTAMINE_B = 74,
  -- Intoxicant. Causes a drunken walk, plus other well known side effects
  ALCOHOL = 75,
  -- Extreme poison. The nastiest of the lot. Turns ATP back into ADP. Wave goodbye to your Norn!
  ATP_DECOUPLER = 78,
  -- Makes it difficult for the Norn to get enough oxygen
  CARBON_MONOXIDE = 79,
  -- Causes an irrational feeling of terror
  FEAR_TOXIN = 80,
  -- Poison: slowly destroys muscle tissue
  MUSCLE_TOXIN = 81,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_0 = 82,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_1 = 83,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_2 = 84,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_3 = 85,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_4 = 86,
  -- Disease causing chemical in bacterial infections. This antigen is by far the nastiest, and can
  -- cause death
  ANTIGEN_5 = 87,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_6 = 88,
  -- Disease causing chemical in bacterial infections. Damages organs
  ANTIGEN_7 = 89,
  -- A measure of how battered and beat up your Norn is. If the levels of this chemical get very
  -- high, the Norn dies.
  WOUNDED = 90,
  -- Cure for ATP decoupler poisoning. However, you'll be lucky if you get it to work fast enough!
  MEDICINE_ONE = 92,
  -- Cure for Carbon Monoxide poisoning
  ANTI_OXIDANT = 93,
  -- Assists in the healing process after any injuring illness
  PROSTAGLANDIN = 94,
  -- Cure for heavy metal poisoning
  EDTA = 95,
  -- Cure for Cyanide poisoning
  SODIUM_THIOSULPHATE = 96,
  -- A herbal extract said to help glycotoxin poisoning
  ARNICA = 97,
  -- Keeps the reproductive organs healthy
  VITAMIN_E = 98,
  -- Keeps Norn bones healthy, and promotes good healing after injury
  VITAMIN_C = 99,
  -- Clears up coughs and sneezes caused by the two histamines
  ANTIHISTAMINE = 100,
  -- Cures infection by antigen 0 bacteria
  ANTIBODY_0 = 102,
  -- Cures infection by antigen 1 bacteria
  ANTIBODY_1 = 103,
  -- Cures infection by antigen 2 bacteria
  ANTIBODY_2 = 104,
  -- Cures infection by antigen 3 bacteria
  ANTIBODY_3 = 105,
  -- Cures infection by antigen 4 bacteria
  ANTIBODY_4 = 106,
  -- Cures infection by antigen 5 bacteria
  ANTIBODY_5 = 107,
  -- Cures infection by antigen 6 bacteria
  ANTIBODY_6 = 108,
  -- Cures infection by antigen 7 bacteria
  ANTIBODY_7 = 109,
  -- Causes build up of muscle tissue. Do not use if your Norn is taking part in the Olympics.
  -- It'll get disqualified
  ANABOLIC_STEROID = 112,
  -- Large amounts trigger urination
  PISTLE = 113,
  -- In theory, regulates storage of glucose as glycogen. In practice, not used
  INSULIN = 114,
  -- In theory, regulates breakdown of glycogen into glucose. In practice, not used
  GLYCOLASE = 115,
  -- Produced when the creature is under stress,liberating glucose for energy. It also controls
  -- fight or flight responses to attack
  ADRENALIN = 116,
  -- Found in grendels only. Used by the friend or foe lobe to help make decisions about the
  -- friendliness of other creatures
  GRENDEL_NITRATE = 117,
  -- Found in ettins only. Used by the friend or foe lobe to help make decisions about the
  -- friendliness of other creatures
  ETTIN_NITRATE = 118,
  -- In theory, is a measure of muscle activity. In practice, not used.
  ACTIVASE = 124,
  -- Life decays slowly over a Norn's life, working as a biological clock. Injecting your Norn with
  -- this chemical now and again can make it immortal!
  LIFE = 125,
  -- Internal signal to the Norn that is has been wounded. Stimulates production of healing
  -- chemicals (prostaglandin)
  INJURY = 127,
  -- Produced when any drive in the Norn is high for a long time, and damaging to the Norn's long
  -- term health
  STRESS = 128,
  -- Controls sleeping in Norns when tired
  SLEEPASE = 129,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  PAIN_BACKUP = 131,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  HUNGER_FOR_PROTEIN_BACKUP = 132,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  HUNGER_FOR_CARB_BACKUP = 133,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  HUNGER_FOR_FAT_BACKUP = 134,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  COLDNESS_BACKUP = 135,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  HOTNESS_BACKUP = 136,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  TIREDNESS_BACKUP = 137,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  SLEEPINESS_BACKUP = 138,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  LONELINESS_BACKUP = 139,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  CROWDED_BACKUP = 140,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  FEAR_BACKUP = 141,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  BOREDOM_BACKUP = 142,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  ANGER_BACKUP = 143,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  SEX_DRIVE_BACKUP = 144,
  -- The relevant drive chemical is converted to this storage form when another more important need
  -- takes over, such as fear or pain. It is converted back again when the crisis is over
  COMFORT_BACKUP = 145,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  PAIN = 148,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  HUNGER_FOR_PROTEIN = 149,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it. Carbohydrate is another name for starch
  HUNGER_FOR_CARBOHYDRATE = 150,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  HUNGER_FOR_FAT = 151,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  COLDNESS = 152,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  HOTNESS = 153,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  TIREDNESS = 154,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  SLEEPINESS = 155,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  LONELINESS = 156,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  CROWDED = 157,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  FEAR = 158,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  BOREDOM = 159,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  ANGER = 160,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  SEX_DRIVE = 161,
  -- A drive chemical- works like the Norn's emotions. When a Norn has a high level of a drive
  -- chemical, it has to learn a way to reduce it
  COMFORT = 162,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the sound levels in the Norn's
  -- vicinity
  CA_SOUND = 165,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the light levels in the Norn's
  -- vicinity
  CA_LIGHT = 166,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the heat levels in the Norn's
  -- vicinity
  CA_HEAT = 167,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the rain levels in the Norn's
  -- vicinity
  CA_WATER = 168,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the nutrient levels in the Norn's
  -- vicinity
  CA_NUTRIENT = 169,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the bodies of standing water in
  -- the Norn's vicinity
  CA_WATER = 170,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the protein smells in the Norn's
  -- vicinity
  CA_PROTEIN = 171,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the starch smells in the Norn's
  -- vicinity
  CA_CARBOYDRATE = 172,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the fat smells (ugh!) in the
  -- Norn's vicinity
  CA_FAT = 173,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the flower scent in the Norn's
  -- vicinity
  CA_FLOWERS = 174,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the smell of machinery in the
  -- Norn's vicinity
  CA_MACHINERY = 175,
  -- Spare smell chemical
  CA_SMELL_11 = 176,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the Norn smells in the Norn's
  -- vicinity
  CA_NORN_SMELL = 177,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the grendel smells in the Norn's
  -- vicinity
  CA_GRENDEL_SMELL = 178,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the ettin smells in the Norn's
  -- vicinity
  CA_ETTIN_SMELL = 179,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the smell of the Norn terrarium
  CA_NORN_HOME_SMELL = 180,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the smell of the grendel jungle
  CA_GRENDEL_HOME_SMELL = 181,
  -- All environmental stimuli on the Shee ship exist as particle gradients as if they were smells,
  -- which the creatures use to navigate. This chemical represents the smell of the ettin desert
  CA_ETTIN_HOME_SMELL = 182,
  -- Spare smell chemical
  CA_SMELL_18 = 183,
  -- Spare smell chemical
  CA_SMELL_19 = 184,
  -- This chemical represents stress caused specifically by great hunger for carbohydrate.
  STRESS_HIGH_H4C = 187,
  -- This chemical represents stress caused specifically by great hunger for protein.
  STRESS_HIGH_H4P = 188,
  -- This chemical represents stress caused specifically by great hunger for fat.
  STRESS_HIGH_H4F = 189,
  -- This chemical represents stress caused specifically by great anger.
  STRESS_HIGH_ANGER = 190,
  -- This chemical represents stress caused specifically by great fear.
  STRESS_HIGH_FEAR = 191,
  -- This chemical represents stress caused specifically by great pain.
  STRESS_HIGH_PAIN = 192,
  -- This chemical represents stress caused specifically by great tiredness.
  STRESS_HIGH_TIRED = 193,
  -- This chemical represents stress caused specifically by great sleepiness.
  STRESS_HIGH_SLEEP = 194,
  -- This chemical represents stress caused specifically by great crowdedness.
  STRESS_HIGH_CROWDED = 195,
  -- One of the chemicals used for learning, this chemical represents a situation where the Norn
  -- tried something that didn't work (such as eating doors)
  DISAPPOINTMENT = 198,
  -- Used for navigation by the Norn
  UP = 199,
  -- Used for navigation by the Norn
  DOWN = 200,
  -- Used for navigation by the Norn
  EXIT = 201,
  -- Used for navigation by the Norn
  ENTER = 202,
  -- Used for navigation by the Norn
  WAIT = 203,
  -- This chemical takes part in the formation of positive memories. The Norn remembers the action
  -- that made the reward chemical as a good one for future reference
  REWARD = 204,
  -- This chemical takes part in the formation of negative memories. The Norn remembers the action
  -- that made the punishment chemical as a bad one for future reference
  PUNISHMENT = 205,
  -- Spare chemical, not currently in use
  BRAIN_CHEMICAL_9 = 206,
  -- Spare chemical, not currently in use
  BRAIN_CHEMICAL_10 = 207,
  -- Spare chemical, not currently in use
  BRAIN_CHEMICAL_11 = 208,
  -- Spare chemical, not currently in use
  BRAIN_CHEMICAL_12 = 209,
  -- Spare chemical, not currently in use
  BRAIN_CHEMICAL_13 = 210,
  -- Spare chemical, not currently in use
  BRAIN_CHEMICAL_14 = 211,
  -- Controls dreaming in Norns. Norns need to dream in order to process their instincts.
  PRE_REM = 212,
  -- Controls dreaming in Norns.
  REM = 213
}
