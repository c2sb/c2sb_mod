--* $Id: trapper.cos,v 1.15 2001/02/28 12:47:00 aharman Exp $
--** Set Trapper Game Variables

function trapper.install()
setv (game "Trapper_MaxPop_Global", 100)
setv (game "Trapper_MinPop_Global", 5)
setv (game "Trapper_MaxPop_Local", 10)
setv (game "Trapper_LocalSphere", 500)
setv(va00, 0)
reps(4, function()
	addv(va00, 1)
	new: simp(2, 5, 5, "trapper", 0, 0, 700)
--** Define it's Properties:
--* It can only suffer collisions and abide by gravity.. :-)
	attr(192)
	perm(50)
	aero(2)
	accg(7)
	fric(90)
	elas(50)
--** Drop some here and there
	if va00() == 1 then
		mvto(764, 8900)
	elseif va00() == 2 then
		mvto(1510, 9596)
	elseif va00() == 3 then
		mvto(1410, 9596)
	elseif va00() == 4 then
		mvto(1040, 9596)
	end
	tick(1)
end)

end

scrp(2, 5, 5, 9, function()
--** Age Once
	addv(ov01, 1)
--** If newly created..
	if ov05() == 0 then
--** Wait a little while..
		wait(20)
--** Change your pose..
		pose(1)
--** Change your lifestage.. :-)
		setv(ov05, 1)
	elseif ov05 > 0 and ov05 < 6 then
--** Call: Growth to Adult.
		call (1001, 0, 0)
	end
--** Die if too old and starving
	if ov01 > 2000 and totl (2, 5, 5) > game "Trapper_MinPop_Global" and ov02 < .5 then
		frat(3)
		anim [[38 39 40 41]]
		over()
		frat(50)
		anim [[44 45 46 47 48 49 50 51 52]]
		over()
--** Add nutrients to the local environment.. :-)
		altr (-1, 4, ov02)
		kill(ownr)
	end
--*******************************	
--** State Dependent Behaviour **
--*******************************
	if ov05() == 6 then
--** OV00 @ 0 == Mouth Closed, Hungry.
		if ov00() == 0 then
--** Wait a bit, so it doesn't all go by so quickly!
			wait(100)
--** Call: The Hunger Check
			call (1002, 0, 0)
--** OV00 @ 1 == Mouth Open, Hungry.
		elseif ov00() == 1 then
--** Detect touching pests.
			setv(va00, 0)
			inst()
			etch(2, 14, 0, function()
				if targ() ~= null then
					if carr() ~= game "c3_inventory" then
						if hots() ~= game "c3_inventory" then
							addv(va00, 1)
							if va00() == 1 then
								if ov00() ~= 5 then
									kill(targ)
									targ(ownr)
									snde "trsp"
									frat(1)
									anim [[31 27 24]]
									over()
									setv(va99, 9)
								end
							end
						end
					end
				end
			end)
			slow()
			if va99() == 9 then
--*				dbg: outs "<<TRAPPER>> Insect caught, chewing."
				frat(1)
				anim [[7 9 11]]
				over()
--** Chewing..
				reps (rand(7, 14), function()
					setv (va99, rand(1, 3))
					if va99() == 1 then
						snde "tcw1"
					elseif va99() == 2 then
						snde "tcw2"
					elseif va99() == 3 then
						snde "tcw3"
					end
					frat(1)
					anim [[12 13 14 15 16 17 18]]
					over()
				end)
--** Make it gulp!
				snde "gulp"
--** Add to Energy Store.

				addv(ov02, .15)
				wait(6)
--** Burp!
				setv (va99, rand(1, 3))
				if va99() == 1 then
					snde "burp"
					wait(6)
				end
--** Return to Upright
				frat(1)
				anim [[20 21 22 23 24]]
				over()
--** Wait a bit, so it doesn't all go by so quickly!
				wait(100)
--** Call: The Hunger Check
				call (1002, 0, 0)
			end
--** OV00 @ 2 == Flowering.
		elseif ov00() == 2 then
			if ov70() == 0 then
--*				dbg: outs "<<TRAPPER>> Ready to flower."
				setv(ov70, 1)
				frat(2)
				anim [[25 26 27 28 29 30 31 32]]
				over()
				anim [[33 34 35 36 37]]
				over()
			else
				addv(ov70, 1)
			end
			if ov70 >= 50 then
