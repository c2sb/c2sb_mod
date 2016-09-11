--**Versioning
--*$Id: snotrock.cos,v 1.14 2000/10/24 10:07:24 mashton Exp $

function snotrock.install()
reps(2, function()
--***create snotrock on top level of mesa
	new: simp(2, 15, 24, "snotrock", 79, 0, 320)
	attr(194)
--*	creatures can act1, act2, hit and pickup
	bhvr(43)

	tick(30)
	elas(0)
	aero(10)
	accg(2)
	perm(40)
	setv (ov10, rand(0, 1))
	if ov10() == 0 then
		setv(ov10, -1)
	end
	if ov10() == 1 then
		pose(5)
	end
--*initial energy level
	setv (ov02, rand(50, 100))

	if va00() == 0 then
		mvto(900, 8900)
	else
		mvto(1000, 9500)
	end
	addv(va00, 1)
	puhl (-1, 20, 20)
end)

--*****create snotrock pod ... dummy background to prevent extinciton
new: simp(1, 1, 163, "blnk", 1, 0, 0)
--*	long tick, over() 20 mins
tick(30000)
mvto(582, 8900)
end


--***snotrock pod timer
scrp(1, 1, 163, 9, function()
	inst()
	if totl (2, 15, 24) == 0 then
--*	produce two new ones
		setv(va00, posl)
		setv(va01, post)
		reps(2, function()
			new: simp(2, 15, 24, "snotrock", 79, 0, 320)
			attr(194)
			tick(30)
			elas(0)
			aero(10)
			accg(2)
			perm(40)
			setv (ov10, rand(0, 1))
			if ov10() == 0 then
				setv(ov10, -1)
			end
			if ov10() == 1 then
				pose(5)
			end
--*initial energy level
			setv (ov02, rand(50, 100))
			mvto(va00, va01)
			puhl (-1, 20, 20)
		end)
	end
end)

--***snotrock act1
scrp(2, 15, 24, 1, function()
--*	only do this if not dead
	if ov00() ~= 9 then
		if ov10 < 0 then
			anim [[16 15 14 13 12 11 10]]
		else
			anim [[23 22 21 20 19 18 17]]
		end
		over()
		wait(50)
	end
end)

--***snotrock act2
scrp(2, 15, 24, 2, function()
--*	only do this if not dead
	if ov00() ~= 9 then
		if ov10 < 0 then
			anim [[16 15 14 13 12 11 10]]
		else
			anim [[23 22 21 20 19 18 17]]
		end
		over()
		wait(50)
	end
end)

--***snotrock hit
scrp(2, 15, 24, 3, function()
	if ov10 < 0 then
		setv(va00, -20)
	else
		setv(va00, 20)
	end
	velo(va00, -10)
end)

--****snotrock pickup
scrp(2, 15, 24, 4, function()
--*	only do this if not dead
	if ov00() ~= 9 then
		if ov10 < 0 then
			anim [[16 15 14 13 12 11 10]]
		else
			anim [[23 22 21 20 19 18 17]]
		end
		over()
	end
end)




--***snotrock collision
scrp(2, 15, 24, 6, function()
	if wall() == left or wall() == rght then
		call (1000, 0, 0)
	end
end)


