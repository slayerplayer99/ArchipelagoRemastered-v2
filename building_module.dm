
#define BUILD_TIME 50

#define BUILDING_HURT 4

#define BI_LIST BI_list

#define COMPONENTS_LOG 		list(/obj/item/material/Logs)
#define COMPONENTS_LOG_NAIL	list(/obj/item/material/Logs,/obj/item/misc/Nails)
#define COMPONENTS_TWO_LOG_NAIL	list(/obj/item/material/Logs,/obj/item/material/Logs,/obj/item/misc/Nails)
#define COMPONENTS_SIX_STONE list(/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/misc/Mortar)
#define COMPONENTS_BRICKS	list(/obj/item/material/Bricks,/obj/item/misc/Mortar)
#define COMPONENTS_RAIN		list(/obj/item/material/Logs,/obj/item/container/bowl/Clay_Bowl,/obj/item/tool/Fishing_Net)
#define COMPONENTS_FOUR_STONE list(/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/material/Stone_Block,/obj/item/misc/Mortar)
#define COMPONENTS_WELL list(/obj/item/tool/Long_Shovel,/obj/item/misc/Rope,/obj/item/misc/Mortar,/obj/item/material/Bricks,/obj/item/material/Bricks,/obj/item/material/Bricks,/obj/item/material/Bricks,/obj/item/material/Bricks)




#define TYPE_WOOD	1
#define TYPE_BRICK	2
#define TYPE_STONE	3



datum/buildingInfo
	var
		objType
		skill
		list/components
		name
		material

var
	list/BI_list

world/proc/initBIlist()
	BI_list = new()
	for ( var/BItype in ( typesof(/datum/buildingInfo) - /datum/buildingInfo ) )
		BI_list += new BItype

//Buildings

datum/buildingInfo
	material = TYPE_WOOD
	skill = 1
	components = COMPONENTS_LOG
	woodWall
		objType = /obj/building/wall/Wood_Wall
		name = "Wooden Wall"
	woodFloor
		objType = /obj/building/floor/Wood_Floor
		name = "Wooden Floor"
	woodDoor
		objType = /obj/building/door/Wood_Door
		name = "Wooden Door"
		components = COMPONENTS_LOG_NAIL
	woodRoof
		objType = /obj/building/roof/Wood_Roof
		skill = 2
		name = "Wooden Roof"
	woodWindow
		objType = /obj/building/window/Wood_Windowed_Wall
		skill = 2
		components = COMPONENTS_LOG_NAIL
		name = "Wooden Windowed Wall"
	spinWheel
		objType = /obj/building/Spinning_Wheel
		skill = 6
		name = "Spinning Wheel"
	woodChest
		objType = /obj/building/chest/Wooden_Chest
		components = COMPONENTS_TWO_LOG_NAIL
		skill = 7
		name = "Wooden Chest"

	woodTable
		objType = /obj/building/Wooden_Table
		skill = 2
		name = "Wooden Table"
	sign
		objType = /obj/building/Wooden_Sign
		skill = 3
		name = "Wooden Sign"
	raincatcher
		objType = /obj/building/Rain_Catcher
		skill = 4
		components = COMPONENTS_RAIN
		name = "Rain Catcher"




	brickWall
		objType = /obj/building/wall/Brick_Wall
		skill = 5
		material = TYPE_BRICK
		components = COMPONENTS_BRICKS
		name = "Brick Wall"
	brickWell
		objType = /obj/building/Brick_Well
		material = TYPE_BRICK
		skill=6
		components = COMPONENTS_WELL
		name = "Brick Well"
	brickFurnace
		objType = /obj/building/Furnace
		skill = 1
		material = TYPE_BRICK
		components = COMPONENTS_BRICKS
		name = "Brick Furnace"


	furnace
		objType = /obj/building/Furnace
		name = "Stone Furnace"
		material = TYPE_STONE
		components = COMPONENTS_SIX_STONE
	stoneWall
		objType = /obj/building/wall/Stone_Wall
		name = "Stone Wall"
		material = TYPE_STONE
		components = COMPONENTS_FOUR_STONE
		skill = 5