--*				dbg: outs "<<TRAPPER>> Ready to seed."
				setv(ov00, 3)
			end
--** OV00 @ 3 == Seeding.
		elseif ov00() == 3 then
--** Before seeding, the Trapper checks to make sure the Global Trapper population isn't exceeded.
			if totl (2, 5, 5) < game "Trapper_MaxPop_Global" then
--*				dbg: outs "<<TRAPPER>> Checking local Trapper population."
				rnge (game "Trapper_LocalSphere")
				esee(2, 5, 5, function()
					addv(va00, 1)
				end)
				if va00 > game "Trapper_MaxPop_Local" then
					setv(va70, 1)
				else
					setv (va70, rand(1, 4))
				end
				inst()
				setv(va00, posl)
				setv(va01, post)
--** Create Floating Seeds (edible)
				reps(va70, function()
					subv(ov02, .25)
					new: simp(2, 3, 12, "trapper", 13, 53, 5001)
					attr(67)
					accg (rand(.1, .3))
					perm(50)
					elas(70)
					aero(5)
					fric(90)
					mvsf(va00, va01)
					attr(195)
					frat(2)
					anim [[0 1 2 3 4]]
					velo (rand(-5, 5), rand(-6, -9))
					puhl (-1, 20, 50)
					tick(20)
					slow()
					targ(ownr)
				end)
				targ(ownr)
--*				dbg: outs "<<TRAPPER>> Seeds created."
			end
--*			dbg: outs "<<TRAPPER>> Closing mouth."
			frat(3)
			anim [[38 39 40 41]]
			over()
--** Setting Trapper State as Dormant
			setv(ov00, 4)
--** OV00 @ 4 == Dormant, awaiting death.
		elseif ov00() == 4 then
--** Wait a while.
			wait(1000)
--** Check to see if Trapper Population is low.
			if totl (2, 5, 5) < game "Trapper_MinPop_Global" then
--*				dbg: outs "<<TRAPPER>> Global Trapper population is low, resetting current Trapper."
				setv(ov00, 0)
			else
--*				dbg: outs "<<TRAPPER>> Dying, no longer needed!"
				frat(50)
				anim [[44 45 46 47 48 49 50 51 52]]
				over()
--** Add nutrients to the local environment.. :-)
				altr (-1, 4, ov02)
				kill(ownr)
			end
		end
	end
end)

--** Growth to Adult
scrp(2, 5, 5, 1001, function()
--** Life Stage increase until Adult.
	if ov01() == 30 then
		setv(ov05, 2)
		pose(2)
	elseif ov01() == 50 then
		setv(ov05, 3)
		pose(3)
	elseif ov01() == 70 then
		setv(ov05, 4)
		pose(4)
	elseif ov01() == 90 then
		setv(ov05, 5)
		pose(5)
	elseif ov01() == 120 then
--*		dbg: outs "<<TRAPPER>> Reached Adulthood."
		setv(ov05, 6)
		pose(6)
	end
end)

--** The Hunger Check.
scrp(2, 5, 5, 1002, function()
	if ov02 < 1 then
--*		dbg: outs "<<TRAPPER>> Not enough energy, opening mouth."
		frat(4)
		anim [[25 26 27 28 29 30 31]]
		over()
		setv(ov00, 1)
	else
--*		dbg: outs "<<TRAPPER>> Enough energy stored, flowering."
		setv(ov00, 2)
	end
end)

--** Seed Collision
scrp(2, 3, 12, 6, function()
	snde "dr64"
end)




--** Seed Timer
scrp(2, 3, 12, 9, function()
--** "Age"
	addv(ov70, 1)
--** Change to sprites with seeds at the bottom.
	if ov73() == 0 then
		setv(ov73, 1)
		anim [[5 6 7 8 9 255]]
	end
--** If old enough, start to fall.
	if ov71() == 0 then
		accg(.25)
		anim [[5]]
		setv(ov71, 1)
	end
--** Increment Dormancy Timer (Checks Environment every now and then for suitable conditions for Trappers.)
	addv(ov72, 1)
--** Die if too old! :-)
	if ov70 > 500 then
		setv (va00, grap(posx, posy))
