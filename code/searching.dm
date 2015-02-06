#define SEARCH_TIME	27

#define MESSAGE_HUNGER		1
#define MESSAGE_THIRST		2
#define MESSAGE_SEARCHING	3
#define MESSAGE_PLUCKING	4
#define MESSAGE_DOOR		5
#define MESSAGE_CONTAINER	6
#define MESSAGE_COMBINING	7
#define MESSAGE_SWIMMING	8
#define MESSAGE_DRINKING	9
#define MESSAGE_CRAFTING	10
#define MESSAGE_FISHING		11
#define MESSAGE_COOKING		12
#define MESSAGE_FARMING		13
#define MESSAGE_GEOGRAPHY	14
#define MESSAGE_BUILDING	15
#define MESSAGE_LUMBERJACK	16
#define MESSAGE_WATERING	17
#define MESSAGE_FIRE 		18
#define MESSAGE_EATING		19
#define MESSAGE_ALCHEMY		20
#define MESSAGE_MINING		21
#define	MESSAGE_SMITHING	22
#define MESSAGE_SMELTING	23
#define MESSAGE_COMBAT		24


turf/proc/Find()
turf/verb/Search()
	set src in view(0)
	set category = "Survival"
	if (usr:isBusy())	return


	var searchName = name
	if ( isItemTypeInList(/obj/plant/Grass,contents) )
		searchName = "the patch of grass"

	usr:Public_message("[usr] starts searching [searchName].",MESSAGE_SEARCHING)
	usr:setBusy(1)
	sleep(SEARCH_TIME)
	if (!usr)	return
	usr:setBusy(0)

	var objType = Find(usr)
	if ( objType )
		var obj/item/newObj = new objType(src)
		gameMessage(usr,"You find [newObj].",MESSAGE_SEARCHING)

		newObj.CleanUpDrop()
		usr:CheckIQ(IQ_FIND,newObj)
		return
	else
		gameMessage(usr,"You don't find anything.",MESSAGE_SEARCHING)


turf/Sand/Find(mob/player/searcher)
	if ( isItemTypeInList(/obj/plant/Grass,contents) )
		return GrassSearch(searcher)


	if ( prob(20) )
		return


	if ( istype(searcher.getEquipedItem(),/obj/item/tool/Pickaxe) || istype(searcher.getEquipedItem(),/obj/item/tool/Hammer) )
		return pick(list(/obj/item/misc/Rock,
						/obj/item/misc/Rock,
						/obj/item/misc/Rock,
						/obj/item/misc/Rock,
						/obj/item/misc/Rock,
						/obj/item/misc/Branch,
						/obj/item/misc/Sand,
						/obj/item/misc/Flint))


	return pick(list(/obj/item/misc/Rock,
					/obj/item/misc/Rock,
					/obj/item/misc/Branch,
					/obj/item/misc/Sand,
					/obj/item/misc/Sand,
					/obj/item/misc/Sand,
					/obj/item/misc/Flint))

turf/Dirt/Find(mob/player/searcher)
	var chance = 45
	if ( istype(searcher.getEquipedItem(),/obj/item/tool/Long_Shovel) )
		chance = 75
	if ( prob(chance) )
		return /obj/item/misc/Clay

turf/proc/GrassSearch(mob/player/searcher)
	var equip = searcher.getEquipedItem()

	var findChance
	var findList

	if ( istype(equip,/obj/item/tool/Shovel) )
		findChance = 80
		findList = list(/obj/item/seed/Corn_Seeds,
						/obj/item/seed/Potato_Seeds,
						/obj/item/seed/Corn_Seeds,
						/obj/item/seed/Potato_Seeds,
						/obj/item/seed/Grass_Seeds)
	else if ( istype(equip,/obj/item/tool/Long_Shovel) )
		findChance = 40
		findList = list(/obj/item/misc/Vine)
	else
		findChance = 70
		findList = list(/obj/item/seed/Corn_Seeds,
						/obj/item/seed/Potato_Seeds,
						/obj/item/seed/Grass_Seeds,
						/obj/item/misc/Vine)


	if ( prob(findChance) )
		return pick(findList)
	else
		return

turf/Grass/Find(S)
	return GrassSearch(S)