proc/getBuildingInfoByName(name)
	for ( var/datum/buildingInfo/BI in BI_LIST )
		if ( name == BI.name )
			return BI

mob/player/proc
	GetConstructableList(materialType)
		var list/list = new()
		var skill = GetSkill(SKILL_BUILDING)

		for ( var/datum/buildingInfo/BI in BI_LIST )
			if ( skill >= BI.skill && materialType == BI.material )
				list += BI.name
/*		list += "Wood Wall"
		list += "Wood Floor"
		list += "Wood Door"
		if ( skill >= 2 )
			list += "Wood Roof"
			list += "Wood Windowed Wall"
*/
		return list

//proc/getBuildingSkill(datum/BuildingInfo)
//	return BI.skill
/*	switch (type)
		if ( /obj/building/wall/Wood_Wall )				return 1
		if ( /obj/building/floor/Wood_Floor )			return 1
		if ( /obj/building/door/Wood_Door )				return 1
		if ( /obj/building/roof/Wood_Roof )				return 1
		if ( /obj/building/window/Wood_Windowed_Wall )	return 1*/

//proc/getBuildType(name)
//	var datum/buildingInfo/BI = getBuildingInfoByName(name)
//	if ( BI )
//		return BI.objType
/*	switch (name)
		if ("Wood Wall")			return /obj/building/wall/Wood_Wall
		if ("Wood Floor")			return /obj/building/floor/Wood_Floor
		if ("Wood Roof")			return /obj/building/roof/Wood_Roof
		if ("Wood Door")			return /obj/building/door/Wood_Door
		if ("Wood Windowed Wall")	return /obj/building/window/Wood_Windowed_Wall*/


//proc/getBuildingComponents(datum/buildingInfo/BI)
//	return BI.components
/*	switch(type)
		if ( /obj/building/door/Wood_Door) 					return list(/obj/item/misc/Logs,
																		/obj/item/misc/Nails)
		if ( /obj/building/window/Wood_Windowed_Wall) 		return list(/obj/item/misc/Logs,
																		/obj/item/misc/Nails)

		else												return list(/obj/item/misc/Logs)
*/



proc
	TypeToName(type)
		var atom/thing = new type
		var ret = thing.name
		del thing
		return ret


turf/proc/isBuildingBlocked(buildType)
	if ( isItemTypeInList(/obj/NoBuildZone,contents) )
		usr << "No buildings are allowed in this area."
		return 1

	if (  isItemTypeInList(/obj/building/floor,contents) )
		if ( ispath(buildType,/obj/building/floor) )
			usr << "There is already a floor there."
			return 1
	if ( isItemTypeInList(/obj/building/roof,contents) )
		if ( ispath(buildType,/obj/building/roof) )
			usr << "There is already a roof there."
			return	1
	if ( hasDenseBuilding() )
		usr << "There is already a building there."
		return 1

	return 0



