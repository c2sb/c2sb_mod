--* Script 1 extracted from NG-Eastertribble/tribble.agents by Mirality REVELATION

--*eastertripple
--*strange litte animal from the norngarden. Sprites and chaos by tomtschek
--*ov00 size (energylevel to grow 60/70/80/100)
--*ov01 age 
--*ov02 energy
--*ov05 color (base)
--*ov10 orientation(horizontal not sexual)
--*ov95 last mates color
--*ov98 in water if 1
--*ov99 eggcountdown

function NG_Eastertribble.install()
	inst()
	setv (va05, rand(0, 2))
	if va05() == 1 then
		setv(va05, 16)
	elseif va05() == 2 then
		setv(va05, 32)
	end
		new: simp (2, 15, 31900, "ngtripple", 64, 192, 501)
			attr (199)
			bhvr (59)
			elas (30)
			fric (95)
			accg (3)
			aero (1)
			perm (60)
			setv(ov05, va05)	
			setv(ov00, 100)
			setv(ov01, 0)
			setv(ov02, 50)
			setv(ov10, 0)
			base (ov05)
			anim [[13 14 255]]
			tick (rand(10, 30))

		if game("CreatorX") ~= 0 and game("CreatorY") ~= 0 then

			mvsf (game("CreatorX"), game("CreatorY"))

			velo (rand(-5, 5), rand(0, -5))

		else

			mvsf (5440, 3580)

			velo (rand(30, 40), -5)

		end



		if room(targ) == grap (5440, 3580) then

			mvsf (5440, 3580)

			velo (rand(30, 40), -5)

		end


end

	

