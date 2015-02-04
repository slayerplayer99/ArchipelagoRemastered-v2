#define INGOT_STATE_UNREFINED	0
#define	INGOT_STATE_REFINED		1
#define INGOT_STATE_MELTED		2

#define MINE_SPEED	50


turf/Cave/DblClick()

	var equip = usr:getEquipedItem()
	if ( !equip )
		return ..()
	if ( usr:isBusy() )
		return ..()
	if ( !istype(equip,/obj/item/tool/Pickaxe) )
		return
	if ( get_dist(usr,src) > 1 )
		return


	usr:Public_message("[usr] starts mining away at the rock.",MESSAGE_MINING)
	usr:setBusy(1)
	sleep(MINE_SPEED)
	if ( !usr )	return
	usr:setBusy(0)

	var chance = AdjustChance( 13 + ( 7 * usr:GetSkill(SKILL_MINING) ) )

	var datum/oreFind/OF = GetOF(usr)

	if ( prob(chance) )

		var obj/item/newOre = new OF.ore(src)

		if ( istype(newOre,/obj/item/ore) )
			gameMessage(usr,"You find some ore.",MESSAGE_MINING)
		else
			gameMessage(usr,"You only manage to mine out rocks.",MESSAGE_MINING)

		newOre.CleanUpDrop()
		usr:CheckIQ(IQ_FIND,newOre)
		usr:GiveXP(SKILL_MINING,OF.findChance * 3 )

	else
		gameMessage(usr,"You don't find anything.",MESSAGE_MINING)
		usr:GiveXP(SKILL_MINING,5)



turf/Cave/proc/GetOF(mob/player/miner)
	var mineSkill = miner.GetSkill(SKILL_MINING)

	var list/OFlist = new()
	var I
	for ( var/datum/oreFind/OF in OreList )
		//world.log << "[OF] Comparing minSkill [OF.minSkill] to skill [mineSkill]"
		if ( OF.minSkill <= mineSkill )

			for ( I = 1, I <= OF.findChance,I++ )
				OFlist += OF

	//for ( var/thing in OFlist )
	//	world.log << "[thing]"

	return pick(OFlist)


var/list/OreList = new()
world/proc/InititlizeOreList()
	for ( var/oretype in ( typesof(/datum/oreFind) - /datum/oreFind ) )
		OreList += new oretype


datum/oreFind
	var
		ore
		minSkill
		findChance = 1

	Stone
		ore = /obj/item/misc/Rock
		minSkill = 1

	Iron
		ore = /obj/item/ore/Iron_Ore
		minSkill = 2
		findChance = 2
	Copper
		ore = /obj/item/ore/Copper_Ore
		minSkill = 3
	Tin
		ore = /obj/item/ore/Tin_Ore
		minSkill = 4
	Coal
		ore = /obj/item/ore/Coal
		minSkill = 5
	Zinc
		ore = /obj/item/ore/Zinc_Ore
		minSkill = 7



obj/item/ore
//	var/smeltSkill

	icon = 'temp_ore.dmi'

	Iron_Ore
		icon_state = "iron"
		weight = 5
//		smeltSkill = 1
		GetSmeltResult(obj/item/ore/other)
			if ( !other )
				return /obj/item/ingot/Iron
			if ( istype(other,/obj/item/ore/Coal) )
				return /obj/item/ingot/Steel
			return null
	Copper_Ore
		icon_state = "copper"
		weight = 3
//		smeltSkill = 3
		GetSmeltResult(obj/item/ore/other)
			if ( istype(other,/obj/item/ore/Tin_Ore) )
				return /obj/item/ingot/Bronze
			if ( istype(other,/obj/item/ore/Zinc_Ore) )
				return /obj/item/ingot/Brass
			return null
	Tin_Ore
		icon_state = "tin"
		weight = 3
//		smeltSkill = 3
		GetSmeltResult(obj/item/ore/other)
			if ( istype(other,/obj/item/ore/Copper_Ore) )
				return /obj/item/ingot/Bronze
			return null
	Coal
		icon_state = "coal"
		weight = 3
//		smeltSkill = 4
		GetSmeltResult(obj/item/ore/other)
			if ( istype(other,/obj/item/ore/Iron_Ore) )
				return /obj/item/ingot/Steel
			return null

	Zinc_Ore
		icon_state = "zinc"
		weight = 4
//		smeltSkill = 5
		GetSmeltResult(obj/item/ore/other)
			if ( istype(other,/obj/item/ore/Copper_Ore) )
				return /obj/item/ingot/Brass
			return null

	proc
		GetSmeltResult()

