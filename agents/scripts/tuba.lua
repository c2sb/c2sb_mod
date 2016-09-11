--**Versioning
--*$Id: tuba.cos,v 1.21 2001/01/17 09:30:46 mashton Exp $


--**TUBA 2 11 8
--**TUBA SEED 2 3 16


function tuba.install()
inst()
reps(3, function()
	reps(10, function()
--*create some seeds
		new: simp(2, 3, 16, "tuba", 16, 66, 305)
		attr(194)
		bhvr(48)
		elas(0)
		aero(1)
		perm(40)
		anim [[0 1 2 3 4 5 6 7 255]]
		emit(7, 0.5)
		if va00() == 0 then
			mvto (rand(800, 1200), 8900)
		else
			mvto (rand(800, 1200), 9500)
		end
		velo (rand(-10, 10), rand(0, -10))
		tick (rand(30, 60))
	end)
	addv(va00, 1)
end)

--****create the dummy backdrop pod that will produce Tuba's if they go extinct.
new: simp(1, 1, 162, "blnk", 1, 0, 0)
--*tick(24000)
tick(2400)
mvto(800, 8900)
end

--***tuba pod timer
scrp(1, 1, 162, 9, function()
	inst()
	if totl (2, 3, 16) < 3 then
		setv(va00, 1)
	end
	if totl (2, 11, 8) < 3 then
		setv(va01, 1)
	end
--*	AND the two values
	andv(va00, va01)
--*	if there's none left then produce a few seeds
	if va00() == 1 then
		setv(va00, posl)
		setv(va01, post)
		reps(2, function()
			new: simp(2, 3, 16, "tuba", 16, 66, 305)
			attr(194)
			bhvr(48)
			elas(0)
			aero(1)
			perm(40)
			anim [[0 1 2 3 4 5 6 7 255]]
			emit(7, 0.5)
			tick (rand(30, 60))
			mvto(va00, va01)
		end)
	end
end)

--****seed collision
scrp(2, 3, 16, 6, function()
	inst()
	if wall() == down then
		if rand(0, 1) == 0 then
			anim [[8 9 10 11]]
		else
			anim [[12 13 14 15]]
		end
	end

end)
--****seed eat
scrp(2, 3, 16, 12, function()
	lock()
	snde "chwp"
	stim_writ (from, 77, 3)
	wait(1)
	kill(ownr)
end)
--****seed timer
scrp(2, 3, 16, 9, function()
--*if still falling stop()
	if fall() == 1 then
		stop()
	end
--*if being carried stop()
	if carr() ~= null then
		stop()
	end
--*if not on a soil floor die -- TODO
	--if rtyp (room(targ)) < 5 or rtyp (room(targ)) > 7 then
	--	kill(ownr)
	--end
--*otherwise should be ok to grow
	inst()
	setv(va00, posl)
	setv(va01, post)
--*count how many others you can see
	rnge(100)
	setv(va99, 0)
	esee(2, 11, 8, function()
		addv(va99, 1)
	end)
--*if there's more than 5 then don't grow
	if va99 >= 5 then
		kill(ownr)
	end
--*if there's 2 or less then grow large
	if va99 <= 2 then
		setv(va90, 33)
	else
--*otherwise use small sprites
		setv(va90, 0)
	end
--*adjust positioning based on size of sprite being used
	if va90() == 0 then
		subv(va00, 8)
		subv(va01, 20)
	else
		subv(va00, 12)
		subv(va01, 25)
	end

	new: simp (2, 11, 8, "tuba", 33, va90, 4000)
	attr(194)
	bhvr(48)
	elas(0)
	accg(3)
	perm(52)
	emit(8, 0.5)
--*keep record of whether you are large or small
	setv(ov99, va90)
	if tmvt(va00, va01) == 1 then
		mvto(va00, va01)
	else
		mvsf(va00, va01)
	end
	setv(ov90, posl)
	setv(ov91, post)
	puhl (-1, 0, 0)
	tick(30)
	kill(ownr)
end)

