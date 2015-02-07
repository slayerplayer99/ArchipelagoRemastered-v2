#define MAX_CAMPFIRE_WOOD 6
#define MAX_FURNACE_WOOD 4
#define TORCH_LENGTH 6


obj/building/Furnace
	icon = 'temp_furnace.dmi'
	icon_state = "furnace"
	var
		woodLeft = 0
		isLit = 0
	dayFunc = 1

	DblClick()
		if ( !isLit )
			return
		switch (woodLeft)
			if ( 4 to MAX_FURNACE_WOOD )	gameMessage(usr, "The fire is burning brightly.",MESSAGE_FIRE)
			if ( 3 )		gameMessage(usr, "The fire could use some more wood.",MESSAGE_FIRE)
			if ( 2 )		gameMessage(usr,"The fire is burning weakly.",MESSAGE_FIRE)
			if ( 1 )		gameMessage(usr, "The fire is about to burn out.",MESSAGE_FIRE)
	verb/Light()
		set src in view(1)
		if ( woodLeft <= 0 )
			gameMessage(usr,"There is not enough fuel.",MESSAGE_FIRE)
			return
		if ( isLit )
			gameMessage(usr,"The furnace is already lit.",MESSAGE_FIRE)
			return

		usr.Public_message("[usr] lights the furnace.",MESSAGE_FIRE)
		setLit(1)
	proc/setLit(L)
		isLit = L
		luminosity = L*2
		if ( L )
			icon_state = "lit furnace"
		else
			icon_state = "furnace"

	proc/NewDay()
		if ( isLit )
			woodLeft--

		if ( woodLeft <= 0 && isLit )
			woodLeft = 0
			setLit(0)
			Public_message("[src] goes out.",MESSAGE_FIRE)
	proc/addWood(amount)
		if ( woodLeft >= MAX_FURNACE_WOOD )
			return 1
		woodLeft += amount
		if ( woodLeft > MAX_FURNACE_WOOD )
			woodLeft = MAX_FURNACE_WOOD



obj
	Fire
		icon = 'things2.dmi'
		icon_state = "fire"
		dayFunc = 1

		New(l,maker)
			Public_message("[maker] lights a campfire.",MESSAGE_FIRE)
			SetLumin()

			var ret = ..(l)

			for ( var/turf/turf in view(3,src) )
				turf.CheckEnviorment()

			return ret

		var
			woodLeft = MAX_CAMPFIRE_WOOD



		DblClick()
			switch (woodLeft)
				if ( 6 to MAX_CAMPFIRE_WOOD )	gameMessage(usr, "The fire is burning blue and bright.",MESSAGE_FIRE)
				if ( 5 )		gameMessage(usr, "The fire is burning hot and brightly.",MESSAGE_FIRE)
				if ( 4 )		gameMessage(usr, "The fire is burning brightly.",MESSAGE_FIRE)
				if ( 3 )		gameMessage(usr, "The fire could use some more wood.",MESSAGE_FIRE)
				if ( 2 )		gameMessage(usr,"The fire is burning weakly.",MESSAGE_FIRE)
				if ( 1 )		gameMessage(usr, "The fire is about to burn out.",MESSAGE_FIRE)

		proc
			SetFire()
				switch(woodLeft)
					if(6 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire b"
					if(5 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire"
					if(4 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire"
					if(3 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire"
					if(2 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire"
					if(1 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire"
			SetLumin()
				var newLum
				switch (woodLeft)
				//	if (6 to MAX_CAMPFIRE_WOOD)			src.icon_state="fire b" //src.luminosity=7
					if (6 to MAX_CAMPFIRE_WOOD)			newLum = 7
					if (5)			newLum = 6
					if (4)			newLum = 5
					if (3)			newLum = 4
					if (2)			newLum = 3
					if (1)			newLum = 2
				luminosity = newLum

			NewDay()
				woodLeft--
				SetFire()
				if ( isRaining() )
					woodLeft -= 2
				SetLumin()
				if ( woodLeft <= 0 )
					Public_message("The fire dies out.",MESSAGE_FIRE)
					del src
					return

				if ( woodLeft == 2 )
					Public_message("The fire is running out of wood.",MESSAGE_FIRE)
				if ( woodLeft == 1 )
					Public_message("The fire is dying out.",MESSAGE_FIRE)

			isRaining()
				var turf/Turf = loc

				if ( !isturf(loc) )
					return 0
				var obj/lighting/L = Turf.light
				if ( !L )
					return 0
				if ( L.weather )
					return 1


				return 0

			addWood(amount)
				if ( woodLeft >= MAX_CAMPFIRE_WOOD )
					return 1

				woodLeft += amount
				if ( woodLeft > MAX_CAMPFIRE_WOOD )
					woodLeft = MAX_CAMPFIRE_WOOD
				SetLumin()

	item/misc
		MouseDrop(obj/fire)
			if ( !burnable || ( !istype(fire,/obj/Fire) && !istype(fire,/obj/building/Furnace)) )
				return ..()

			if ( !canCombo(fire) )
				return ..()

			if ( fire:addWood(burnable) )
				gameMessage(usr,"The [fire] already has pleanty of fuel",MESSAGE_FIRE)
				return

			usr.Public_message("[usr] adds [src] to the [fire].",MESSAGE_FIRE)
			usr:CheckIQ(IQ_FIND,src)

			del src




mob/player/proc/getHighestLum()
	var L = 0
	for ( var/obj/item/thing in contents )
		if ( thing.luminosity > L )
			L = thing.luminosity
	return L
mob/player/Entered(obj/item/misc/Torch/torch)
	if ( !istype(torch,/obj/item/misc/Torch) )
		return ..()

	if ( torch.luminosity < luminosity )
		return ..()

	luminosity = torch.luminosity
	return ..()

mob/player/Exited(obj/item/misc/Torch/torch)
	if ( !istype(torch,/obj/item/misc/Torch) )
		return ..()

	luminosity = getHighestLum()
	return ..()


obj/item/misc/Torch
	var timeLeft = TORCH_LENGTH

	weight = 2
	icon = 'temp_items.dmi'
	icon_state = "torch"
	luminosity = 3


	New(L)
		var ret = ..(L)

		if ( ismob(loc) )
			loc.Entered(src)
		return ret

	Del()
		if ( ismob(loc) )

			spawn ( 1 )
				loc.Exited(src)
		return ..()

	proc
		HourTick()
			timeLeft--
			if ( timeLeft <= 0 )

				if ( ismob(loc) )
					gameMessage(loc,"Your torch burns out.",MESSAGE_FIRE)

				del src

			if ( timeLeft == 1 )
				luminosity = 2
				loc.Exited(src)