--*tickscript
scrp(2, 15, 31900, 9, function()

local function jump()
	inst()
	if ov10() == 0 then
		setv (ov10, rand(0, 1))
		if ov10() == 0 then
			setv(ov10, -1)
		end
		if ov10 > 0 then
			anim [[5]]
			over()
		elseif ov10 < 0 then
			anim [[11]]
			over()
		end
	end
	setv (va05, rand(3, 8))
	mulv(va05, ov10)
	if ov10 > 0 then
		anim [[0 1 2 3]]
		over()
		velo (va05, rand(-5, -15))
		anim [[4 3 2 1]]
		over()
		anim [[0 1 255]]
	elseif ov10 < 0 then
		anim [[6 7 8 9]]
		over()
		velo (va05, rand(-5, -15))
		anim [[10 9 8 7]]
		over()
		anim [[6 7 255]]
	end
end

local function moove()
	if ov10() == 0 then
		anim [[13 14 255]]
	elseif ov10 > 0 then
		anim [[0 1 255]]
	elseif ov10 < 0 then
		anim [[6 7 255]]
	end
end

local function front()
	if ov10 > 0 then
		anim [[5]]
		over()
	elseif ov10 < 0 then
		anim [[11]]
		over()
	end
	setv(ov10, 0)
	gsub(moove)
end
	
local function swim()

--*if falling into water try getting out of it 
	inst()
	aero (1)
	setv(va10, ov10)
	mulv (va10, rand(10, 20))
	velo (va10, 0)
	gsub(jump)
	gsub(moove)

end

local function grow()
	inst()
	setv(va00, posl)
	subv(va00, 5)
	setv(va01, post)
	subv(va01, 40)
	if ov00() == 60 then
		setv(va02, 64)
	elseif ov00() == 70 then
		setv(va02, 128)
	elseif ov00() == 80 then
		setv(va02, 192)
	elseif ov00() == 90 then
		setv(va02, 192)
	end
	setv(va05, ov05)
	if va05() ~= 0 and va05() ~= 16 and va05() ~= 32 and va05() ~= 48 then
		setv(va05, 0)
	end 
	setv(va06, ov00)
	addv(va06, 10)
	setv(va07, ov01)
	setv(va09, 0)
	snde "tpl2"
	new: simp (2, 15, 31900, "ngtripple", 64, va02, 501)
		attr (199)
		bhvr (59)
		elas (30)
		fric (95)
		accg (3)
		aero (2)
		perm (60)
		setv(ov05, va05)	
		setv(ov00, va06)
		setv(ov01, va07)
		setv(ov02, 50)
		setv(ov10, 0)
		base (ov05)
		anim [[13 14 255]]
		tick (rand(10, 30))
		velo (0, rand(-2, -5))
		if tmvt(va00, va01) == 1 then
			mvto(va00, va01)
		else
			kill (targ)
			setv(va09, 1)
		end
	targ (ownr)
	if va09() ~= 1 then
		kill (ownr)
	end
end

local function egg()
	inst()
	setv (va07, rand(3, 5))
	if va07() == 5 then
		gsub(front)
		lock()
		reps (rand(3, 6), function()
			velo (0, rand(-1, -9))
			wait (rand(8, 15))
		end)
		inst()
		lock()
		setv (va95, rand(0, 1))
		if va95() == 0 then
			setv(va09, ov05)
		else
			setv(va09, ov95)
		end
		setv (va08, rand(0, 6))
		if va08() == 0 then
			addv(va09, 16)
		elseif va08() == 1 then
			subv(va09, 16)
		end
		if va09 < 0 then
			setv(va09, ov05)
		elseif va09 > 48 then
			setv(va09, ov05)
		end
		setv(va00, posl)
		addv(va00, 15)
		setv(va01, post)
		subv(va01, 5)
		setv (va11, rand(0, 250))
		setv (va12, rand(0, 250))
		setv (va13, rand(0, 250))
		setv (va14, rand(0, 250))
		setv (va15, rand(0, 250))
		snde "tpl2"
		new: simp (3, 4, 31900, "ngtripple", 3, 256, 500)
			attr (195)
			bhvr (48)
			elas (30)
			fric (rand(70, 90))
			accg (3)
			perm (rand(50, 70))
			setv(ov05, va09)
			tick (rand(300, 1200))

			if tmvt(va00, va01) == 1 then
				mvto(va00, va01)
				tint (va11, va12, va13, va14, va15)
			else
				kill (targ)
			end
		targ (ownr)
		subv(ov99, 1)
		subv(ov02, 5)
		gsub(moove)
	end
end

local function kisspop()
	gsub(front)
	reps (rand(3, 5), function()
		velo (0, rand(-3, -10))
		setv (va11, rand(0, 6))
		if va11() == 0 then
			snde "tpl5"
		elseif va11() == 1 then
			snde "tpl6"
		elseif va11() == 2 then
			snde "tpl4"
		end
		wait (rand(9, 15))
	end)
end
local function eat()
	gsub(front)
	reps(5, function()
		anim [[12 13 14]]
		over()
	end)
	inst()
	if va10() ~= null then
		setv(va11, 0)
		targ (va10)
		if targ() ~= null then
			kill (targ)
			setv (va11, rand(10, 30))
		end
		targ (ownr)
		addv(ov02, va11)
	end
	reps(5, function()
		anim [[12 13 14]]
		over()
	end)
	gsub(moove)
end

local function die()
	lock()
	gsub(front)
	gsub(moove)
	wait (rand(5, 50))
	anim [[]]
	pose (15)
	wait (rand(50, 500))
	inst()
	setv(va00, posx)
	setv(va01, posy)
	setv(va02, ov00)
	divv(va02, 10)
	snde "tpl3"
	reps(va02, function()
		new: simp (2, 10, 31905, "ngtripple", 1, 259, 400)
		attr (192)
		bhvr (48)
		elas (48)
		accg (2)
		fric (80)
		velo (rand(-15, 15), rand(-15, -1))
		tick (rand(100, 300))
		if tmvt(va00, va01) == 1 then
			mvto(va00, va01)
		else
			kill (targ)
		end
	end)
	kill (ownr)
end

inst()
--*age and consume energy
addv(ov01, 1)
subv(ov02, 1)

--*if too old - die
if ov01 > 600 or ov02 <= 0 then
	gsub(die)
end



--*set  base for all animations
base (ov05)

--*what to do if in water or having been in water
if rtyp (room(targ)) == 8 or rtyp (room(targ)) == 9 then
	if ov98() ~= 1 then
		setv(ov98, 1)
		if ov10() == 1 then
			setv(ov10, -1)
		else
			setv(ov10, 1)
		end 
		accg (1)
		aero (20)
	end
end 
if ov98() == 1 then
	if rtyp (room(targ)) == 8 or rtyp (room(targ)) == 9 then
		gsub(swim)
	else
		accg (1)
		aero (5)
		addv(ov96, 1)
		if ov96() == 5 then
			if rtyp (room(targ)) == 8 or rtyp (room(targ)) == 9 then
				gsub(swim)
			else
				setv(ov98, 0)
				setv(ov96, 0)
				accg (3)
				aero (1)
			end
		elseif ov96 > 20 then
			gsub(die)
		end
	end
	tick (1)
else
	
	--*if energy is high-grow or lay egg
	if ov02 > ov00 then
		if ov00() == 100 and ov99 > 0 then
			gsub(egg)
		elseif ov00 < 100 then
			gsub(grow)
		end
	
	end 

	--*check if touching other tripple or seed

	setv(va04, 0)
	setv(va05, 0)
	setv(va06, 0)
	setv(va99, 0)
	seta(va10, null)
	etch(2, 15, 31900, function()
		if targ() ~= ownr() then
			setv(va04, 1)
			if ov00() == 100 then
				setv(va06, 1)
				setv(va95, ov05)
			end
		end
	end)
	etch(2, 3, 0, function()
		setv(va05, 1)
		seta(va10, targ)
	end)

	--*remember that other tripples color
	setv(ov95, va95)
	--*eat if food available-kisspop if tripple is available
	if va04() == 1 and ov02 > 40 then

		if va06() == 1 then
			setv (ov99, rand(5, 20))
		end
		gsub(kisspop) 
		gsub(jump)
	else
		if va05() == 1 then
			gsub(eat)
		else
			gsub(jump)
		end
	end


	--*random tick
	tick (rand(30, 200))
end

end)


