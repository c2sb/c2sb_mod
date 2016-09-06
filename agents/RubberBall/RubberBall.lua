require("/scripts/caos_vm/caos.lua")
RubberBall = {}


--* Script 1 extracted from RubberBall/rubber_ball.agents by Mirality REVELATION

function RubberBall.install()
	inst()
	--*	get creator positioning
	--setv(va00, game("CreatorX"))
	--setv(va01, game("CreatorY"))
	--*	if no values then assume this is C3 only
	if getv(va00) == 0 and getv(va01) == 0 then
	--*		move it to a safe C3 location (just above the incubator area)
		setv(va00, rand(1400, 1550))
		setv(va01, 400)
	end


	for i = 1, 5 do
		new_simp(2, 21, 31, "rubber ball", 2, 0, 5000)
		--new: comp 2 21 31 "rubber ball" 2 0 5000
		--pat: dull 1 "rubber ball" 1 0 0 -1
		bhvr (43)
		attr (199)

		elas (90)
		accg (3)
		aero (1)
		fric (50)
		perm (60)

	--*	mvto mopx mopy

		mvsf(va00, va01)
		velo(rand(-10, 10), rand(-10, 20))
		--part(1)
		--anim {0 1 2 3 4 5 6 255}
		tick(rand(5, 15))
	end
end

--*activate 1
scrp(2, 21, 31, 1, function()
	velo (rand (-10, 10), rand (-30, -15))
	stim_writ (from, 97, 1)
	--part (1)
	--anim {0 1 2 3 4 5 6 255}
	tick (rand (5, 15))
end)
--*activate 2
scrp(2, 21, 31, 2, function()
	velo (rand (-10, 10), rand (-30, -15))
	stim_writ (from, 97, 1)
	--part (1)
	--anim {0 1 2 3 4 5 6 255}
	tick (rand (5, 15))
end)
--*hit
scrp(2, 21, 31, 3, function()
	velo (rand (-10, 10), rand (-30, -15))
	stim_writ (from, 97, 1)
	--part (1)
	--anim {0 1 2 3 4 5 6 255}
	tick (rand (5, 15))
end)
--*drop
scrp(2, 21, 31, 5, function()
	--part (1)
	--anim {0 1 2 3 4 5 6 255}
	tick (rand (5, 15))
end)
--*timer for animation
scrp(2, 21, 31, 9, function()
	inst()
	if fall() == 0 or carr() ~= null then
		--part (1)
		--anim {}
		tick (0)
	end
end)

--*collision
scrp(2, 21, 31, 6, function()
	inst()
	setv(va00, _p1_)
	setv(va01, _p2_)
	absv(va00)
	absv(va01)
	if getv(va00) > 20 or getv(va01) > 20 or rand(0, 10) == 0 then
		sndc "dsqu"
	end
end)

--***REMOVAL
function RubberBall.uninstall()
	enum(2, 21, 31, function()
		kill(targ())
	end)
	scrx(2, 21, 31, 6)
end