--***tuba timer
scrp(2, 11, 8, 9, function()
--**OV00 state
--*0==growing
--*1==adult
--*2==seeding
--*3==dying
--*4==picked

--**OV01() == age
--*OV05 is stage of life
--*0==baby (not able to be eaten)
--*1==adult (able to be eaten)
--*2==old (not able to be eaten)

--**OV90 is x position
--**OV91 is y position
--**OV99 large or small
--*0==small
--*>0==large

	if carr() == null and fall() == 0 then
		setv(ov90, posl)
		setv(ov91, post)
	end
--**growing
	if ov00() == 0 then
		if pose < 6 then
			setv(va00, pose)
			addv(va00, 1)
			pose(va00)
		else
			setv(ov00, 1)
--*		mark as adult that can be eaten
			setv(ov05, 1)
		end
	end

--**adult
	if ov00() == 1 then
--*increment age
		addv(ov01, 1)
--*if larger than 20 start to seed
		if ov01 > 20 then
			setv(ov00, 2)
		end
	end

--**seeding
	if ov00() == 2 then
		if pose() == 6 then
			pose(14)
			stop()
		elseif pose < 18 then
			setv(va00, pose)
			addv(va00, 1)
			pose(va00)
		else
			inst()

			rnge(100)
			setv(va99, 0)
			esee(2, 11, 8, function()
				addv(va99, 1)
			end)
--*if a lot of others around only produce one seed
			if va99 > 2 then
				setv(va90, 1)
--*otherwise produce 2
			else
				setv(va90, 2)
			end

			setv(va00, posl)
			setv(va01, post)
			if ov99() == 0 then
				addv(va00, 11)
				addv(va01, 10)
			else
				addv(va00, 17)
				addv(va01, 14)
			end
			reps(va90, function()
--*create some seeds
				new: simp(2, 3, 16, "tuba", 16, 66, 305)
				attr(194)
				bhvr(48)
				elas(0)
				aero(1)
				perm(40)
				anim [[0 1 2 3 4 5 6 7 255]]
				emit(7, 0.5)
				mvto(va00, va01)
				velo (rand(-10, 10), rand(0, -10))
				tick (rand(30, 60))
			end)
			targ(ownr)
			pose(6)
			setv(ov00, 3)
			stop()
		end
	end


--**dying
	if ov00() == 3 then
--*	mark as old and unable to be eaten
		setv(ov05, 2)
--*	& stop() emiting
		emit(8, 0)
		if pose() == 6 then
			pose(19)
			stop()
		elseif pose() == 26 or pose() == 27 then
			pose(19)
			stop()
		elseif pose < 25 then
			setv(va00, pose)
			addv(va00, 1)
			pose(va00)
		else
			kill(ownr)
		end
	end

--**picked
	if ov00() == 4 then
		if carr() == null and fall() == 0 then
			if pose < 32 then
				setv(va00, pose)
				addv(va00, 1)
				pose(va00)
			else
				inst()
--*				randomly produce a seed
				if rand(0, 1) == 0 then
					setv(va00, posl)
					setv(va01, post)
					new: simp(2, 3, 16, "tuba", 16, 66, 305)
					attr(194)
					bhvr(48)
					elas(0)
					perm(40)
					aero(1)
					emit(7, 0.5)
					mvsf(va00, va01)
					tick (rand(30, 60))
				end
				kill(ownr)
			end
		end
	end




end)

--***tuba pickup
scrp(2, 11, 8, 4, function()
	inst()

--*	dbg: outs "TUBA pickup"

	if ov00() ~= 4 then
		setv(va00, ov90)
		setv(va01, ov91)
		if ov99() == 0 then
			setv(va99, 7)
		else
			setv(va99, 40)
		end
--**this creates the leaf stub left on the floor
		new: simp (2, 10, 51, "tuba", 19, va99, 3000)
		tick(50)
		mvto(va00, va01)
--**make the parent plant become the 'fruit'
		targ(ownr)
		pose(28)
		puhl (-1, 20, 30)
		setv(ov00, 4)
		tick(100)
	end
end)

--**tuba eat
scrp(2, 11, 8, 12, function()
	inst()

--*	stim
	if from ~= null then
		sndc "chwp"
		targ(from)
		chem(95, .05)
		stim_writ (targ, 79, 1)
	end
--*	randomly produce a seed
	if rand(0, 1) == 0 then

		setv(va00, posl)
		setv(va01, post)
		new: simp(2, 3, 16, "tuba", 16, 66, 305)
		attr(194)
		bhvr(48)
		elas(0)
		perm(40)
		aero(1)
		emit(7, 0.5)
		mvsf(va00, va01)
		tick (rand(30, 60))
	end
	kill(ownr)

--*	lock()
--*
--*	dbg: outs "TUBA EATEN"
--*
--**	if you can be eaten	
--*	if ov05() == 1
--**		if picked already
--*		if ov00() == 4
--*			tick(10)
--**		otherwise still on the plant
--*		else
--*			setv(ov00, 3)
--*			pose rand(26, 27)
--*		end
--*		inst()
--*		if from ~= null
--*			targ from
--*			chem(95, .05)
--*			stim_writ targ 79 1
--*
--*			dbg: outs "STIM"
--*
--*		end
--*		slow()
--*		mesg_writ ownr 5
--*	else
--*		dbg: outs "can't be eaten"
--*	end
end)

--***tuba waste timer
scrp(2, 10, 51, 9, function()
	if pose < 6 then
		setv(va00, pose)
		addv(va00, 1)
		pose(va00)
	elseif pose() == 6 then
		pose(12)
		stop()
	elseif pose < 18 then
		setv(va00, pose)
		addv(va00, 1)
		pose(va00)
	else
		kill(ownr)
	end
end)

--**collision
scrp(2, 11, 8, 6, function()
	lock()
	sndc "dr10"
end)






--***REMOVAL
rscr(function()
enum(1, 1, 162, function()
	kill(targ)
end)
enum(2, 3, 16, function()
	kill(targ)
end)
enum(2, 11, 8, function()
	kill(targ)
end)
enum(2, 10, 51, function()
	kill(targ)
end)
end)
