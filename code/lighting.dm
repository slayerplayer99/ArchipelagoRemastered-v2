#define	DAY_LENGTH	2750
#define NIGHT_LENGTH 2750
#define RAIN_CHANCE 30

#define HOUR_LENGTH 750


#define LOAD_TICK			5000
#define RUNNING_LOAD_TICK	1500


//#define	DAY_LENGTH	200
//#define NIGHT_LENGTH 200
//#define RAIN_CHANCE 75

//mob/player/verb
	//giveBuildSkill()
		//GiveXP(SKILL_BUILDING,3000)
	//giveCatcherItems()
		//new /obj/item/material/Logs(src)
		//new /obj/item/container/bowl/Clay_Bowl(src)
		//new /obj/item/tool/Fishing_Net(src)

obj
	var
		dayFunc = 0
area
	island

var
	area/island
	tmp/loading
	tmp/displayDelay
	isRaining

/*mob/player/verb
	setDay()
		world.NewDay()
		world.setDay()

	setNight()

		world.setNight() */



world

	proc/loadTurfs()

		if ( loading )
			return

		world.log << "Loading turfs..."
		var tick
		for ( var/turf/Turf in world.contents )
			tick ++
			if ( tick >= LOAD_TICK )


				tick = 0
				sleep 1

			if ( !Turf )
				world.log << "Bad turf in world.contents"
				continue

			Turf.addEdges()
			if ( Turf.loc == island && Turf.type != /turf )
				if ( !Turf.light )
					Turf.light = new /obj/lighting(Turf)

//			if ( tick == 0 )
			//	world.log << "Report: turf: [Turf]: loc ([Turf.x],[Turf.y],[Turf.z]): lighting = [Turf.light]"
//				if ( !Turf.darkness )
//					Turf.darkness = new /obj/darkness(Turf)
//				if ( !Turf )
//					world.log << "Bad turf in world.contents"



//				if ( !Turf.weather )
//					Turf.weather = new /obj/weather(Turf)


		world << output("Loading complete.","act")
		loading = 1
turf
	var
		//obj/weather/weather
		//obj/darkness/darkness
		obj/lighting/light
		indoors = 0
		lit = 0


//	New()
//		var ret = ..()

//		return ret




/*	New()
		var ret = ..()

		loadTick++
		if ( loadTick >= LOAD_TICK )
			loadTick = 0
			loadSpawn++

		spawn(loadSpawn)
			if ( istype(loc,/area/island)  && type != /turf )
				weather = new(src)
				darkness = new(src)
//				world.log << "[src] ([x],[y],[z]) called New()"
		return ret */

	proc
		CheckEnviorment()
			if ( type == /turf )
				return

//			if ( !darkness )
//				darkness = new(src)
//			if ( !weather )
//				weather = new(src)
			if ( !light )
				light = new /obj/lighting(src)


			if ( initial(indoors) != 1 )
				if ( isIndoors() )
					indoors = 1
				else
					indoors = 0

			if ( isLit() )
				lit = 1
			else
				lit = 0

			if ( lit )
				//darkness.icon_state = "blank"
				light.setDark(0)
			if ( indoors )
				light.setWeather(0)
				//weather.icon_state = "blank"
		isIndoors()
			for ( var/obj/building/building in contents )
				if ( istype(building,/obj/building/wall) )
					return 1
				if ( istype(building,/obj/building/roof) )
					return 1
				if ( istype(building,/obj/building/door) )
					return 1
				if ( istype(building,/obj/building/window) )
					return 1
		isLit()
			for ( var/obj/building/building in contents )
				if ( istype(building,/obj/building/roof) )
					return 1
			for ( var/obj/Fire/fire in view(4,src) )
				if ( get_dist(src,fire) < fire.luminosity-1 )
					return 1
			for ( var/mob/AI/insects/Fire_Flies/ffly in view(2,src))
				if(get_dist(src,ffly) < ffly.luminosity)
					return 1

		setLight(L)


			if ( L == 0  && lit )
				L = 1
			light.setDark(!L)
/*			if ( light )
				darkness.icon_state = "blank"
			else
				if ( !lit )
					darkness.icon_state = "dark"
				else
					darkness.icon_state = "blank" */
		setWeather(rain)
			light.setWeather(rain)
/*			if ( !rain )
				weather.icon_state = "blank"
			else
				if ( !indoors )
					weather.icon_state = "rain"
				else
					weather.icon_state = "blank" */




/*obj/weather
	layer = MOB_LAYER+2
	mouse_opacity = 0
	icon = 'weather.dmi'
	icon_state = "blank"
obj/darkness
	layer = MOB_LAYER+3
	mouse_opacity = 0
	icon = 'weather.dmi'
	icon_state = "blank" */

obj/lighting
	var
		dark
		weather
	layer = MY_MOB_LAYER+3
	mouse_opacity = 0
	icon ='weather.dmi'
	icon_state = "blank"
/*	New(turf/loc)
		..(loc)
		if ( !displayDelay )
			displayDelay = 1
			spawn ( 1 )
				displayDelay = 0

			world.log << "new light in [loc] ([loc.x],[loc.y],[loc.z])" */

	proc

		setDark(D)
			dark = D

			setIcon()

		setWeather(W)
			weather = W
			setIcon()

		setIcon()
			if ( !weather && !dark )
				icon_state = "blank"
			if ( weather && !dark )
				icon_state = "rain"
			if ( !weather && dark )
				icon_state = "dark"
			if ( weather && dark )
				icon_state = "dark rain"





world
	proc

		TimeLoop()
			while (1)
				sleep(DAY_LENGTH)
				setNight()
				//CheckTribes()
				sleep(NIGHT_LENGTH)
				setDay()
				NewDay()
				sleep(10)
				world.WorldSave()
		HourLoop()
			while (1)
				sleep(HOUR_LENGTH)
				for ( var/mob/player/player in world.contents )
					player.HourTick()

				for ( var/obj/item/misc/Torch/torch in world.contents )
					torch.HourTick()

		setNight()
			world << output("<B>The Sun Sets.","act")

			var loadTick = 0
			for ( var/turf/Turf in world.contents )
				if ( Turf.type == /turf )
					continue

				loadTick++
				if ( loadTick > RUNNING_LOAD_TICK )
					loadTick = 0
					sleep 1


				Turf.CheckEnviorment()
				Turf.setLight(0)

			island.luminosity = 0

		setDay()
			world << output("<B>The Sun Rises.","act")
			island.luminosity = 1


		NewDay()
			isRaining = prob(RAIN_CHANCE)
			if ( isRaining )
				world << output("<B>It Starts to Rain.","act")


			var loadTick = 0
			for ( var/atom/thing in world.contents )

				loadTick++
				if ( loadTick > RUNNING_LOAD_TICK )
					loadTick = 0
					sleep 1

				if ( isobj(thing) && thing:dayFunc )
					thing:NewDay()

				if ( isturf(thing) && thing.type != /turf )
					thing:CheckEnviorment()
					thing:setLight(1)
					thing:setWeather(isRaining)
