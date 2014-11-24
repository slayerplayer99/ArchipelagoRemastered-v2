
#define MIXED_GOOD 1
#define MIXED_BAD 2

#define GRIND_TIME 40
#define SHAKE_TIME 60

#define DRINK_TIME 20

#define EFFECT_HEALING		0
#define EFFECT_METABOLISM	1
#define EFFECT_REGEN		2
#define EFFECT_SKILL		3

#define EFFECT_HURT			4
#define EFFECT_DISEASE		5
#define EFFECT_POISON		6
#define EFFECT_FEVER		7



obj/item/container/vial/proc/DoAlchemyCheck(mob/player/shaker)
	// INSERT ALCHEMY SKILL CODE HERE
	var skill1 = item:skill
	var skill2 = item2:skill

	var itemSkill = ( skill1 * 2 + skill2 ) / 3

	var pSkill = shaker.GetSkill(SKILL_ALCHEMY)

	var chance = 50 + 10 * ( pSkill - itemSkill )

	chance = AdjustChance(chance)

	if ( shaker.isBusy() )
		return

	shaker.Public_message("[shaker] starts stiring a [src].",SKILL_ALCHEMY)

	shaker.setBusy(1)
	sleep(SHAKE_TIME)
	if ( !shaker) 	return
	shaker.setBusy(0)



	if ( prob(chance) )
		identified = 1
	else
		identified = 0
		gameMessage(usr,"You have no idea if the potion is good or not.",SKILL_ALCHEMY)

	var XP = itemSkill * 5

	if ( prob(chance) )
		mixed = MIXED_GOOD
		shaker.GiveXP(SKILL_ALCHEMY,XP)
		shaker.CheckIQ(IQ_MAKE,/obj/item/container/vial)
		if ( identified )
			gameMessage(usr,"You create a benefitial potion.",SKILL_ALCHEMY)
	else
		mixed = MIXED_BAD
		shaker.GiveXP(SKILL_ALCHEMY,XP*FAILURE_XP_BOOST)
		if ( identified )
			gameMessage(usr,"You overstir and create a mysterious toxin.",SKILL_ALCHEMY)



	return 1

obj/item/container/vial/verb/Shake()
	if ( mixed )
		world.log << "Vial is already mixed"
		return
	if ( !item || !item2 )
		world.log << "Cannot shake non-full vial"
		return


	if ( DoAlchemyCheck(usr) )


		SetName()
		SetIcon()
		SetVerbs()

obj/item/tool/Mortar_And_Pedastle/proc/getGrindChance(obj/item/food/food,mob/player/grinder)
	var pSkill = grinder.GetSkill(SKILL_ALCHEMY)
	var skill = food.CookingSkill

	var chance = 25 + 8 * ( pSkill - skill )
	return AdjustChance(chance)


obj/item/tool/Mortar_And_Pedastle/proc/getGrindXP(obj/item/food/food)
	return food.CookingSkill * 3

obj/item/powder/proc/GetAlchemyEffectType()
	if ( ispath(objType,/obj/item/food/plant/vegetable ) )
		return EFFECT_HEALING
	if ( ispath(objType,/obj/item/food/plant/berry ) )
		return EFFECT_METABOLISM
	if ( ispath(objType,/obj/item/food/plant/spice ) )
		return EFFECT_REGEN
	if ( ispath(objType,/obj/item/food/plant/mushroom ) )
		return EFFECT_SKILL

	world.log << "Bad alchemy ingredient: [src]"
	return EFFECT_HEALING
obj/item/powder/proc/GetBadAlchemyEffectType()
	if ( ispath(objType,/obj/item/food/plant/vegetable ) )
		return EFFECT_HURT
	if ( ispath(objType,/obj/item/food/plant/berry ) )
		return EFFECT_DISEASE
	if ( ispath(objType,/obj/item/food/plant/spice ) )
		return EFFECT_POISON
	if ( ispath(objType,/obj/item/food/plant/mushroom ) )
		return EFFECT_FEVER


	world.log << "Bad alchemy ingredient: [src]"
	return EFFECT_HURT

obj/item/powder/proc/GetAlchemyPower()
	if ( ispath(objType,/obj/item/food/plant/vegetable ) )
		return 8
	if ( ispath(objType,/obj/item/food/plant/berry ) )
		return 12
	if ( ispath(objType,/obj/item/food/plant/spice ) )
		return 15
	if ( ispath(objType,/obj/item/food/plant/mushroom ) )
		return 18
	world.log << "Bad alchemy ingredient: [src]"
	return 6


mob/player/var
	Effect_Type
	Effect_Duration


