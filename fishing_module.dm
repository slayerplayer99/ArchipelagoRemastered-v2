#define	NET_MISS_XP		4
#define HARPOON_MISS_XP	4
#define ROD_MISS_XP		8

#define WORM_XP			2

#define FISH_TIME_NET		50
#define FISH_TIME_HARPOON	60
#define FISH_TIME_ROD		70

#define TOOL_ROD	1
#define TOOL_NET	2
#define TOOL_HARPOON	3

#define ALGAE_CHANCE	25

turf/Water
	DblClick()
		var equip = usr:getEquipedItem()
		if ( !equip )
			return ..()
		if ( usr:isBusy() )
			return ..()
		if ( istype(equip,/obj/item/tool/Fishing_Net) || istype(equip,/obj/item/tool/Harpoon) || istype(equip,/obj/item/tool/Fishing_Rod) )
			Fish_Check(usr,equip)
			return


turf/Shoals
	DblClick()
		var equip = usr:getEquipedItem()
		if ( !equip )
			return ..()
		if ( usr:isBusy() )
			return ..()
		if ( istype(equip,/obj/item/tool/Fishing_Net) || istype(equip,/obj/item/tool/Harpoon) || istype(equip,/obj/item/tool/Fishing_Rod) )
			Fish_Check(usr,equip)
			return

turf
	proc/Fish_Check(mob/player/fisher,obj/item/tool/tool)
		if ( istype(tool,/obj/item/tool/Fishing_Rod) )
			if ( get_dist(src,fisher) > 4 || get_dist(src,fisher) < 2  )
				return
		else if ( get_dist(src,fisher) > 1 )
			return

		var
			message
			skillLevel
			missXP
			findChance
			fishType
			fishTime
			algaeCheck

		skillLevel = fisher.GetSkill(SKILL_FISHING)

		var worm
		if ( istype(tool,/obj/item/tool/Fishing_Rod) )
			worm = tool:worm
			tool:worm = 0
			tool:SetIcon()


		if ( istype(tool,/obj/item/tool/Fishing_Net) )
			message = "[fisher] throws out a fishing net."
			missXP = NET_MISS_XP
			findChance = FindChance(skillLevel,TOOL_NET)
			fishType = FindFish(skillLevel,TOOL_NET)
			fishTime = FISH_TIME_NET
			algaeCheck = 1
		if ( istype(tool,/obj/item/tool/Harpoon) )
			message = "[fisher] wades into the water, harpoon at the ready."
			missXP = HARPOON_MISS_XP
			findChance = FindChance(skillLevel,TOOL_HARPOON)
			fishType = FindFish(skillLevel,TOOL_HARPOON)
			fishTime = FISH_TIME_HARPOON
		if ( istype(tool,/obj/item/tool/Fishing_Rod) )
			message = "[fisher] throws out a fishing line."
			missXP = ROD_MISS_XP
			findChance = FindChance(skillLevel,TOOL_ROD,worm)
			fishType = FindFish(skillLevel,TOOL_ROD,worm)
			fishTime = FISH_TIME_ROD

		fisher.Public_message(message,MESSAGE_FISHING)

		fisher.setBusy(1)
		sleep(fishTime)
		if ( !fisher )
			return
		fisher.setBusy(0)
		if ( !tool || fisher.getEquipedItem() != tool )
			return


		if ( prob(findChance) )
			var obj/item/food/meat/fish/newFish = new fishType(fisher.loc)

			gameMessage(fisher,"You catch a [newFish].",MESSAGE_FISHING)
			fisher:CheckIQ(IQ_FIND,newFish)
			newFish.Move(fisher)
			fisher.GiveXP(SKILL_FISHING,newFish.fishXP)
		else
			gameMessage(fisher,"You can't manage to catch anything.",MESSAGE_FISHING)
			fisher.GiveXP(missXP)

		if ( algaeCheck && prob(ALGAE_CHANCE) )
			var algae = new /obj/item/fertilizer/Algae(fisher.loc)
			algae:CleanUpDrop()
			gameMessage(fisher,"You find some algae.",MESSAGE_SEARCHING)
			fisher:CheckIQ(IQ_FIND,/obj/item/fertilizer/Algae)


	proc/FindChance(skill,toolType,worm)
		if ( worm )
			skill += 2
		switch ( toolType )
			if ( TOOL_NET )
				return AdjustChance( 40 + skill * 10 )
			if ( TOOL_HARPOON )
				return AdjustChance( 30 + skill * 7 )
			if ( TOOL_ROD )
				return AdjustChance( 30 + skill * 5 )

	proc/FindFish(skill,toolType,worm)

		if ( worm )
			skill += 2

		var list/findList = new()

		switch (toolType)
			if ( TOOL_NET )
				findList += /obj/item/food/meat/fish/Oyster

				if ( skill >= 2 )	findList += /obj/item/food/meat/fish/Sardine
				if ( skill >= 2 )	findList += /obj/item/food/meat/fish/Shrimp
				if ( skill >= 3 )	findList += /obj/item/food/meat/fish/Anchovy
				if ( skill >= 4 )	findList += /obj/item/food/meat/fish/Crab
				if ( skill >= 4 )	findList += /obj/item/food/meat/fish/Minnow
				if ( skill >= 6 )	findList += /obj/item/food/meat/fish/Octopus
			if ( TOOL_HARPOON )
				findList += /obj/item/food/meat/fish/Gold_Fish
				findList += /obj/item/food/meat/fish/Trout

				if ( skill >= 2 )	findList += /obj/item/food/meat/fish/Pike
				if ( skill >= 2 )	findList += /obj/item/food/meat/fish/Bass
				if ( skill >= 3 )	findList += /obj/item/food/meat/fish/Blue_Gill
				if ( skill >= 3 )	findList += /obj/item/food/meat/fish/Black_Bass
				if ( skill >= 4 )	findList += /obj/item/food/meat/fish/Salmon
				if ( skill >= 4 )	findList += /obj/item/food/meat/fish/Tuna
				if ( skill >= 5 )	findList += /obj/item/food/meat/fish/Herring
				if ( skill >= 6 )	findList += /obj/item/food/meat/fish/Marlin
			if ( TOOL_ROD )
				findList += /obj/item/food/meat/fish/Eel
				findList += /obj/item/food/meat/fish/Rainbow_Trout

				if ( skill >= 3 )	findList += /obj/item/food/meat/fish/Swordfish
				if ( skill >= 5 )	findList += /obj/item/food/meat/fish/Shark
				if ( skill >= 7 )	findList += /obj/item/food/meat/fish/Blue_Shark

		return pick(findList)


