--* Script 1 extracted from WeatherGenerator\WeathergeneratorV2\Weather Generator v2.6.agents by Mirality REVELATION

--*creates a weather generator*
function WeatherGenerator2.install()
	new: simp(3, 8, 4603, "asweather2", 6, 0, 500)
	attr(199)
	bhvr(0)
	perm(40)
	accg(0)
	fric(70)
	aero(10)
	elas(100)
	pose(0)
	setv (va00, game("CreatorX"))
	setv (va01, game("CreatorY"))
	if va00() == 0 and va01() == 0 then
		setv(va00, 5687)
		setv(va01, 3670)
	end
	mvsf(va00, va01)
	--*ov00 is the generator's state. 0==idle 1==rain 2==mist/clouds 3==snow*
	setv(ov00, 0)
	tick(1)
end

scrp(3, 8, 4603, 1, function()
	addv(ov00, 1)
	if ov00 > 4 then
		setv(ov00, 0)
	end
	if ov00() == 0 then
		rtar (1, 2, 10)
		if targ() ~= null then
			mesg_wrt_plus (targ, 126, "All systems standing by.", ownr, 0)
		end
		targ(ownr)
	elseif ov00() == 1 then
		rtar (1, 2, 10)
		if targ() ~= null then
			mesg_wrt_plus (targ, 126, "Starting condensation of vapor.", ownr, 0)
		end
		targ(ownr)
	elseif ov00() == 2 then
		rtar (1, 2, 10)
		if targ() ~= null then
			mesg_wrt_plus (targ, 126, "Cloud formation initiated.", ownr, 0)
		end
		targ(ownr)
	elseif ov00() == 3 then
		rtar (1, 2, 10)
		if targ() ~= null then
			mesg_wrt_plus (targ, 126, "Temperature decreasing. Ice crystals forming.", ownr, 0)
		end
		targ(ownr)
	elseif ov00() == 4 then
		rtar (1, 2, 10)
		if targ() ~= null then
			mesg_wrt_plus (targ, 126, "Artificial Sun created. Temperature will rise.", ownr, 0)
		end
		targ(ownr)
	end
end)

scrp(3, 8, 4603, 9, function()

	local function rain()
--**same as cloud generaton, except clouds get an ov00 of 2: Rain**
		repeat
			inst()
			targ(ownr)
			setv(va00, posx)
			setv(va01, posy)
			new: simp(2, 19, 4603, "asweather2", 3, 6, 520)
			attr(192)
			bhvr(0)
			accg(0)
			fric(0)
			aero(0)
			elas(0)
			perm(40)
			emit(1, -1)
			alph(100, 1)
			anim [[0 0 0 1 1 1 2 2 2 255]]
			addv (va00, rand(-10, 10))
			addv (va01, rand(-10, 10))
			mvsf(va00, va01)
			setv (va00, rand(0, 1))
			if va00() == 1 then
				setv (velx, rand(1, 2))
			else
				setv (velx, rand(-1, -2))
			end
			setv(ov00, 2)
			tick(1)
			slow()
			targ(ownr)
			wait (rand(10, 20))
		until ov00() ~= 1
	end

	local function mist()
		repeat
			inst()
			targ(ownr)
			setv(va00, posx)
			setv(va01, posy)
			new: simp(2, 19, 4603, "asweather2", 3, 6, 520)
			attr(192)
			bhvr(0)
			accg(0)
			fric(0)
			aero(0)
			elas(0)
			perm(40)
			emit(1, -1)
			alph(100, 1)
			anim [[0 0 0 1 1 1 2 2 2 255]]
			addv (va00, rand(-10, 10))
			addv (va01, rand(-10, 10))
			mvsf(va00, va01)
			setv (va00, rand(0, 1))
			if va00() == 1 then
				setv (velx, rand(1, 2))
			else
				setv (velx, rand(-1, -2))
			end
			tick(1)
			slow()
			targ(ownr)
			wait (rand(10, 20))
		until ov00() ~= 2
	end
	local function snow()
		repeat
			inst()
			targ(ownr)
			setv(va00, posx)
			setv(va01, posy)
			new: simp(2, 19, 4603, "asweather2", 3, 6, 520)
			attr(192)
			bhvr(0)
			accg(0)
			fric(0)
			aero(0)
			elas(0)
			perm(40)
			emit(1, -1)
			alph(100, 1)
			anim [[0 0 0 1 1 1 2 2 2 255]]
			addv (va00, rand(-10, 10))
			addv (va01, rand(-10, 10))
			mvsf(va00, va01)
			setv (va00, rand(0, 1))
			if va00() == 1 then
				setv (velx, rand(1, 2))
			else
				setv (velx, rand(-1, -2))
			end
			setv(ov00, 3)
			tick(1)
			slow()
			targ(ownr)
			wait (rand(10, 20))
		until ov00() ~= 3
	end
	local function sun_()
		if ov01() ~= 1 then
			inst()
			targ(ownr)
			setv(va00, posx)
			setv(va01, posy)
			new: simp(2, 19, 4600, "asweather2", 1, 15, 500)
			attr(192)
			bhvr(0)
			accg(0)
			fric(100)
			aero(0)
			elas(100)
			perm(40)
			emit(2, 1)
			mvsf(va00, va01)
			setv(velx, 5)
			seta(ov00, ownr)
			setv(ov01, 1)
			tick(1)
			slow()
			targ(ownr)
		end
	end

	if ov00() == 0 then
		anim [[0]]
		stpc()
		emit(1, 0)
		emit(2, 0)
		emit(3, 0)
		emit(4, 0)
--*1==light 2==heat 3==water 4==nutrients. Some emits should be set on the weather objects themselves.
		tick(1)
	elseif ov00() == 1 then
		anim [[0 1 2 3 4 5 255]]
		emit(1, 0)
		emit(2, 0)
		emit(3, 1)
		emit(4, 0)
		sndl "rain"
		gsub(rain)
	elseif ov00() == 2 then
		anim [[0 1 2 3 4 5 255]]
		stpc()
		emit(1, -1)
		emit(2, 0)
		emit(3, 0)
		emit(4, 0)
		gsub(mist)
	elseif ov00() == 3 then
		anim [[0 1 2 3 4 5 255]]
		stpc()
		emit(1, 0)
		emit(2, -1)
		emit(3, 0)
		emit(4, 0)
		gsub(snow)
	elseif ov00() == 4 then
		anim [[0 1 2 3 4 5 255]]
		stpc()
		emit(1, 0)
		emit(2, 1)
		emit(3, 0)
		emit(4, 0)
		gsub(sun_)
	end

end)

