--* Script 1 extracted from roamer/roamer.agents by Mirality REVELATION

--* CREATE
function Roamer.install()
  inst()
  new: simp (3, 8, 32201, "roamer", 9, 0, 1000)
  attr(194)
  perm(60)
  bhvr(11)
  accg(5)
  elas(0)
  fric(90)
  setv (ov01, 0)
  setv (ov02, 0)
  setv (ov03, 0)
  setv (ov04, 0)
  setv (ov05, 0)
  setv (ov06, 0)
  setv (ov07, 0)
  setv (ov08, 0)
  --* Get creator positioning
  setv (va00, game ("CreatorX"))
  setv (va01, game ("CreatorY"))
  --* If no values then assume this is C3 only
  if va00() == 0 and va01() == 0 then
    --* Move it to a safe C3 location (just above the incubator area)
    setv (va00, rand (1400, 1550))
    setv (va01, 400)
    end
  mvsf (va00, va01)
  tick (1)
end
--* OVs
--* ov01 - direction of travel (velocity)
--* ov02 - direction tick counter
--* ov03 - wall detection tick counter
--* ov04 - last X position - used for wall detection
--* ov05 - teleport tick counter
--* ov06 - cloud creation tick counter
--* ov07 - cloud being created
--* ov08 - number of clouds created

--* ACTIVATE 1
scrp(3, 8, 32201, 1, function()
  inst()
  setv (va01, rand (1, 3))
  if va01() == 1 then
    snde "1bep"
  elseif va01() == 2 then
    snde "2bep"
  else
    snde "3bep"
  end
  stim_writ (from, 90, 1)
  fric (90)
  setv (ov01, 0)
  anim {}
  pose (0)
  velo (rand (-10, 10), rand (-10, -20))
  slow()
  wait (10)
end)

--* ACTIVATE 2
scrp(3, 8, 32201, 2, function()
  inst()
  setv (va01, rand (1, 3))
  if va01() == 1 then
    snde "1bep"
  elseif va01() == 2 then
    snde "2bep"
  else
    snde "3bep"
  end
  stim_writ (from, 90, 1)
  fric (90)
  setv (ov01, 0)
  anim {}
  pose (0)
  velo (rand (-10, 10), rand (-10, -20))
  slow()
  wait (10)
end)

--* HIT
scrp(3, 8, 32201, 3, function()
  inst()
  snde "hit_"
  stim_writ (from, 92, 1)
  fric (90)
  setv (ov01, 0)
  anim {}
  pose (0)
  velo (rand (-30, 30), rand (-10, -30))
  slow()
  wait (10)
end)

--* PICK UP
scrp(3, 8, 32201, 4, function()
  tick (0)
  stim_writ (from, 91, 1)
  fric (90)
  velo (0, 0)
  anim {}
  pose (0)
  setv (ov01, 0)
  setv (ov02, 0)
  setv (ov03, 0)
  setv (ov04, 0)
  setv (ov05, 0)
  setv (ov06, 0)
  setv (ov07, 0)
  setv (ov08, 0)
end)

--* DROP
scrp(3, 8, 32201, 5, function()
  tick (1)
  --* Re-apply accelleration after teleport
  accg (5)
end)