mob/player/proc/DrinkPotion(obj/item/powder/ingredient1,obj/item/powder/ingredient2,mixed)
	// DO SOMETHING HERE
	Public_message("[usr] drinks a potion.",MESSAGE_DRINKING)
	var power = ingredient2.GetAlchemyPower()
	var effType
	if ( mixed == MIXED_GOOD )
		effType = ingredient1.GetAlchemyEffectType()
	else
		effType = ingredient1.GetBadAlchemyEffectType()

	sleep(DRINK_TIME)


//	world.log << "[src] drinks potion: effType [effType], power [power]"

	if ( effType == EFFECT_HEALING )
		gameMessage(src,"You feel much better!")
		health += power
		if ( health > 100 )
			health = 100
		return
	if ( effType == EFFECT_HURT )
		Public_message("<font color=green>[usr] doubles over in pain.")
		Hurt(power,"dies!")
		return
	Effect_Type = effType
	Effect_Duration = round(power / 2)


	RunEffect()



mob/player/proc/RunEffect()
	if ( !Effect_Type )
		return
	if ( Effect_Duration <= 0 )
		Effect_Type = null
		return
	Effect_Duration--
	switch ( Effect_Type )
		if ( EFFECT_METABOLISM )
			gameMessage(src,"<font color=blue>You feel revitalized.")
			addStomach(1)
			addWater(1)
		if ( EFFECT_REGEN )
			gameMessage(src,"<font color=blue>A soothing feeling flows through you.")
			health += 4
			if ( health > 100 )
				health = 100
		if ( EFFECT_DISEASE )
			Public_message("<font color=green>[src] coughs violently.")
			stomach--
			if ( stomach < 0 )
				stomach = 0
			water--
			if ( water < 0 )
				water = 0
		if ( EFFECT_POISON )
			gameMessage("<font color=green>You shiver in agony as poison courses through you.")
			Hurt(5,"dies from poison!")
		if ( EFFECT_FEVER )
			gameMessage("<font color=green>You nearly collapse from the intense fever.")






obj/item/powder
	weight = 1
	var
		objType
		value
		itemName
		colour
		skill
	icon = 'temp_items.dmi'
	icon_state = "powder"

	New(loc,obj/item/food/food)
		if ( !food )
			world.log << "Powder without food"
			return
		objType = food.type
		name = "Ground [initial(food.name)]"
		itemName = initial(food.name)
		value = food.FoodValue

		var newIcon = icon(icon,icon_state)

		colour = food.colour
		skill = food.CookingSkill
		AdjustIconColour(newIcon,food.colour)
		icon = newIcon
		..()
	MouseDrop(obj/item/container/vial/vial)
		if ( !vial || !istype(vial,/obj/item/container/vial) )
			return ..()
		if ( !canCombo(vial) )
			return

		if ( vial.item && vial.item2 )
			usr << "The vial is already full"
			return

		if ( !vial.item )
			vial.item = src
		else if ( !vial.item2 )
			vial.item2 = src

		Move(vial)
		gameMessage(usr,"You pour the [src] into the [vial].",MESSAGE_CONTAINER)
		vial.SetName()
		vial.SetIcon()
		vial.SetVerbs()




obj/item/tool/Mortar_And_Pedastle/proc/Grind(obj/item/food,mob/player/grinder)
	if ( grinder.getEquipedItem() != src )
		return ..()
	if ( !food.canCombo(src) )
		return
	if ( grinder.isBusy() )
		return

	grinder.Public_message("[grinder] starts grinding [food].",MESSAGE_ALCHEMY)

	grinder.setBusy(1)
	sleep(GRIND_TIME)
	if ( !grinder )	return

	grinder.setBusy(0)
	if ( !food )	return

	var chance = getGrindChance(food,grinder)
	var XP = getGrindXP(food,grinder)

	if ( prob(chance) )

		gameMessage(grinder,"You successfully grind [food] into powder.",MESSAGE_ALCHEMY)
		var obj/item/powder/newPowder = new(grinder.loc,food)
		newPowder.Move(grinder)
		grinder.GiveXP(SKILL_ALCHEMY,XP)
		grinder.CheckIQ(IQ_MAKE,newPowder)
	else
		gameMessage(grinder,"The pedastle slips and you lose the [food].",MESSAGE_ALCHEMY)
		grinder.GiveXP(SKILL_ALCHEMY,XP*FAILURE_XP_BOOST)

	del food





obj/item/food/plant/MouseDrop(obj/item/tool/Mortar_And_Pedastle/mortar)
	if ( !mortar || !istype(mortar,/obj/item/tool/Mortar_And_Pedastle) )
		return ..()

	mortar.Grind(src,usr)