mob
	player // To make roofs visable by default
		see_invisible = 1
		proc
			BuildMenu(buildMaterial,atom/location)
				while ( !isturf(location) )
					location = location.loc

				var list/selectionList

				if ( istype(buildMaterial,/obj/item/material/Logs) )
					selectionList = GetConstructableList(TYPE_WOOD)
				if ( istype(buildMaterial,/obj/item/material/Stone_Block) )
					selectionList = GetConstructableList(TYPE_STONE)
				if ( istype(buildMaterial,/obj/item/material/Bricks) )
					selectionList = GetConstructableList(TYPE_BRICK)


				selectionList += "Cancel"
				if ( isBusy() )
					return
				setBusy(1)
				var responce = input(src,"What do you want to build?","Build") in selectionList
				setBusy(0)

				if ( responce == "Cancel" )
					return
				TryBuild(responce,location,buildMaterial)



			TryBuild(BuildingName,turf/location,obj/item/material/buildMaterial)
				if ( isBusy() )
					usr << "You are too busy to build that now."
					return
				if ( !istype(getEquipedItem(),buildMaterial.toolType) )
					usr << "You need the proper tool."
					return
				if ( get_dist(src,location) > 1 )
					usr << "You are too far away."
					return
				if ( location.density )
					usr << "You cannot build there."
					return
				//var buildType = getBuildType(BuildingName)
				var datum/buildingInfo/BI = getBuildingInfoByName(BuildingName)


				if ( location.isBuildingBlocked(BI.objType) )
					return

				// check to see if they have the right materials

				var list/neededMaterials = BI.components //getBuildingComponents(BI.objType)
				var list/usedMaterials = new()
				//var obj/item/material

				for ( var/materialType in neededMaterials )
					if ( !FindMaterial(materialType,usedMaterials) )
						usr << "You are missing [TypeToName(materialType)]"
						return

				Build(BI,location,usedMaterials)

			Build(datum/buildingInfo/BI,turf/location,usedMaterials)
				var
					BuildingName = BI.name
					BuildType = BI.objType
				Public_message("[src] starts building a [BuildingName].",MESSAGE_BUILDING)
				setBusy(1)
				sleep(BUILD_TIME)
				if ( !usr )	return
				setBusy(0)
				if ( location.isBuildingBlocked(BuildType) )
					return

				var XP = BI.getXP()

				if ( prob(BI.getChance(src) ) )
					// SUCCESS
					GiveXP(SKILL_BUILDING,XP)

					Public_message("[src] finishes construction of the [BuildingName].",MESSAGE_BUILDING)

					var building = new BuildType(location,src)
					CheckIQ(IQ_MAKE,building)
					for ( var/obj/item in usedMaterials )
						item.Move(building)
						//usr << "[item] moved into [building]"

					return
				else
					// FAILURE
					GiveXP(SKILL_BUILDING,XP*FAILURE_XP_BOOST)
					Public_message("[src] stumbles and fails constructing the [BuildingName].",MESSAGE_BUILDING)
					Hurt(BUILDING_HURT,"is crushed by a falling building!")
					if ( prob(BI.getRuinChance(src)))
						var ruinedMaterial = pick(usedMaterials)
						gameMessage(usr,"Your [ruinedMaterial] is ruined!",MESSAGE_BUILDING)
						del ruinedMaterial
					return





			FindMaterial(type,materialList)
				for ( var/obj/item/thing in contents )
					if ( istype(thing,type) && !( thing in materialList ) )
						materialList += thing
						return 1
				return 0


turf  // Turn roofs invisable or visable when player moves under one
	Entered(mob/player/enterer)
		if ( !istype(enterer,/mob/player) )
			return ..()
		if ( isItemTypeInList(/obj/building/roof,contents) )
			enterer.see_invisible = 0
		if ( isItemTypeInList(/obj/Cave_Roof,contents) )
			enterer.see_invisible = 0
		else
			enterer.see_invisible = 1

		return ..()
	proc
		hasDenseBuilding()
			for ( var/obj/building/building in contents )
				if ( building.density )
					return 1
			return 0

obj/item/material
	MouseDrop(over_obj)
		var /mob/player/player = usr
		if ( !over_obj )
			return ..()
		if ( player.isBusy() )
			return ..()


		if ( !istype(usr:getEquipedItem(),toolType) )
			return ..()
		if ( get_dist(over_obj,player) > 1 )
			return ..()
		if ( loc != player )
			return ..()

		player.BuildMenu(src,over_obj)


	var
		toolType = /obj/item/tool/Hammer
	Stone_Block
		weight = 3
		icon = 'temp_items.dmi'
		icon_state = "stone block"


	Logs
		icon = 'temp_logs.dmi'
		density = 1
		weight = 7.5

	Bricks
		toolType = /obj/item/tool/Spade
		icon = 'temp_items.dmi'
		icon_state = "bricks"
		weight = 5.5