--* TIMER
scrp(3, 8, 32201, 9, function()
  --* Increment tick counters
  addv (ov02, 1)
  addv (ov03, 1)
  addv (ov05, 1)
  addv (ov06, 1)

  --* Check for nearby bacteria
  inst()
  setv (va50, 0)
  rnge (300)
  esee (2, 32, 23, function()
    addv (va50, 1)
  end)
  slow()

  --* Check for nearby creatures
  inst()
  setv (va51, 0)
  rnge (200)
  esee (4, 0, 0, function()
    addv (va51, 1)
  end)
  slow()

--*  if ov06 >= 50 and rand 0 30 == 0

  --* Release bacteria clouds?
  if ov06 >= 50 and rand (0, 15) == 0 and va50() ~= 0 then --and rtyp (grap (posx(), posy())) ~= 8 and rtyp (grap (posx(), posy())) ~= 9 then
    setv (ov07, 32215)
    setv (ov08, 0)
    setv (ov06, 0)
    --* Prevent creature clouds being released as well
    setv (va51, 0)
  end

  --* Release creature clouds?
  if ov06 >= 50 and rand (0, 15) == 0 and va51() ~= 0 then --and rtyp (grap (posx(), posy())) ~= 8 and rtyp (grap (posx(), posy())) ~= 9 then
    --* Pick random type
    setv (ov07, rand (32213, 32214))
    setv (ov08, 0)
    setv (ov06, 0)
  end

  --* Release a cloud
  if ov07() ~= 0 then
    if ov07() == 32213 then
      setv (va01, 0)
    elseif ov07() == 32214 then
      setv (va01, 15)
    else
      setv (va01, 30)
    end
    setv (va02, posl)
    setv (va03, post)
    if tmvt (va02, va03) == 1 then
      snde "spry"
      inst()
      new: simp (1, 1, ov07, "smoke", 15, va01, 990)
      attr (64)
      alph (120, 1)
      mvsf (va02, va03)
      --* Set random direction, but make sure isn't standing still
      repeat
        velo (rand (-1, 1), rand (-1, 1))
      until velx() ~= 0 and vely() ~= 0
      setv (ov00, 0)
      tick (10)
      slow()
    end
    targ (ownr)
    addv (ov08, 1)
    --* Stop when 8 created
    if ov08 >= 8 then
      setv (ov07, 0)
    end
  end

  --* Change direction/stop?
  if ov02 >= 10 then
    setv (va01, rand (0, 2))
    if va01() == 0 then
      setv (ov01, 0)
      fric (90)
      velo (0, 0)
      anim {}
      pose (0)
    --* No sudden direction change - only change if stopped
    elseif va01() == 1 and ov01() == 0 then
      fric (10)
      setv (ov01, 5)
      setv (ov04, 0)
      --* Trigger to start animation end) timer
      setv (ov80, 1)
    elseif va01() == 2 and ov01() == 0 then
      fric (10)
      setv (ov01, -5)
      setv (ov04, 0)
      --* Trigger to start animation end) timer
      setv (ov80, 1)
    end
    setv (ov02, 0)
  end

  --* Teleport? (not if creating clouds)
  if ov05 >= 250 and rand (0, 30) == 0 and ov07() == 0 then
    lock()
    --* Make sure autonomous
    if movs() == 0 then
      --* Call pickup script - this halts & resets
      call (4, 0, 0)
      --* Find new co-ordinates
      repeat
        -- EDITED --
          setv (va01, posl)
          setv (va02, post)
          --setv (va01, rand (0, 10000))
          --setv (va02, rand (0, 10000))
        -- END EDIT --
        --* Check exclusion zone for airlocks
        setv (va03, 0)
        if va01 >= 3200 and va02 >= 3600 and va01 <= 5600 and va02 <= 4500 then
          setv (va03, 1)
        end
      until tmvt (va01, va02) == 1 and va03() == 0
      --* Fade out
      snde "pl_1"
      setv (va03, 0)
      repeat
        inst()
        alph (va03, 1)
        addv (va03, 8)
        slow()
      until va03 > 256
      --* Move to new position
      inst()
      alph (256, 1)
      mvto (va01, va02)
      slow()
      --* Fade in
      snde "pl_1"
      setv (va03, 256)
      repeat
        inst()
        alph (va03, 1)
        subv (va03, 8)
        slow()
      until va03 < 0
      alph (0, 0)
      --* Call drop script - this re-enables
      call (5, 0, 0)
      setv (ov05, 0)
    end
    unlk()
  end

  --* Collision check if moving
  if ov01() ~= 0 and ov03 >= 5 then
    setv (va01, posx)
    setv (va02, posx)
    subv (va01, 10)
    addv (va02, 10)
    --* Stop if still within 20-pixel range of last check
    if ov04 > va01 and ov04 < va02 then
      fric (90)
      velo (0, 0)
      anim {}
      pose (0)
      setv (ov01, 0)
    end
    setv (ov04, posx)
    setv (ov03, 0)
  end

  --* Move
  if ov01() ~= 0 then
    inst()
    velo (ov01, vely)
    if ov80() == 1 and ov01 > 0 then
      anim {1, 2, 3, 4, 5, 6, 7, 8, 255}
      setv (ov80, 0)
    end
    if ov80() == 1 and ov01 < 0 then
      anim {1, 8, 7, 6, 5, 4, 3, 2, 255}
      setv (ov80, 0)
    end
    slow()
  end
end)