/* From worst to best
Harpoon : Gold Fish, Trout, Pike, Bass, Blue Gill, Black Bass, Salmon, Tuna, Herring, Marlin
Fishing Net: Oyster, Sardine, Shrimp, Anchovy, Crab, Minnow, Octopus
Fishing Rod: Eel, rainbow trout, Swordfish, Shark, BlueShark
*/

obj/item/food/meat/fish

	var
		fishXP = 4

	weight = 4

	Gold_Fish
		icon_state = "Gold Fish"
		weight = 1
		FoodValue = 2
		CookingSkill = 1
	Trout
		icon_state = "Trout"
		weight = 4
		FoodValue = 3
		CookingSkill = 2
	Pike
		icon_state = "Pike"
		weight = 7
		FoodValue = 4
		CookingSkill = 3
	Bass
		icon_state = "Bass"
		weight = 6
		fishXP = 6
		FoodValue = 4
		CookingSkill = 3
	Blue_Gill
		icon_state = "Blue Gill"
		weight = 4
		fishXP = 6
		FoodValue = 4
		CookingSkill = 4
	Black_Bass
		icon_state = "Black Bass"
		weight = 4
		fishXP = 8
		FoodValue = 5
		CookingSkill = 4
	Salmon
		icon_state = "Salmon"
		weight = 4
		fishXP = 8
		FoodValue = 5
		CookingSkill = 4
	Tuna
		icon_state = "Tuna"
		weight = 12
		fishXP = 12
		FoodValue = 6
		CookingSkill = 5
	Herring
		icon_state = "Herring"
		weight = 6
		fishXP = 15
		FoodValue = 6
		CookingSkill = 4
	Marlin
		icon_state = "Marlin"
		weight = 11
		fishXP = 30
		FoodValue = 7
		CookingSkill = 5

	Oyster
		icon_state = "Oyster"
		weight = 2
		FoodValue = 2
		CookingSkill = 1
	Sardine
		icon_state = "Sardine"
		weight = 1
		FoodValue = 2
		CookingSkill = 2
	Shrimp
		icon_state = "Shrimp"
		weight = 2
		fishXP = 6
		FoodValue = 3
		CookingSkill = 2
	Anchovy
		icon_state = "Anchovy"
		weight = 1
		fishXP = 6
		FoodValue = 3
		CookingSkill = 2
	Crab
		icon_state = "Crab"
		weight = 3
		fishXP = 10
		FoodValue = 4
		CookingSkill = 4
	Minnow
		icon_state = "Minnow"
		weight = 1
		fishXP = 10
		FoodValue = 4
		CookingSkill = 3
	Octopus
		icon_state = "Octopus"
		weight = 6
		fishXP = 20
		FoodValue = 6
		CookingSkill = 5

	Eel
		icon_state = "Eel"
		weight = 4
		fishXP = 6
		FoodValue = 3
		CookingSkill = 1
	Rainbow_Trout
		icon_state = "Rainbow Trout"
		weight = 4
		fishXP = 6
		FoodValue = 4
		CookingSkill = 2
	Swordfish
		icon_state = "Swordfish"
		weight = 10
		fishXP = 10
		FoodValue = 6
		CookingSkill = 4
	Shark
		icon_state = "Shark"
		weight = 10
		fishXP = 25
		FoodValue = 7
		CookingSkill = 5
	Blue_Shark
		icon_state = "Blue Shark"
		weight = 9
		fishXP = 50
		FoodValue = 8
		CookingSkill = 6

	//color = "Blue"

	icon = 'fish.dmi'


obj/item/tool/Fishing_Rod
	var worm = 0
	proc
		SetIcon()
			if ( !worm )
				icon_state = initial(icon_state)
				name = initial(name)
			else
				icon_state = "fishing rod worm"
				name = "Fishing Rod with Worm"

obj/item/misc/Earthworm/MouseDrop(obj/item/tool/Fishing_Rod/rod)
	if ( !rod || !istype(rod,/obj/item/tool/Fishing_Rod) )
		return ..()

	if ( !canCombo(rod) )
		return

	if ( rod.worm )
		usr << "Fishing Rod already has a worm"
		return

	rod.worm = 1
	rod.SetIcon()
	gameMessage("You add a worm onto the fishing rod.",MESSAGE_FISHING)
	usr:GiveXP(SKILL_FISHING,WORM_XP)
	usr:CheckIQ(IQ_MAKE,src)