--** Add some Nutrients from the Local Room.
		setv (va20, prop (va00, 4))
		addv(va20, .2)
		prop (va00, 4, va20)
		kill(ownr)
	end
--** Check Local Environment.
	if ov72 >= 50 then
		call (1000, 0, 0)
	end
--** If dormant long enough and the conditions are right then start to grow.
	if ov74() == 999 then
		setv(va00, posl)
		setv(va01, post)
		inst()
		new: simp(2, 5, 5, "trapper", 0, 0, 700)
--** Define it's Properties:
--* It can only suffer collisions and abide by gravity.. :-)
		attr(192)
		perm(50)
		aero(2)
		accg(7)
		fric(90)
		elas(50)
--** Drop some here and there
		mvto(va00, va01)
		tick (rand(10, 20))
		targ(ownr)
		anim [[10]]
		pose(11)
		wait(10)
		pose(12)
		wait(10)
		kill(ownr)
	end
end)

--** Initial Local Environment Check.
scrp(2, 3, 12, 1000, function()
	lock()
	inst()
--** Get Local Room ID
	setv (va00, grap(posx, posy))
--** Check room type
	setv (va01, rtyp (va00))
	if va01() ~= 0 and va01() ~= 8 and va01() ~= 9 then
		setv(va09, 1)
--*	else
--*		dbg: outs "<<TRAPPER SEED>> Not a pleasant area!"
	end
--** Temperature Check (VA10() == 1 at end if check passes).
	if prop (va00, 2) > .3 then
		setv(va10, 1)
--*	else
--*		dbg: outs "<<TRAPPER SEED>> Not hot enough."
	end
--** Light Check (VA11() == 1 at end if check passes).
--** TRAPPER: Can survive on low light, but does need some.
	if prop (va00, 1) > .1 then
		setv(va11, 1)
--*	else
--*		dbg: outs "<<TRAPPER SEED>> Not enough light"
	end
--** Nutrient Check (VA12() == 1 at end if check passes.)
--** TRAPPER: Prefers reasonably fertile conditions. 
	if prop (va00, 4) > .4 then
		setv(va12, 1)
--*	else
--*		dbg: outs "<<TRAPPER SEED>> Not enough nutrients."
	end
--** Water Check (VA13() == 1 at end if check passes.)
--** TRAPPER: Likes a good amount of water. 
	if prop (va00, 3) > .3 then
		setv(va13, 1)
--*	else
--*		dbg: outs "<<TRAPPER SEED>> Not enough water."
	end
--** If the Environment Check passes..
	if va09() == 1 and va10() == 1 and va11() == 1 and va12() == 1 and va13() == 1 then
--** Remove some water from the Local Room.
		setv (va20, prop (va00, 3))
		subv(va20, .1)
		prop (va00, 3, va20)
--** Remove some Nutrients from the Local Room.
		setv (va20, prop (va00, 4))
		subv(va20, .1)
		prop (va00, 4, va20)
--** Reset va00 for new use.
		setv(va00, 0)
--** Check for touching Trappers.
		wait (rand(6, 25))
		inst()
		etch(2, 5, 5, function()
			if targ() ~= null then
				setv(va00, 1)
			end
		end)
--** If touching Trappers found, the seed returns to dormancy.
		if va00() == 1 then
--*			dbg: outs "<<TRAPPER SEED>> Touching Trappers found, returning to dormancy."
			setv(ov72, 0)
			stop()
		else
--*			dbg: outs "<<TRAPPER SEED>> Local Environment suitable for Trappers."
			setv(ov74, 999)
		end
	else
--*		dbg: outs "<<TRAPPER SEED>> Local environment cannot support Trappers, returning to dormancy."
--** Reset Dormancy
		setv(ov72, 0)
	end
end)

rscr(function()
enum(2, 5, 5, function()
	kill(targ)
end)
enum(2, 3, 12, function()
	kill(targ)
end)
scrx(2, 5, 5, 9)
scrx(2, 5, 5, 1001)
scrx(2, 5, 5, 1002)
scrx(2, 3, 12, 9)
scrx(2, 3, 12, 1000)
end)