scrp(2, 19, 4600, 9, function()
--*sun movement control
	altr (-1, 2, .1)
	altr (-1, 1, .1)
--*Movement 0==left 1 == right
	if ov01() == 1 then
		velo(1, 0)
	else
		velo(-1, 0)
	end
	if obst(left) < 50 then
		setv(ov01, 1)
	elseif obst(rght) < 50 then
		setv(ov01, 0)
	end
	targ(ov00)
--*The sun exists
	setv(ov01, 1)
	if ov00() ~= 4 then
--*The sun exists no more
		setv(ov01, 0)
		kill(ownr)
	else
		targ(ownr)
	end
end)

scrp(2, 19, 4602, 9, function()
	kill(ownr)
end)

scrp(2, 19, 4602, 6, function()
--*raindrop splashes
	anim [[0 1 2 3]]
	over()
	kill(ownr)
end)

scrp(2, 19, 4601, 9, function()
--*all snow has to melt sometime
	kill(ownr)
end)

scrp(2, 19, 4601, 6, function()
--*snow melting slowly
	wait(100)
	kill(ownr)
end)

scrp(2, 19, 4603, 9, function()
--*clouds rain or snow
	if ov00() == 2 then
		repeat
			wait(5)
			inst()
			targ(ownr)
			setv(va00, posx)
			setv(va01, posy)
			new: simp(2, 19, 4602, "asweather2", 5, 9, 519)
			attr(192)
			bhvr(0)
			accg(3)
			fric(100)
			aero(0)
			elas(0)
			if rand(1, 0) == 1 then
				emit(3, 1)
			else
				emit(4, 0.7)
			end
			perm(40)
			addv (va00, rand(-20, 20))
			addv (va01, rand(-10, 10))
			mvsf(va00, va01)
			tick(1000)
			slow()
			targ(ownr)
		until ov00() ~= 2
	elseif ov00() == 3 then
		repeat
			wait(8)
			inst()
			targ(ownr)
			setv(va00, posx)
			setv(va01, posy)
			new: simp(2, 19, 4601, "asweather2", 1, 14, 519)
			attr(192)
			bhvr(0)
			accg(0)
			fric(100)
			aero(0)
			elas(0)
			perm(40)
			emit(2, -1)
			addv (va00, rand(-20, 20))
			addv (va01, rand(-10, 10))
			mvsf(va00, va01)
			setv (va00, rand(0, 1))
			setv (vely, rand(1, 2))
			tick(500)
			slow()
			targ(ownr)
		until ov00() ~= 3
	end
end)

scrp(2, 19, 4603, 6, function()
	kill(ownr)
end)
