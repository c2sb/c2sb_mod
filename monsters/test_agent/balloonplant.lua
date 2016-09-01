require("/scripts/caos_vm/constants.lua")

--* Script 1 extracted from Balloonplant.agents by Mirality REVELATION

--*The plant itself!

function install()
    --inst
    new_simp(CAOS.FAMILY.OBJECT, CAOS.OBJECT_GENUS.LEAF, 6205, "BulbBalloon", 0, 0, 4567)

    attr(CAOS.ATTRIBUTES.SUFFER_PHYSICS | CAOS.ATTRIBUTES.SUFFER_COLLISIONS)
    elas(0)
    fric(100)
    accg(5)
    perm(70)
    setv("ov03", 1)
    pose(0)
    --mvto 1600 9200
    tick(10)
end

function scrp_2_6_6205_9()

    va06 = pose()
    for i = 1, 7 do
        wait(rand(120, 400))
        va06 = va06 + 1
        pose(va06)
    end

    wait(rand(120, 400))
    va08 = posx()
    va09 = posy()
    va08 = va08 - 30
    va09 = va09 - 20
    addv ov03 1
--***************************************************
    new_simp(CAOS.FAMILY.OBJECT, CAOS.OBJECT_GENUS.PLANT, 6204, "BulbBalloon", 0, 10, 4567)
    attr(CAOS.ATTRIBUTES.SUFFER_PHYSICS | CAOS.ATTRIBUTES.SUFFER_COLLISIONS | CAOS.ATTRIBUTES.MOUSEABLE)
    bhvr 32
    elas(50)
    fric(50)
    accg(-0.3)
    perm(40)
    pose(0)
    velo rand(10, -10) rand(-10, -25)
    --mvsf va08 va09
--****************************************************
    targ ownr
    pose(8)
    wait(rand(120, 400))
    pose(9)
    wait(200)
    kill(OWNR)
end

function scrp_2_4_6204_6()
    va10 = posx()
    va11 = posy()
    va11 = va11 + 20
    for i = 1, (rand(5, 7)) do
        pose(0)
        --*this is an edible food blob

        --inst

        new_simp(CAOS.FAMILY.OBJECT, CAOS.OBJECT_GENUS.FOOD, 6203, "BulbBalloon", 0, 11, 4567)

        attr(CAOS.ATTRIBUTES.SUFFER_PHYSICS | CAOS.ATTRIBUTES.SUFFER_COLLISIONS | CAOS.ATTRIBUTES.MOUSEABLE | CARRYABLE)
        bhvr 48
        elas(30)
        fric(20)
        accg(2)
        pose(1)
        --mvsf va10 va11
        velo rand(10, -10) rand(10, -10)
        tick(250)
    end

    for i = 1, (rand(5, 7)) do
        --inst
        new_simp(CAOS.FAMILY.OBJECT, CAOS.OBJECT_GENUS.SEED, 6201, "BulbBalloon", 0, 11, 4567)

        attr(CAOS.ATTRIBUTES.SUFFER_PHYSICS | CAOS.ATTRIBUTES.SUFFER_COLLISIONS | CAOS.ATTRIBUTES.MOUSEABLE | CARRYABLE)
        bhvr 48
        elas(20)
        fric(40)
        accg(2)
        pose(2)
        --mvsf va10 va11
        velo rand(10, -10) rand(0, 10)
        tick(rand(0, 250))
    end
    kill(OWNR)
end

--function scrp_2_11_6203_12()
--    --lock
--    sndc "chwp"
--    stim writ from 79 1
--    kill(OWNR)
--end

function scrp_2_11_6203_4()
    pose(1)
end

function scrp_2_11_6203_9()
    kill(OWNR)
end

function scrp_2_11_6203_6()
    pose(0)
end

function scrp_2_3_6201_9()
    if fall == 1 then
       return
    end
    if carr ~= nil then
       return
    end
    if rtyp room targ < 5 or rtyp room targ > 7 then
       kill(OWNR)
    end
    rnge 800
    va99 = 0
    esee 2 6 6205
       va99 = va99 + 1
    end
    if va99 > 2 then
       kill(OWNR)
    end
    va08 = posx()
    va09 = posy()
    va08 = va08 - 30
    va09 = va09 - 20
    new_simp(CAOS.FAMILY.OBJECT, CAOS.OBJECT_GENUS.LEAF, 6205, "BulbBalloon", 0, 0, 4567)

    attr(CAOS.ATTRIBUTES.SUFFER_PHYSICS | CAOS.ATTRIBUTES.SUFFER_COLLISIONS)
    elas(0)
    fric(100)
    accg(5)
    perm(70)
    pose(0)
    --mvsf va08 va09
    tick(10)
    kill(OWNR)
end

--function scrp_2_3_6201_12()
--    --lock
--    sndc "chwp"
--    chem 5 50
--    chem 12 25
--    kill(OWNR)
--end
