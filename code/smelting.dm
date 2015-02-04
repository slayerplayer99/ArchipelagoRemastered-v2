#define SMELT_TIME 250

#define REFINE_TIME	100



obj/Quarry
	density = 1
	icon = 'temp_quarry.dmi'


obj/item/ore/MouseDrop(obj/building/Furnace/smelter)
	if ( !smelter || !istype(smelter,/obj/building/Furnace) )
		return ..()

	if ( !canCombo(smelter) )
		return

	if ( !smelter.isLit )
		gameMessage(usr,"The [smelter] must be burning hot if you want to get anything done.",MESSAGE_SMELTING)
		return



	var obj/item/ore/otherOre = GetOtherOre(usr)

	var resultType = GetSmeltResult(otherOre)

	if ( !resultType )
		gameMessage(usr,"That combination of ores won't produce anything.",MESSAGE_SMELTING)
		return

	if ( otherOre )
		usr:Public_message("[usr] places [src] and [otherOre] into the [smelter].",MESSAGE_SMELTING)
//		otherOre.Move(smelter)
		del otherOre
	else
		usr:Public_message("[usr] places [src] into the [smelter].",MESSAGE_SMELTING)
	Move(smelter)

	sleep(SMELT_TIME)

	if ( !smelter )
		return

	if ( !usr )
		del src
		return

	var obj/result = new resultType(smelter.loc)
	gameMessage(usr,"Your [result] has finished melting",MESSAGE_SMELTING)
	usr:CheckIQ(IQ_FIND,result)

	del src


obj/item/ingot/MouseDrop(obj/thing)
	if ( !thing || !isobj(thing) )
		return ..()

	if ( usr:isBusy() )
		return ..()

	if ( !canCombo(thing) )
		return ..()

	if ( istype(thing,/obj/Quarry) )
		thing:IngotDrop(src,usr)
		return

	if ( istype(thing,/obj/Spring) )
		thing:IngotDrop(src,usr)
		return
	if ( istype(thing,/obj/building/Furnace) )
		thing:IngotDrop(src,usr)
		return
	return ..()


obj/Quarry/proc/IngotDrop(obj/item/ingot/bar,mob/player/dropper)
	if ( bar.state != INGOT_STATE_UNREFINED )
		return

	var obj/equip = dropper.getEquipedItem()
	if ( !equip || !istype(equip,/obj/item/tool/Hammer) )
		return

	dropper.Public_message("[dropper] starts refining the [bar].",MESSAGE_SMELTING)
	dropper.setBusy(1)
	sleep(REFINE_TIME)

	if ( !dropper )	return

	dropper.setBusy(0)
	if ( !bar )	return


	var itemSkill = bar.smeltSkill

	var chance = AdjustChance(50 + ( 5 * (  dropper.GetSkill(SKILL_SMITHING) - itemSkill ) ) )
	var XP = 5 * itemSkill

	if ( prob(chance) )

		bar.Refine()
		gameMessage(dropper,"You successfully refine the [bar]",MESSAGE_SMELTING)
		dropper.CheckIQ(IQ_MAKE,bar)
		dropper.GiveXP(SKILL_SMITHING,XP)
	else

		gameMessage(dropper,"You hammer away too long and the [bar] is ruined",MESSAGE_SMELTING)
		del bar
		dropper.GiveXP(SKILL_SMITHING,XP*FAILURE_XP_BOOST)

obj/item/tool/Steel_Anvil/proc/IngotDrop(obj/item/ingot/bar,mob/player/dropper)
	if ( bar.state != INGOT_STATE_UNREFINED )
		return

	var obj/equip = dropper.getEquipedItem()
	if ( !equip || !istype(equip,/obj/item/tool/Hammer) )
		return

	dropper.Public_message("[dropper] starts refining the [bar].",MESSAGE_SMELTING)
	dropper.setBusy(1)
	sleep(REFINE_TIME)

	if ( !dropper )	return

	dropper.setBusy(0)
	if ( !bar )	return


	var itemSkill = bar.smeltSkill

	var chance = AdjustChance(50 + ( 5 * (  dropper.GetSkill(SKILL_SMITHING) - itemSkill ) ) )
	var XP = 5 * itemSkill

	if ( prob(chance) )

		bar.Refine()
		gameMessage(dropper,"You successfully refine the [bar]",MESSAGE_SMELTING)
		dropper.CheckIQ(IQ_MAKE,bar)
		dropper.GiveXP(SKILL_SMITHING,XP)
	else

		gameMessage(dropper,"You hammer away too long and the [bar] is ruined",MESSAGE_SMELTING)
		del bar
		dropper.GiveXP(SKILL_SMITHING,XP*FAILURE_XP_BOOST)