--*tickscript for detritus
scrp(2, 10, 31905, 9, function()
kill (ownr)
end)

--*tickscript for egg

scrp(3, 4, 31900, 9, function()
if pose() == 0 then
	pose (1)
	tick (rand(30, 100))
elseif pose() == 1 then
	inst()
	setv(va00, posl)
	setv(va01, post)
	subv(va01, 40)
	setv(va05, ov05)
	if va05() ~= 0 and va05() ~= 16 and va05() ~= 32 and va05() ~= 48 then
		setv(va05, 0)
	end
	snde "tpl2"
	inst()
	new: simp (2, 15, 31900, "ngtripple", 64, 0, 501)
		attr (199)
		bhvr (59)
		elas (30)
		fric (95)
		accg (3)
		aero (2)
		perm (60)
		setv(ov05, va05)	
		setv(ov00, 60)
		setv(ov01, 0)
		setv(ov02, 50)
		setv(ov10, 0)
		base (ov05)
		anim [[13 14 255]]
		tick (rand(10, 50))
		velo (rand(-5, 5), rand(-5, -1))
		if tmvt(va00, va01) == 1 then
			mvto(va00, va01)
		else
			kill (targ)
		end
	targ (ownr)
	pose (2)
else
	kill (ownr)
end

end)



--*eatscrript
scrp(2, 15, 31900, 12, function()
	lock()
	snde "tpl1"
	stim_writ (from, 80, 4)
	kill (ownr) 
end)

--*eatscript for detritus
scrp(2, 10, 31905, 12, function()
	lock()
	snde "chwp"
	stim_writ (from, 81, 1)
	kill (ownr)
end)

--*eatscript for egg

scrp(3, 4, 31900, 12, function()
	lock()
	snde "chwp"
	stim_writ (from, 80, 2)
	kill (ownr) 
end)

--*tripple push
scrp(2, 15, 31900, 1, function()
	snde "tpl0"
	velo (rand(-5, 5), rand(-5, -1))
	stim_writ (from, 86, 1)
end)

--*tripple pull
scrp(2, 15, 31900, 2, function()
	snde "tpl0"
	velo (rand(-5, 5), rand(-5, -1))
	stim_writ (from, 86, 1)
end)
--*tripple hit
scrp(2, 15, 31900, 3, function()
	snde "tpl0"
	velo (rand(-5, 5), rand(-5, -1))
	stim_writ (from, 87, 1)
end)
scrp(2, 15, 31900, 4, function()
	snde "tpl5"
	stim_writ (from, 85, 1)
	tick (0)
end)
scrp(2, 15, 31900, 5, function()
	velo (rand(-5, 5), rand(-5, -1))
	tick (1)
	setv(ov98, 0)
	setv(ov96, 0)
	accg (3)
	aero (1)
end)
scrp(2, 15, 31900, 6, function()

	if wall() == rght then
		setv(ov10, -1)
	elseif wall() == left then
		setv(ov10, 1)
	end
end)


--*********
--*remoove scripts
rscr(function()
enum(2, 10, 31905, function()
kill (targ) 
end)

enum(2, 15, 31900, function()
kill (targ)
end)

enum(3, 4, 31900, function()
kill (targ)
end)
scrx(2, 15, 31900, 1) scrx(2, 15, 31900, 2) scrx(2, 15, 31900, 3) scrx(2, 15, 31900, 4) scrx(2, 15, 31900, 5) scrx(2, 15, 31900, 6) scrx(2, 15, 31900, 9)  scrx(2, 15, 31900, 12)  scrx(3, 4, 31900, 9)  scrx(3, 4, 31900, 12)  scrx(2, 15, 31900, 9) scrx(2, 15, 31900, 12)

end)
