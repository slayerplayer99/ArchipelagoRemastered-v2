#define FERTILIZER_ALGAE 1
#define FERTILIZER_VEGETABLE_MATTER 2
#define FERTILIZER_HUMUS 3


#define PLANT_SPEED 30
#define CROP_GROW_SPEED 250
#define PLOW_SPEED 40
#define GATHER_SPEED 40
#define WORMS_SPEED 30

#define PLOW_XP 2
#define COMPOST_XP 5
#define GATHER_XP 4
#define MATURE_XP 15
#define FERTILIZE_XP 3

turf
	Sand

		// Plow Land
		DblClick()
			if ( get_dist(src,usr) > 1 )
				return
			if ( usr:isBusy() )
				return
			if ( !istype(usr:getEquipedItem(),/obj/item/tool/Hoe) )
				return

			for ( var/obj/thing in contents )
				if ( istype(thing,/obj/Plowed_Land) )
					return
				if ( istype(thing,/obj/Tree) )
					return
				if ( istype(thing,/obj/building) )
					return
				if ( istype(thing,/obj/Spring) )
					return
				if ( istype(thing,/obj/Compost) )
					return
				if ( istype(thing,/obj/Quarry) )
					return

			gameMessage(usr,  "You start plowing the sand.", MESSAGE_FARMING )
			usr:setBusy(1)

			sleep(PLOW_SPEED)
			if ( !usr )	return
			usr:setBusy(0)

			if ( isItemTypeInList(/obj/Plowed_Land,contents) )
				return


			usr:Public_message("[usr] plows the land.",MESSAGE_FARMING)

			usr:GiveXP(SKILL_FARMING,PLOW_XP)

			new /obj/Plowed_Land(src)

			usr:CheckIQ(IQ_MAKE,/obj/Plowed_Land)
			if ( rand(1,6) == 6 )
				var newSeedType = pick(list(/obj/item/seed/Corn_Seeds,
											/obj/item/seed/Potato_Seeds,
											/obj/item/seed/Corn_Seeds,
											/obj/item/seed/Potato_Seeds,
											/obj/item/seed/Grass_Seeds))

				var newSeeds = new newSeedType(src)
				gameMessage(usr, "You found some [newSeeds] while plowing.",MESSAGE_FARMING )
				usr:CheckIQ(IQ_FIND,newSeeds)