obj/building/Furnace/proc/IngotDrop(obj/item/ingot/bar,mob/player/dropper)
	if ( bar.state != INGOT_STATE_REFINED )
		return

	if ( !isLit )
		gameMessage(usr,"The [src] must be burning hot if you want to get anything done.",MESSAGE_SMELTING)
		return


	dropper.Public_message("[dropper] places [bar] into [src] to melt.",MESSAGE_SMELTING)

	bar.Move(src)

	sleep(SMELT_TIME)

	if ( !src )	return
	if ( !bar ) return

	bar.Melt()
	bar.Move(loc)
	if ( dropper )
		gameMessage(dropper,"Your [bar] has melted.",MESSAGE_SMELTING)




obj/building/Brick_Well/proc/IngotDrop(obj/item/ingot/bar,mob/player/dropper)
	if ( bar.state != INGOT_STATE_MELTED )
		return



	dropper.Public_message("[dropper] places [bar] into [src] to cool.",MESSAGE_SMELTING)

	bar.Move(src)

	sleep(SMELT_TIME)

	if ( !src )	return
	if ( !bar ) return

	var barName = bar.name
	bar.Cool()
//	bar.Move(loc)
	if ( dropper )
		gameMessage(dropper,"Your [barName] has cooled.",MESSAGE_SMELTING)


obj/Spring/proc/IngotDrop(obj/item/ingot/bar,mob/player/dropper)
	if ( bar.state != INGOT_STATE_MELTED )
		return



	dropper.Public_message("[dropper] places [bar] into [src] to cool.",MESSAGE_SMELTING)

	bar.Move(src)

	sleep(SMELT_TIME)

	if ( !src )	return
	if ( !bar ) return

	var barName = bar.name
	bar.Cool()
//	bar.Move(loc)
	if ( dropper )
		gameMessage(dropper,"Your [barName] has cooled.",MESSAGE_SMELTING)



obj/item/ore/proc/GetOtherOre(mob/player/owner)
	var list/oreList = new()

	for ( var/obj/item/ore/other in owner.contents )
		if ( other != src )
			oreList += other.name


	oreList += "Nothing"
	oreList -= name

	owner.setBusy(1)

	var result = input(owner,"Select an ore to combine [src] with.","Smelting") in oreList
	owner.setBusy(0)

	if ( !result || result == "Nothing" )
		return

	for ( var/obj/item/ore/ore in owner.contents )
		if ( ore.name == result )
			return ore

	world.log << "Could not find ore [result] in inventory"
	return


obj/item/ingot
	icon = 'temp_ingot.dmi'
	icon_state = "unrefined"
	var
		state = INGOT_STATE_UNREFINED
		metalType
		smeltSkill
	Iron
		weight = 4
		smeltSkill = 1
		metalType = /obj/item/metal/Iron_Bar
	Bronze
		weight = 5
		smeltSkill = 3
		metalType = /obj/item/metal/Bronze_Bar
	Steel
		weight = 6
		smeltSkill = 5
		metalType = /obj/item/metal/Steel_Bar
	Brass
		weight = 5
		smeltSkill = 7
		metalType = /obj/item/metal/Brass_Bar

	New(l)
//		world.log << "New [src] created"
		setName()
		return ..(l)

	proc/Refine()
		if ( state != INGOT_STATE_UNREFINED )
			return
		state = INGOT_STATE_REFINED
		setName()
		icon_state = "refined"
		//icon_state = "refined [icon_state]"

	proc/Melt()
		if ( state != INGOT_STATE_REFINED )
			return
		state = INGOT_STATE_MELTED
		setName()
		//icon_state = "melted [icon_state]"
		icon_state = "melted"

	proc/setName()
		//world.log << "[src] called setName(), state = [state]"
		name = initial(name)
		if ( state == INGOT_STATE_UNREFINED )
			name = "Unrefined [name] Ingot"
		if ( state == INGOT_STATE_REFINED )
			name = "Wrought [name] Ingot"
		if ( state == INGOT_STATE_MELTED )
			name = "Melted [name] Ingot"

	//	world.log << "  new name = [name]"

	proc/Cool()
		if ( state != INGOT_STATE_MELTED )
			return
		var spawnpoint = loc
		if ( isobj(spawnpoint) )
			spawnpoint = loc.loc

		var obj/item/newBar = new metalType(spawnpoint)
		newBar.weight = weight
		del src
