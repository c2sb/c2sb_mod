--* Script 1 extracted from Botanoid/Botanoid.agents by Mirality REVELATION

function Botanoid.install()
  inst()
  reps(3, function()
    new: simp (3, 8, 4608, "ASmechaseed", 11, 0, rand (500, 3000))
    attr (199)
    bhvr (41)
    accg (0)
    elas (0)
    aero (20)
    emit (10, 0.1)
    rnge (30)
    fric (100)
  --*ov00 is the 'fail' meter :P After 3 landings or so, the 'seed' will crash and perish.
    setv(ov00, 0)
    if tmvt (3670, 3340) == 1 then
      mvto (3670, 3340)
    end
    if tmvt (2435, 9053) == 1 then
      mvto (2435, 9053)
    end
    anim [[0 1 2 3 4 5 6 7 8 9 10 255]]
    velo (rand(20, -20), rand(5, -5))
    tick (1)
  end)
end

scrp(3, 8, 4608, 1, function()
  --setv(vely, -10)
  velo(velx, -10)
  stim_writ (from, 90, 1)
end)

scrp(3, 8, 4608, 3, function()
  --setv(vely, -10)
  velo(velx, -10)
  snde "spnk"
  addv(ov00, 4)
  stim_writ (from, 92, 1)
end)

scrp(3, 8, 4608, 4, function()
  stim_writ (from, 91, 1)
end)

scrp(3, 8, 4608, 9, function()

  local function relaunch()
--**launches the seed back into the skies
    addv(ov00, 1)
    accg (0)
    velo (rand(15, -15), rand(-20, -40))
    wait (20)
  end

  local function grow()
--**if we got up to here, this means it's safe to grow! then
    setv(va00, posx)
    setv(va01, posb)
    new: simp (3, 3, 4608, "ASmechaplant", 37, 0, rand(500, 3000))
    attr (4)
    rnge (400)
--*ov00 is growth stage: 0== constructing 1== Opening 2== Opened 3== Flowered 4== Seeding and Dieing
    setv(ov00, 0)
    setv(va03, wdth)
    divv(va03, 2)
    subv(va00, va03)
    setv(va02, hght)
    subv(va02, 3)
    subv(va01, va02)
    mvto (va00, va01)
    tick (1)
    kill(ownr)
  end

  local function pop()
--**checks if population is okay then
    ttar (3, 3, 4608)
    if targ() ~= null then
      targ (ownr)
      gsub(relaunch)
    else
      if totl (3, 3, 4608) > 30 then
        targ (ownr)
        addv(ov00, 3)
        gsub(relaunch)
      else
        targ (ownr)
        gsub(grow)
      end
    end
  end

  local function crash()
--*Crash and burn baby! Yeah!
--*Anyways, just drop to the floor and disappear
    anim [[0]]
    accg (1)
    repeat
      wait (1)
    until fall() ~= 1
    kill(ownr)
  end
  
  local function check()
--*checks if the roomtype is correct. then
-- TODO: implement rtyp
    pop()
    --if rtyp (room (ownr)) < 5 or rtyp (room (ownr)) > 9 then
    --  pop()
    --else
    --  relaunch()
    --end
  end

  tick (1)
-- TODO: implement rtyp
  if ov00 > 3 then --or rtyp (room (ownr)) == 8 or rtyp (room (ownr)) == 9 then
    crash()
  end
  velo (rand(10, -10), rand(5, -3))
  if obst (down) < 15 and carr() == null then
    accg (0.5)
    wait (100)
    if fall() ~= 1 then
      check()
    end
  else
    wait (10)
  end

end)

