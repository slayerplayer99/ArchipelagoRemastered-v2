#define RAIN_CATCHER_MAX_WATER	6
#define RAIN_CATCHER_ADD_RAIN	3

#define DESTROY_OTHER_TIME 30


obj/building
	Brick_Well
		icon='well.dmi'
		verb/Drink()
			set category ="Survival"
			set src in view(1,usr)
			usr:Drink(CONTENTS_WATER)


	Wooden_Table
		icon_state = "Wooden Table"


	wall
		opacity = 1
		Brick_Wall
			icon = 'temp_buildings.dmi'
			icon_state = "brick wall"
		Wood_Wall
			icon_state = "Wooden Wall"
		Stone_Wall
			icon = 'temp_buildings.dmi'
			icon_state = "stone wall"

	floor/Wood_Floor
		icon_state = "Wooden Floor"
	roof/Wood_Roof
		icon = 'temp_buildings.dmi'
		icon_state = "wood roof"
	window/Wood_Windowed_Wall
		open_icon = "Wooden Window Open"
		close_icon = "Wooden Window"
		icon_state = "Wooden Window"
	door/Wood_Door
		open_icon = "Wooden Door Open"
		close_icon = "Wooden Door"
		icon_state = "Wooden Door"
	Spinning_Wheel
		icon = 'temp_buildings.dmi'
		icon_state = "Spinning Wheel"

	chest/Wooden_Chest
		//icon = 'temp_buildings.dmi'
		icon_state = "Wooden Chest"
		locked_state = "Locked Wooden Chest"

	Wooden_Sign
		var message

		icon = 'temp_buildings.dmi'
		icon_state = "Wooden Sign"
		DblClick()
			if ( usr.name == ownerName && get_dist(usr,src) <= 1 && !usr:isBusy() )
				usr:setBusy(1)
				var responce = alert(usr,"The sign says \"[message]\", do you want to change it?","Sign","Yes","No")

				if ( responce == "No" )
					usr:setBusy(0)
					return
				responce = input(usr,"What is the new message for the sign?","New message") as text
				usr:setBusy(0)
				if ( responce )
					message = responce
					return

			..()
			if ( message )
				usr << "The sign says \"[message]\""

	Rain_Catcher
		icon = 'temp_buildings.dmi'
		icon_state = "Rain Catcher Empty"
		dayFunc = 1
		var
			water

		New(L,M)
			..(L,M)
			NewDay()

		proc
			NewDay()

				if ( isRaining && water < RAIN_CATCHER_MAX_WATER )
					Public_message("The rain catcher fills with rain water.",MESSAGE_GEOGRAPHY)
					water += RAIN_CATCHER_ADD_RAIN
					if ( water > RAIN_CATCHER_MAX_WATER )
						water = RAIN_CATCHER_MAX_WATER
					SetIcon()
			SetIcon()
				if ( water == 0 )
					icon_state = "Rain Catcher Empty"
					return
				if ( water >= RAIN_CATCHER_MAX_WATER )
					icon_state = "Rain Catcher Full"
					return

				icon_state = "Rain Catcher Water"

		verb
			Drink()
				set category ="Survival"
				set src in view(1)

				if ( usr:isBusy() )
					return

				if ( water <= 0 )
					gameMessage(usr,"The raincatcher has no water left.",MESSAGE_DRINKING)
					return

				if ( usr:Drink(CONTENTS_WATER) )
					water--



obj
	Cave_Roof
		icon = 'things2.dmi'
		icon_state = "cave wall"
		luminosity = 1
		invisibility = 1
		density = 0
		layer = MY_MOB_LAYER + 1

	building
		density = 1
		layer = MY_TURF_LAYER
		var
			//mob/player/owner
			ownerName
			builtSkill = 1

		//icon = 'temp_buildings.dmi'
		icon = 'Things.dmi'

		New(location,mob/O)
			if ( O )
				ownerName = O.name
				builtSkill = O:GetSkill(SKILL_BUILDING)
			//if ( !ownerName )