obj
	Compost
		icon = 'temp_fertilizer.dmi'
		icon_state = "compost"


		var
			worms = 5
		New(l,maker)
			if ( maker )
				maker:GiveXP(SKILL_FARMING,COMPOST_XP)
				Public_message("[maker] creates a pile of compost.",MESSAGE_COMBINING)
			return ..(l)

		DblClick()
			if ( get_dist(src,usr) > 1 )
				return
			if ( usr:isBusy() )
				return
			if ( !istype(usr:getEquipedItem(),/obj/item/tool/Shovel) )
				return

			usr:Public_message("[usr] starts searching through the compost.",MESSAGE_SEARCHING)
			usr:setBusy(1)

			spawn(WORMS_SPEED)

				if ( !usr )	return

				usr:setBusy(0)
				if ( !src )	return

				gameMessage(usr,  "You find earthworms!",MESSAGE_SEARCHING)

				var /obj/item/misc/Earthworm/worm = new(usr.loc)
				usr:CheckIQ(IQ_FIND,worm)
				//worm.Move(usr)
				worm.CleanUpDrop()

				worms--
				if ( worms <= 0 )
					usr:Public_message("The compost pile falls apart into humus.",MESSAGE_GEOGRAPHY)
					new /obj/item/fertilizer/Humus(loc)
					new /obj/item/fertilizer/Humus(loc)
					del src



	Plowed_Land
		layer = MY_TURF_LAYER+4
		icon = 'temp_plowed.dmi'
		var
			fertilizer

		// Fill plowed Land
		New(L)
			var ret = ..(L)
			spawn(2)
				for ( var/obj/thing in contents )
					del thing
			return ret
		DblClick()
			if ( get_dist(src,usr) > 1 )
				return
			if ( usr:isBusy() )
				return
			if ( !istype(usr:getEquipedItem(),/obj/item/tool/Long_Shovel) )
				return

			gameMessage(usr, "You start filling the land with sand.",MESSAGE_FARMING)
			usr:setBusy(1)

			sleep(PLOW_SPEED)
			if ( !usr )	return
			usr:setBusy(0)

			usr:Public_message("[usr] fills the land with sand.",MESSAGE_FARMING)
			usr:CheckIQ(IQ_FIND,/obj/Plowed_Land)
			del src
		proc
			isEmpty()
				if ( contents.len )
					return 0
				for ( var/obj/thing in loc.contents )
					if ( istype(thing,/obj/plant) )
						return 0
					if ( istype(thing,/obj/growingPlant) )
						return 0

				return 1

	plant
		var
			plant_left
			plant_obj
			extra_crops

		icon = 'temp_plants.dmi'
		Rice_Plant
			icon_state = "rice"
			plant_left = 2
			plant_obj = /obj/item/food/plant/vegetable/Rice
		Cotton_Plant
			icon_state = "cotton"
			plant_left = 5
			plant_obj = /obj/item/misc/Cotton
		Wheat_Plant
			icon_state = "wheat"
			plant_left = 3
			plant_obj = /obj/item/misc/Straw
		Fern
			icon_state = "fern"
			plant_left = 2
			plant_obj = /obj/item/misc/Vine
		Rosemary_Patch
			icon_state = "rosemary"
			plant_left = 4
			plant_obj = /obj/item/food/plant/spice/Rosemary
		Mint_Patch
			icon_state = "mint"
			plant_left = 4
			plant_obj = /obj/item/food/plant/spice/Mint
		Thyme_Patch
			icon_state = "mint"
			plant_left = 4
			plant_obj = /obj/item/food/plant/spice/Thyme
		Mushroom_Patch
			icon_state = "mushroom"
			plant_left = 2
			plant_obj = /obj/item/food/plant/mushroom/Mushroom
		Strawberry_Bush
			icon_state = "strawberry"
			plant_left = 4
			plant_obj = /obj/item/food/plant/berry/Strawberry
		Blueberry_Bush
			icon_state = "blueberry"
			plant_left = 4
			plant_obj = /obj/item/food/plant/berry/Blueberry
		Grass
			icon_state = "grass"
			DblClick()
				if ( get_dist(src,usr) > 1 )
					return
				if ( usr:isBusy() )
					return
				if ( !istype(usr:getEquipedItem(),/obj/item/tool/Long_Shovel) )
					return
				usr:Public_message("[usr] starts digging out the grass patch.",MESSAGE_FARMING)

				usr:setBusy(1)
				sleep(PLOW_SPEED)
				if ( !usr ) return
				usr:setBusy(0)
				if ( !src )	return
				gameMessage(usr,"You dig out the rest of the grass.",MESSAGE_FARMING)
				del src



		DblClick()
			if ( !plant_obj )
				return

			if ( get_dist(src,usr) > 1 )
				return
			if ( usr:isBusy() )
				return
			if ( !istype(usr:getEquipedItem(),/obj/item/tool/Shovel) )
				return

			gameMessage(usr,"You start gathering from the [src]",MESSAGE_FARMING)
			usr:setBusy(1)

			spawn(GATHER_SPEED)
				if ( !usr )	return
				usr:setBusy(0)
				if ( !src ) return


				var /obj/plant = new plant_obj(loc)
				plant.Move(usr)

				usr:Public_message("[usr] gathers [plant] from [src]",MESSAGE_FARMING)
				usr:GiveXP(SKILL_FARMING,GATHER_XP)
				usr:CheckIQ(IQ_FIND,plant)

				plant_left--
				if ( plant_left <= 0 )
					usr:Public_message("[src] is destroyed.",MESSAGE_GEOGRAPHY)
					del src

		dayFunc = 1
		proc/AddPlants(mob/player/planter)
			if ( !planter )	return

			var skill = planter.GetSkill(SKILL_FARMING)
			var chance = AdjustChance(skill*10)

			if ( prob(chance) )
				plant_left++
				extra_crops++
				if ( skill > 5 )
					plant_left++
					extra_crops++

		proc/NewDay()
			if ( !plant_obj || !plant_left )
				return

			var max = initial(plant_left)
			max+=extra_crops

			if ( plant_left < max )
				plant_left++


	growingPlant
		icon = 'temp_plants.dmi'
		dayFunc = 1
		var
			growTimeNeeded
			needWater = 1
			noWater = 0
			maturePlantList
			mob/player/owner
			ownerName

		Shrub
			icon_state = "shrub"
			growTimeNeeded = 5
			maturePlantList = list(/obj/plant/Blueberry_Bush,
								   /obj/plant/Strawberry_Bush)
		Spices
			icon_state = "spices"
			growTimeNeeded = 4
			maturePlantList = list(/obj/plant/Rosemary_Patch,
								   /obj/plant/Mint_Patch,
								   /obj/plant/Thyme_Patch)
		Mushroom
			icon_state = "mushroom"
			growTimeNeeded = 3
			maturePlantList = list(/obj/plant/Mushroom_Patch)

		proc

			setOwner(mob/player/O)
				owner = O
				ownerName = O.name

			findOwner()
				if ( owner )
					return
				if ( !ownerName )
					return
				owner = world.FindPlayer(ownerName)


			// Call this when plant is watered
			// waterer is the person who waters it
			// return 1 if the plant is watered, returns 0 if it is not
			Watered(mob/player/waterer)
				if ( !needWater )
					waterer << "[src] does not need any more water today."
					return 0

				waterer.Public_message("[waterer] waters the [src]",MESSAGE_WATERING)
				usr:CheckIQ(IQ_FIND,src)

				needWater = 0
				return 1


			// Called by time functions at the start of a new day
			NewDay()
				if ( !owner )	findOwner()


				if ( !needWater )
					noWater = 0
					needWater = 1
					growTimeNeeded--
					if ( growTimeNeeded <= 0 )
						Mature()
						return
				else
					if ( noWater )
						if ( owner )
							gameMessage(owner, "Your [src] has died from dehydration.",MESSAGE_GEOGRAPHY)
						del src
						return
					noWater = 1

				if ( isRaining )
					needWater = 0
					noWater = 0
					Public_message("The [src] is watered by the rain.",MESSAGE_GEOGRAPHY)


			Mature()
				if ( !owner )	findOwner()
				var newType = pick(maturePlantList)
				if ( newType )
					var newPlant = new newType(loc)
					if ( owner )
						gameMessage(owner, "Your [src] has matured into a [newPlant]",MESSAGE_FARMING)
						usr:CheckIQ(IQ_MAKE,newPlant)
						owner.GiveXP(SKILL_FARMING,MATURE_XP)
						if ( istype(newPlant,/obj/plant) )
							newPlant:AddPlants(owner)
					del src
				else
					world.log << "Could not find newplant type for [src]"
					del src


	item


		seed


			var
				food_obj
				humus_seed
				vegetable_seed
				algae_seed
				farm_skill


			MouseDrop(obj/Plowed_Land/over_obj)

				// Don't plant unless seed is in the dragger's inventory
				if ( loc != usr )
					return


				if ( !over_obj )
					return
				 // return if it's not plowed land or too far away
				if ( !istype(over_obj,/obj/Plowed_Land) || get_dist(over_obj,usr) > 1 )
					return

				if ( !istype(usr:getEquipedItem(),/obj/item/tool/Shovel) )
					return

				if ( usr:isBusy() )
					return

				if ( !over_obj.isEmpty() )
					usr << "Something has already been planted here."
					return

				gameMessage(usr, "You start planting [src]", MESSAGE_FARMING)
				usr:setBusy(1)

				Move(over_obj)

				spawn(PLANT_SPEED)
					if ( !usr )
						del src
						return
					usr:setBusy(0)
					if ( !over_obj )
						return
					if ( !src )
						return


					usr:Public_message("[usr] has planted [src]",MESSAGE_FARMING)


					var XP = GetPlantXP()

					usr:GiveXP(SKILL_FARMING,XP)

					Plant(usr,over_obj)

					if ( over_obj )
						over_obj.fertilizer = 0

			proc
				BonusHumus(owner,spawnpoint)
					if ( rand(1,6) < 6 )
						return

					gameMessage(owner, "You found some humus.",MESSAGE_FARMING)
					usr:CheckIQ(IQ_FIND,/obj/item/fertilizer/Humus)
					new /obj/item/fertilizer/Humus(spawnpoint)


				BonusSeeds(owner,fertilizer_type,spawnpoint)
				//	world << "BonusSeeds Called: owner = [owner], fert = [fertilizer_type]"
					var seedType
					switch ( fertilizer_type )
						if ( FERTILIZER_ALGAE )
							seedType = algae_seed
						if ( FERTILIZER_HUMUS )
							seedType = humus_seed
						if ( FERTILIZER_VEGETABLE_MATTER )
							seedType = vegetable_seed

					if ( !seedType )
						return
					var seeds = new seedType(spawnpoint)
					gameMessage(owner, "You found some [seeds].",MESSAGE_FARMING)
					usr:CheckIQ(IQ_FIND,seeds)


				Plant(mob/player/planter,obj/Plowed_Land/land)

					var fert = land.fertilizer
					spawn (CROP_GROW_SPEED)
						if ( !land )
							return

						if ( !planter )
							return

						if ( prob(GerminateChance(planter,fert))  )

							planter.GiveXP(SKILL_FARMING,GetGrowXP() )
							gameMessage(planter, "Your [src] has have sprouted",MESSAGE_FARMING)
							var food = new food_obj(land.loc)
							usr:CheckIQ(IQ_FIND,food)
							if ( istype(food,/obj/growingPlant) )
								food:setOwner(planter)
							else
								if ( istype(food,/obj/item/food) && prob(GetDoubleChance(planter,fert)) )
									new food_obj(land.loc)

							BonusHumus(planter,land.loc)
							BonusSeeds(planter,fert,land.loc)
							if ( istype(food,/obj/plant) )
								food:AddPlants(planter)
							if ( istype(food,/obj/item/food/plant) )
								food:AddFoodValue(planter)
						else
							gameMessage(planter,"Your [src] fails to germinate",MESSAGE_FARMING)
							planter.GiveXP(SKILL_FARMING,GetGrowXP()*FAILURE_XP_BOOST)
							if ( prob(50) )
								BonusSeeds(planter,fert,land.loc)
							if ( prob(50) )
								BonusHumus(planter,land.loc)
							if ( prob(50) )
								new type(land.loc)


						del src

		fertilizer
			MouseDrop(obj/Plowed_Land/over_obj)

				if ( loc != usr )
					return
				if ( !over_obj )
					return
				 // return if it's not plowed land or too far away
				if ( !istype(over_obj,/obj/Plowed_Land) || get_dist(over_obj,usr) > 1 )
					return ..()

				if ( over_obj.fertilizer )
					usr << "The land is already fertilized."
					return


				switch (type)
					if ( /obj/item/fertilizer/Humus )
						over_obj.fertilizer = FERTILIZER_HUMUS
					if ( /obj/item/fertilizer/Algae )
						over_obj.fertilizer = FERTILIZER_ALGAE
					if ( /obj/item/fertilizer/Vegetable_Matter )
						over_obj.fertilizer = FERTILIZER_VEGETABLE_MATTER

				usr:Public_message("[usr] has fertilized the land with [src]",MESSAGE_FARMING)
				usr:CheckIQ(IQ_MAKE,src)
				usr:GiveXP(SKILL_FARMING,FERTILIZE_XP)

				del src




		seed
			weight = 1
			icon = 'Things.dmi'
			icon_state = "Seeds"
			farm_skill = 1
			Corn_Seeds
				food_obj = /obj/item/food/plant/vegetable/Corn
				humus_seed = /obj/item/seed/Rice_Seeds
				farm_skill = 2
			Rice_Seeds
				food_obj = /obj/plant/Rice_Plant
				humus_seed = /obj/item/seed/Cotton_Seeds
				farm_skill = 3
			Cotton_Seeds
				food_obj = /obj/plant/Cotton_Plant
				algae_seed = /obj/item/seed/Fern_Spores
				farm_skill = 4
			Fern_Spores
				food_obj = /obj/plant/Fern
				humus_seed = /obj/item/seed/Spices_Seeds
				vegetable_seed = /obj/item/seed/Mushroom_Spores
				farm_skill = 4
			Spices_Seeds
				food_obj = /obj/growingPlant/Spices
				farm_skill = 5
			Mushroom_Spores
				food_obj = /obj/growingPlant/Mushroom
				farm_skill = 6
			Potato_Seeds
				food_obj = /obj/item/food/plant/vegetable/Potato
				humus_seed = /obj/item/seed/Wheat_Seeds

			Wheat_Seeds
				food_obj = /obj/plant/Wheat_Plant
				algae_seed = /obj/item/seed/Shrub_Seeds
				farm_skill = 3
			Shrub_Seeds
				food_obj = /obj/growingPlant/Shrub
				farm_skill = 5

			Grass_Seeds
				food_obj = /obj/plant/Grass
				farm_skill = 4

		fertilizer
			icon = 'temp_fertilizer.dmi'
			weight = 3
			Humus
				icon_state = "humus"
			Vegetable_Matter
				icon_state = "matter"
			Algae
				icon_state = "algae"



obj/item/food/plant/proc/AddFoodValue(mob/player/planter)
	if ( !planter ) return
	var skill = planter.GetSkill(SKILL_FARMING)
	var chance = AdjustChance(skill*6)

	if ( prob(chance) )
		name = "Healthy [name]"
		FoodValue++
		if ( skill > 5 && prob(50) )
			FoodValue++
			name = "Perfect [initial(name)]"