scrp(3, 3, 4608, 9, function()
  local function construct()
    repeat
      wait (rand(500, 250))
      setv (va00, pose)
      addv(va00, 1)
      pose (va00)
    until pose() == 5
    wait (rand(500, 250))
    setv(ov00, 1)
  end

  local function extend()
    lock()
    anim [[5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23]]
    over()
    setv(ov00, 2)
    unlk()
  end

  local function die_()
    anim [[23]]
    repeat
      wait (10)
      setv (va00, pose)
      subv(va00, 1)
      pose (va00)
    until pose() == 0
    wait (10)
    kill(ownr)
  end

  local function seed()
    if ov01() ~= null then
      kill (ov01)
    end
    lock()
    if totl (3, 3, 4608) > 30 then
      setv(va10, 1)
    else
      setv(va10, 3)
    end
    reps(va10, function()
      setv(va00, posx)
      setv(va01, post)
      new: simp (3, 8, 4608, "ASmechaseed", 11, 0, rand(500, 3000))
      attr (199)
      bhvr (41)
      accg (0)
      elas (0)
      aero (20)
      emit (10, 0.1)
      rnge (30)
      fric (100)
--*ov00 is the 'fail' meter :P After 3 landings or so, the 'seed' will crash and perish.
      setv(ov00, 0)
      subv(va01, hght)
      setv(va03, wdth)
      divv(va03, 2)
      subv(va00, va03)
      subv(va03, 4)
      if tmvt (va00, va01) == 1 then
        mvto (va00, va01)
        anim [[0 1 2 3 4 5 6 7 8 9 10 255]]
        velo (rand(5, -5), -15)
        tick (20)
      else
        kill(targ)
      end
      targ (ownr)
    end)
    unlk()
    die_()
  end

  local function waste()
--**Now we'll expell our waste products in the form of foods! Yummy!
--**Make 2 of each
    lock()
    if totl (2, 3, 4608) > 10 or totl (2, 11, 4608) > 10 or totl (2, 8, 4608) > 10 then
      setv(va10, 1)
    else
      setv(va10, 2)
    end
    reps(va10, function()
      setv(va00, posx)
      subv(va00, 6)
      setv(va01, post)
      new: simp (2, 3, 4608, "ASmechafood", 1, 0, rand(500, 2000))
      attr (195)
      accg (2)
      bhvr (48)
      elas (30)
      fric (90)
      emit (7, 0.1)
      tint (rand(170, 240), rand(90, 120), rand(170, 240), 128, 128)
      if tmvt (va00, va01) == 1 then
        mvto (va00, va01)
        velo (rand(10, -10), -5)
        tick (rand(500, 2000))
      else
        kill(targ)
      end
      targ (ownr)
      setv(va00, posx)
      setv(va01, post)
      new: simp (2, 8, 4608, "ASmechafood", 1, 0, rand(500, 2000))
      attr (195)
      accg (2)
      bhvr (48)
      elas (30)
      fric (90)
      emit (6, 0.1)
      tint (rand(170, 240), rand(90, 120), rand(170, 240), 128, 128)
      if tmvt (va00, va01) == 1 then
        mvto (va00, va01)
        velo (rand(10, -10), -5)
        tick (rand(500, 2000))
      else
        kill(targ)
      end
      targ (ownr)
      setv(va00, posx)
      setv(va01, post)
      new: simp (2, 11, 4608, "ASmechafood", 1, 0, rand(500, 2000))
      attr (195)
      accg (2)
      bhvr (48)
      elas (30)
      fric (90)
      emit (8, 0.1)
      tint (rand(170, 240), rand(90, 120), rand(170, 240), 128, 128)
      if tmvt (va00, va01) == 1 then
        mvto (va00, va01)
        velo (rand(5, -5), -15)
        tick (rand(500, 2000))
      else
        kill(targ)
      end
      targ (ownr)
    end)
    unlk()
    wait (rand(250, 500))
    setv(ov00, 3)
  end

  local function flower()
    lock()
    anim [[23 24 25 26 27 28 29 30 31 32 33 34 35 36 255]]
    setv (va05, plne)
    seta (va06, ownr)
    setv(va00, posx)
    setv(va01, post)
    new: simp (2, 7, 4608, "ASmechaflower", 17, 0, va05)
    seta (ov00, va06)
    seta (mv01, targ)
    setv(va03, wdth)
    divv(va03, 2)
    subv(va00, va03)
    addv(va00, 4)
    subv(va01, hght)
    mvto (va00, va01)
    setv(ov01, va01)
    subv(va01, 10)
    setv(ov02, va01)
    anim [[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 255]]
    --setv(vely, -1)
    velo(velx, -1)
    tick (1)
    targ (ownr)
    unlk()
    wait (rand(500, 1000))
    setv(ov00, 4)
  end

--**dun dun dun, the plant script
  if ov00() == 0 then
--**we are in construction phase!
    construct()
  end
  if ov00() == 1 then
--**Time to extend our Whateveritis
    extend()
  end
  if ov00() == 2 then
--**Expell foods!
    waste()
  end
  if ov00() == 3 then
--**make a holographic flower!
    flower()
  end
  if ov00() == 4 then
--**Time to spread seeds!
    seed()
  end

end)

scrp(2, 7, 4608, 9, function()
  if ov00() == null then
    kill(ownr)
  end
  if posy < ov02 then
    --setv(vely, 1)
    velo(velx, 1)
  elseif posy > ov01 then
    --setv(vely, -1)
    velo(velx, -1)
  end
end)

scrp(2, 7, 4608, 255, function()
  kill(ownr)
end)

scrp(2, 3, 4608, 12, function()
  snde "chwp"
  stim_writ (from, 77, 1)
  kill(ownr)
end)

scrp(2, 11, 4608, 12, function()
  snde "chwp"
  stim_writ (from, 78, 1)
  kill(ownr)
end)

scrp(2, 8, 4608, 12, function()
  snde "chwp"
  stim_writ (from, 79, 1)
  kill(ownr)
end)

scrp(2, 3, 4608, 9, function()
  kill(ownr)
end)

scrp(2, 11, 4608, 9, function()
  kill(ownr)
end)

scrp(2, 8, 4608, 9, function()
  kill(ownr)
end)

rscr(function()
  enum(3, 8, 4608, function()
    kill(targ)
  end)
  scrx(3, 8, 4608, 9)
  scrx(3, 8, 4608, 1)
  scrx(3, 8, 4608, 8)
  enum(3, 3, 4608, function()
    kill(targ)
  end)
  scrx(3, 3, 4608, 9)
  scrx(3, 3, 4608, 1)
  enum(2, 8, 4608, function()
    kill(targ)
  end)
  enum(2, 11, 4608, function()
    kill(targ)
  end)
  enum(2, 3, 4608, function()
    kill(targ)
  end)
end)