/*				spawn ( 10 )
					//world.log << "[src] : No owner building"
					for ( var/objtype in GetComponentList() )
						//world.log << "Spawning [objtype] in [src]"
						new objtype(src) */

			var ret =  ..(location)

			if ( loc && isturf(loc) )
				loc:CheckEnviorment()
			return ret

		proc/GetComponentList()
			for ( var/datum/buildingInfo/BI in BI_list )


				if ( BI.objType == type )
					return BI.components
			world.log << "[src] Could not find component List"

		Del()
//			for ( var/componentType in getComponents() )
//				new componentType(loc)
//			world << "droppin' components"
			for ( var/obj/component in contents )
//				world << "droppin' [component]"

				if ( istype(component,/obj/item/misc/Mortar) )
					continue
				component.loc = loc
			loc:CheckEnviorment()
			return ..()

		DblClick()
			if ( ownerName )
				usr << "This [src] is owned by [ownerName]"

		verb/Destroy()
			set src in view(1)
			var responce = alert(usr,"Are you sure you want to destroy [src]?","Destroy!","No","Yes")
			if ( responce == "No" )
				return
			if ( ownerName == src.name)
				del src
				return
			else
				if ( usr:isBusy() )
					return
				if ( usr:GetSkill(SKILL_BUILDING) < builtSkill )
					usr << "[src] is too well made for you to be able to destroy."
					return

				usr:Public_message("[usr] starts tearing down [src].",MESSAGE_BUILDING)
				usr:setBusy(1)
				spawn(DESTROY_OTHER_TIME)
					if ( !usr )	return
					usr:setBusy(0)
					if ( !src ) return

					var skill = usr:GetSkill(SKILL_BUILDING)
					var chance = 25+10*(skill-builtSkill)
					chance = AdjustChance(chance)


					if ( prob(chance) )

						usr:Public_message("[usr] tears down [src].",MESSAGE_BUILDING)
						del src

					else
						usr:Public_message("[usr] hurts \himself trying to deconstruct [src].",MESSAGE_BUILDING)
						usr:Hurt(rand(1,5),"headbutts [src] in frustration, and is killed.")



		floor
			density = 0

		roof
			luminosity = 1
			invisibility = 1
			density = 0
			layer = MY_MOB_LAYER + 1


		window
			opacity = 1
			var
				state = 0 // 0 = closed, 1 = open
				open_icon
				close_icon

			DblClick()
				if ( usr:isBusy())
					return
				if ( !(src in view(1,usr)) )
					return
				if ( ownerName == usr.name || !ownerName  )
					if ( state )
						icon_state = close_icon
						state = 0
						opacity = 1
						return
					else
						icon_state = open_icon
						state = 1
						opacity = 0
						return
				else
					return ..()


		door
			opacity = 1
			var
				state = 0 // 0 = closed, 1 = open
				open_icon
				close_icon
				tribe_allow = 0
				//ownerName

		//	New(location,O)
		//		var ret = ..(location,O)
		//		ownerName = O
		//		return ret

			verb
				AllowTribe()
					set src in view(1,usr)
					if ( ownerName != usr.name )
						usr << "This isn't your door."
						return
					if ( tribe_allow )
						tribe_allow = 0
						usr << "This door is no longer accessable to tribe members."
					else
						tribe_allow = 1
						usr << "This door is now accessable to fellow tribe members."


			DblClick() // Interact with door
				if ( usr:isBusy())
					return
				if ( !(src in view(1,usr)) )
					return
				if ( ownerName == usr.name || ( tribe_allow && usr:isInSameTribe(ownerName) ) || !ownerName  )
					if ( state )
						icon_state = close_icon
						density = 1
						state = 0
						opacity = 1
						return
					else
						icon_state = open_icon
						density = 0
						state = 1
						opacity = 0
						return
				else
					return ..()