--* CLOUD 1 TIMER - FEEL GOOD
scrp(1, 1, 32213, 9, function()
  --* Change various "feel good" chemicals
  inst()
  etch (4, 0, 0, function()
    if targ() ~= null then
      --* Injury
      chem (90, -0.01)
      --* Stress
      chem (128, -0.01)
      --* Pain
      chem (148, -0.01)
      --* Coldness
      chem (152, -0.01)
      --* Hotness
      chem (153, -0.01)
      --* Loneliness
      chem (156, -0.01)
      --* Crowded
      chem (157, -0.01)
      --* Fear
      chem (158, -0.01)
      --* Anger
      chem (160, -0.01)
      --* Comfort
      chem (162, -0.01)
    end
  end)
  targ (ownr)
  slow()
  --* Change direction?
  if rand (0, 1) == 0 then
    --* Set random direction, but make sure isn't standing still
    repeat
      velo (rand (-1, 1), rand (-1, 1))
    until velx() ~= 0 and vely() ~= 0
  end
  --* Start animation
  if pose() == 1 then
    frat (2)
    anim {2, 3, 4, 5, 6, 7, 8, 9, 255}
  end
  if pose() == 0 then
    pose (1)
  end
  --* Life timer/kill
  addv (ov00, 1)
  if pose() == 13 then
    kill (ownr)
  end
  if pose() == 12 then
    pose (13)
  end
  if pose() == 11 then
    pose (12)
  end
  if pose() == 10 then
    pose (11)
  end
  if ov00 >= 50 then
    anim {}
    pose (10)
    tick (1)
    setv (ov00, 0)
  end
end)

--* CLOUD 2 TIMER - NASTY CHEMICALS
scrp(1, 1, 32214, 9, function()
  --* Reduce nasty chemicals
  inst()
  etch (4, 0, 0, function()
    if targ() ~= null then
      setv (va01, 66)
      repeat
        chem (va01, -0.01)
        addv (va01, 1)
      until va01() == 90
    end
  end)
  targ (ownr)
  slow()
  --* Change direction?
  if rand (0, 1) == 0 then
    --* Set random direction, but make sure isn't standing still
    repeat
      velo (rand (-1, 1), rand (-1, 1))
    until velx() ~= 0 and vely() ~= 0
  end
  --* Start animation
  if pose() == 1 then
    frat (2)
    anim {2, 3, 4, 5, 6, 7, 8, 9, 255}
  end
  if pose() == 0 then
    pose (1)
  end
  --* Life timer/kill
  addv (ov00, 1)
  if pose() == 13 then
    kill (ownr)
  end
  if pose() == 12 then
    pose (13)
  end
  if pose() == 11 then
    pose (12)
  end
  if pose() == 10 then
    pose (11)
  end
  if ov00 >= 50 then
    anim {}
    pose (10)
    tick (1)
    setv (ov00, 0)
  end
end)

--* CLOUD 3 TIMER - BACTERIA
scrp(1, 1, 32215, 9, function()
  --* Kill bacteria
  inst()
  rnge (60)
  esee (2, 32, 23, function()
    if targ() ~= null then
      kill (targ)
    end
  end)
  targ (ownr)
  slow()
  --* Change direction?
  if rand (0, 1) == 0 then
    --* Set random direction, but make sure isn't standing still
    repeat
      velo (rand (-1, 1), rand (-1, 1))
    until velx() ~= 0 and vely() ~= 0
  end
  --* Start animation
  if pose() == 1 then
    frat (2)
    anim {2, 3, 4, 5, 6, 7, 8, 9, 255}
  end
  if pose() == 0 then
    pose (1)
  end
  --* Life timer/kill
  addv (ov00, 1)
  if pose() == 13 then
    kill (ownr)
  end
  if pose() == 12 then
    pose (13)
  end
  if pose() == 11 then
    pose (12)
  end
  if pose() == 10 then
    pose (11)
  end
  if ov00 >= 50 then
    anim {}
    pose (10)
    tick (1)
    setv (ov00, 0)
  end
end)

rscr(function()
  --* Kill roamer
  enum (3, 8, 32201, function()
    kill (targ)
  end)
  --* Kill clouds
  enum (1, 1, 32213, function()
    kill (targ)
  end)
  enum (1, 1, 32214, function()
    kill (targ)
  end)
  enum (1, 1, 32215, function()
    kill (targ)
  end)
  scrx (3, 8, 32201, 1)
  scrx (3, 8, 32201, 2)
  scrx (3, 8, 32201, 3)
  scrx (3, 8, 32201, 4)
  scrx (3, 8, 32201, 5)
  scrx (3, 8, 32201, 9)
  scrx (1, 1, 32213, 9)
  scrx (1, 1, 32214, 9)
  scrx (1, 1, 32215, 9)
end)
