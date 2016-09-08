require("/scripts/caos_vm/caos.lua")
robot_toy = {}

--**Robot toy

function robot_toy.install()
	new: simp(2, 21, 20, "robot_toy", 23, 0, 2000)
	attr(199)
	--act1, act2, hit, pickup
	bhvr(43)
	elas(20)
	accg(3)
	aero(10)
	fric(70)
	perm(60)

	--puhl(-1, 25, 50)

	setv(ov10, rand(0, 1))
	if getv(ov10) == 0 then
		setv(ov10, -1)
	end
	if getv(ov10) < 0 then
		pose(0)
	else
		pose(12)
	end


	mvto(400, 9200)
end

--act 1
scrp(2, 21, 20, 1, function()
	inst()

	fade()
	stim_writ(from, 97, 1)
	mesg_wrt_plus(ownr(), 1000, 1, 0, 0)
end)
--act 2
scrp(2, 21, 20, 2, function()
	inst()
	fade()
	stim_writ(from, 97, 1)
	mesg_wrt_plus(ownr(), 1000, 2, 0, 0)
end)
--hit
scrp(2, 21, 20, 3, function()
	lock()
	fade()
	sndl("rob2")
	stim_writ(from, 97, 1)
	frat(1)
	anim({10, 11, 12, 11, 255})
	wait(100)
	inst()
	if getv(ov10) < 0 then
		pose(0)
	else
		pose(12)
	end
	fade()
end)
--pickup
scrp(2, 21, 20, 4, function()
	inst()
	fade()
	stim_writ(from, 97, 1)
	if getv(ov10) < 0 then
		pose(0)
	else
		pose(12)
	end
end)
--drop
scrp(2, 21, 20, 6, function()
	lock()
	sndc "dr10"
	if getv(ov10) < 0 then
		pose(0)
	else
		pose(12)
	end
end)


--*working event
scrp(2, 21, 20, 1000, function()

--turn
	local function turn()
		sndl "rob2"
--	if you're facing left
		if getv(ov10) < 0 then
			frat(3)
			anim [[10 11 12]]
			over()
		elseif getv(ov10) > 0 then
			frat(3)
			anim [[12 11 10 0]]
			over()
		end
		fade()
		negv(ov10)
	end

--walking left
	local function walk_left()
		anim [[0 1 2 3 4 5 6 7 8 9 10 0]]
		setv(va99, -5)
	end
--walking right
	local function walk_right()
		anim [[12 13 14 15 16 17 18 19 20 21 22 12]]
		setv(va99, 5)
	end

--*walking
	local function walk()
		sndc "rob1"
		frat(1)
		if getv(ov10) < 0 then
			walk_left()
		else
			walk_right()
		end
		velo(va99, -8)
	end
--jump left
	local function jump_left()
		anim [[0 1 2 3 3 3 3 3 4 5 6]]
		setv(va99, -10)
	end
--jump right
	local function jump_right()
		anim [[12 13 14 15 15 15 15 15 16 17 18]]
		setv(va99, 10)
	end

--*jumping	
	local function jump()
		sndc "rob1"
		frat(1)
		if getv(ov10) < 0 then
			jump_left()
		else
			jump_right()
		end
		velo(va99, -10)

	end

--P1 = 1 means jump
	if _p1_ == 1 then
		setv(va00, rand(0, 3))
		if getv(va00) == 0 then
			turn()
		else
			jump()
		end
	end
--P1 = 2 means walk
	if _p1_ == 2 then
		setv(va00, rand(0, 3))
		if getv(va00) == 0 then
			turn()
		else
			walk()
		end
	end

end)



--*REMOVAL
function robot_toy.uninstall()
	enum(2, 21, 20, function()
		kill(targ)
	end)
end