--*******snotrock timer
scrp(2, 15, 24, 9, function()
--**OV00 is state
--*0==growing
--*1==adult waiting
--*2==looking for food
--*3==approaching food
--*4==having a baby

--*9==dying

--**OV01 is age
--**OV02 is energy level
--**OV16 is food target
--**OV90 is had baby before? flag
--*0==no
--*1==yes


--****growing
	local function grow()
		if ov10 < 0 then
			if pose < 4 then
				setv(va00, pose)
				addv(va00, 1)
				pose(va00)
			else
				setv(ov00, 1)
			end
		else
			if pose < 9 then
				setv(va00, pose)
				addv(va00, 1)
				pose(va00)
			else
				setv(ov00, 1)
			end
		end
	end
--****Erupt
	local function erup()
		if ov10 < 0 then
			anim [[10 11 12 13 14 15 16]]
		else
			anim [[17 18 19 20 21 22 23]]
		end
		over()
		setv(ov00, 2)
	end
--****hide
	local function hide()
		if ov10 < 0 then
			anim [[16 15 14 13 12 11 10]]
		else
			anim [[23 22 21 20 19 18 17]]
		end
		over()
		setv(ov00, 1)
	end
--****Walk
	local function walk()
		if ov10 < 0 then
			anim [[30 31 32 33 34 35 36 37 255]]
			setv(va00, -5)
		else
			anim [[38 39 40 41 42 43 44 45 255]]
			setv(va00, 5)
		end
		fric(0)
		velo(va00, 0)
	end
--****turn
--*	local function turn()
--*		if ov10 < 0
--*			anim [[46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62]]
--*		else
--*			anim [[62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46]]
--*		end
--*		over()
--*		negv ov10
--*	end
--****eat
	local function eat()
		anim [[]]
		velo(0, 0)
		inst()
		if ov16() ~= null then
			mesg_writ (ov16, 12)
			addv(ov02, 50)
		end
		slow()
		gsub(hide)
	end
--****die
	local function die()
		if ov10 < 0 then
			if pose < 63 then
				pose(63)
				stop()
			elseif pose < 70 then
				setv(va00, pose)
				addv(va00, 1)
				pose(va00)
				stop()
			else
				kill(ownr)
			end
		else
			if pose < 71 then
				pose(71)
				stop()
			elseif pose < 78 then
				setv(va00, pose)
				addv(va00, 1)
				pose(va00)
				stop()
			else
				kill(ownr)
			end
		end
	end

--*reset friction
	fric(100)
	anim [[]]

--*reduce energy and increment age
	addv(ov01, 1)
	subv(ov02, 1)

--*don't do anything if falling or carried
	if fall() == 1 then
		stop()
	end
	if carr() ~= null then
		stop()
	end

--*if no energy flag for death
	if ov02 <= 0 then
		setv(ov00, 9)
	end

--*if flagged for dying ..
	if ov00() == 9 then
		gsub(die)
	end

--*if growing
	if ov00() == 0 then
		gsub(grow)
	end

--*adult who's had a baby?
	if ov00() == 1 and ov90() == 1 then
		if totl (2, 15, 24) < 3 then
--*		be able to have another baby!
			setv(ov90, 0)
--*		but pay the energy cost
			subv(ov02, 10)
		end
	end


--*adult who's never had a child - have a baby?
	if ov00() == 1 and ov90() == 0 then
--*	if have enough energy and old enough
		if ov02 > 80 and ov01 > 100 then
			gsub(erup)
			setv(ov00, 4)
		end
	end

--*adult - waiting
	if ov00() == 1 then
--*		if energy below certain level (or random is true)
		if ov02 < 50 or rand(0, 30) == 0 then
--*			go looking for food
			setv(ov00, 2)
		end
	end

--*looking for food
	if ov00() == 2 then
		if pose() == 10 or pose() == 17 then
			gsub(erup)
			stop()
		end
--*	search for food close by
		rnge(200)
		setv(va00, 10000)
		seta(va02, null)
		inst()
		esee(2, 11, 8, function()
--*		only check tuba that can be eaten
			if ov05() == 1 then
--*		only check food roughly on the same height
				setv (va01, rely (ownr, targ))
				if va01 < 0 then
					negv (va01)
				end
				if va01 < 100 then
					setv (va01, relx (ownr, targ))
					if va01 < 0 then
						negv (va01)
					end
					if va01 < va00 then
						setv(va00, va01)
						seta(va02, targ)
					end
				end
			end
		end)
--*	if found some change mission to approach food
		if va02() ~= null then
			seta(ov16, va02)
			setv(ov00, 3)
--*	otherwise walk in a straight line searching
		else
			gsub(walk)
		end
	end

--*approaching food
	if ov00() == 3 then
		inst()
		targ(ov16)
		if targ() ~= null then
			setv(va00, posx)
		else
			targ(ownr)
			setv(ov00, 2)
		end
		targ(ownr)
		slow()
--*	if you're facing the wrong way turn around
		if posx > va00 and ov10 > 0 then
			call (1000, 0, 0)
		elseif posx < va00 and ov10 < 0 then
			call (1000, 0, 0)
		end
		gsub(walk)
		inst()
		if ov16() ~= null then
			if touc (ownr, ov16) == 1 then
				gsub(eat)
			end
		else
			setv(ov00, 2)
		end
		slow()
	end

--*having a baby
	if ov00() == 4 then
		lock()
		setv(va00, posl)
		setv(va01, post)
		setv (va02, rand(2, 4))
		reps(va02, function()
			setv(vely, -10)
			wait(10)
		end)
		inst()
--***create baby snotrock 
		new: simp(2, 15, 24, "snotrock", 79, 0, 320)
		attr(194)
		tick(30)
		elas(0)
		aero(10)
		accg(2)
		perm(40)
		setv (ov10, rand(0, 1))
		if ov10() == 0 then
			setv(ov10, -1)
		end
		if ov10() == 1 then
			pose(5)
		end
--*initial energy level
		setv (ov02, rand(50, 100))
		puhl (-1, 20, 20)
		mvsf(va00, va01)
		targ(ownr)
		setv(ov00, 1)
		setv(ov90, 1)
		unlk()
	end


end)


--**snotrock turn around event
scrp(2, 15, 24, 1000, function()
	lock()
	if ov10 < 0 then
		anim [[46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62]]
	else
		anim [[62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46]]
	end
	over()
	negv (ov10)
	setv(va00, 5)
	mulv(va00, ov10)
	velo(va00, 0)
end)

--*****REMOVAL
rscr(function()
enum(2, 15, 24, function()
	kill(targ)
end)
enum(1, 1, 163, function()
	kill(targ)
end)
end)
