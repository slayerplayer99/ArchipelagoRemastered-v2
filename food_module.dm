#define WATER_DRINK_AMOUNT	3
#define COCONUT_DRINK_AMOUNT	3
#define MILK_DRINK_AMOUNT	6
//mob/player/verb/CreateBowl()
//	new /obj/item/container/bowl/Clay_Bowl(usr)

//mob/player/verb/CreateRice()
//	new /obj/item/food/plant/vegetable/Rice(usr)



mob/player/proc/Drink(drinkType)
	if ( isWaterFull() )
		usr << "You're already full."
		return 0


	if ( drinkType == CONTENTS_WATER )
		addWater(WATER_DRINK_AMOUNT)
		gameMessage(src, "You drink the water. Refreshing.",MESSAGE_DRINKING)
	if ( drinkType == CONTENTS_COCONUT)
		addWater(COCONUT_DRINK_AMOUNT)
		gameMessage(src, "You drink the coconut juice. Good.",MESSAGE_DRINKING)
	if ( drinkType == CONTENTS_MILK )
		addWater(MILK_DRINK_AMOUNT)
		gameMessage(src, "You drink the milk. Delicious!",MESSAGE_DRINKING)

	return 1


mob/player/proc/Eat(obj/item/food/food,obj/item/food/seasoning)
	if ( isFoodFull() )
		usr << "You're already full."
		return 0


	if ( !food.cooked )
		usr << "You don't want to eat that raw!"
		return 0
	if ( food.cooked == COOKED_BURNT )
		usr << "That is a terrible idea."
		return 0

	var foodValue = food.FoodValue
	if ( seasoning )
		foodValue += 2

	Public_message("[src] eats the [seasoning?"seasoned ":""][food].")
	addStomach(foodValue)
	src.health+=food.ghp
	if(src.health>src.mhealth)
		src.health=src.mhealth
	del food
	del seasoning

	return 1
obj/item/food
	var
		ghp = 5
obj/Spring/verb/Drink()
	set category ="Survival"
	set src in view(1,usr)
	usr:Drink(CONTENTS_WATER)

obj/item/food/verb/Eat()
	set category ="Survival"
	set src in usr.contents
	usr:Eat(src)


proc
	getFoodColour(obj/food)
		if ( istype(food,/obj/item/food) )
			return food:colour
		else
			return "Green"
/*		if ( istype(food,/obj/item/food/spice) )
			return "Green"

		switch (food.type)
			if ( /obj/item/food/berry/Blueberry )	return "Blue"
			if ( /obj/item/food/berry/Strawberry )	return "Red"
			if ( /obj/item/food/mushroom/Mushroom )	return "Tan"
			if ( /obj/item/food/vegetable/Corn )	return "Yellow"
			if ( /obj/item/food/vegetable/Potato )	return "Tan"
			else
				world.log << "no color set for [food.type]"
				return "Green" */

	AdjustIconColour(icon/Icon,colour,cooked)
//		world.log << "Adjust color called :color = [color]"
		switch (colour)
			if ( "Blue" )	Icon.SetIntensity(0,0,1)
			if ( "Red" )	Icon.SetIntensity(1,0,0)
			if ( "Tan" )	Icon.SetIntensity(0.8,0.5,0.2)
			if ( "Green" )	Icon.SetIntensity(0,0.8,0)
			if ( "Yellow" )	Icon.SetIntensity(1,1,0)

		if ( cooked == COOKED_BURNT )
			Icon.SetIntensity(0.4,0.4,0.4)
		if ( cooked == COOKED_GOOD )
			Icon.SetIntensity(0.8,0.8,0.8)




obj/item/food/MouseDrop(over_obj)
	if ( usr:isBusy() )
		return
	if ( src.loc != usr )
		return
	if ( !over_obj )
		return
	if ( get_dist(over_obj,usr) > 1 )
		return

	if ( istype(over_obj,/obj/Fire) )
		if ( cooked )
			usr << "[src] is already cooked."
			return
		if ( istype(src,/obj/item/food/plant/vegetable/Rice) )
			usr << "You must cook rice in a bowl."
			return

		usr:CookFood(src,over_obj)
		return

	if ( istype(over_obj,/obj/item/container/bowl) )
		var /obj/item/container/bowl/bowl = over_obj
		if ( istype(src,/obj/item/food/plant/spice))
//			usr << "Adding Spices.."

			if ( bowl.seasoning )
				gameMessage(usr,  "[bowl] already has spices in it.",MESSAGE_CONTAINER)
				return
			bowl.seasoning = src
			Move(bowl)
			gameMessage(usr, "You place the [src] into the [bowl].",MESSAGE_CONTAINER)
			return
		else
//			usr << "Adding Food.."

			if ( bowl.item )
				gameMessage(usr,  "[bowl] already has something in it.",MESSAGE_CONTAINER)
				return
			bowl.item = src
			Move(bowl)
			gameMessage(usr,  "You place the [src] into the [bowl].",MESSAGE_CONTAINER)
			return

	return ..()

obj/item/food
	var
		cooked
		colour = "Green"

		CookingSkill = 1
		FoodValue = 3



	plant

		vegetable
			weight = 2

			Rice
				icon = 'temp_rice.dmi'
				colour = "White"
				CookingSkill = 3
				Eat()
					if ( cooked )
						world.log << "Cooked rice not in bowl." // should not happen

					usr << "You can't eat uncooked rice!"
					return
				FoodValue = 5

			Corn
				icon = 'temp_corn.dmi'
				colour = "Yellow"
				CookingSkill = 2


			Potato
				icon = 'temp_potato.dmi'
				colour = "Tan"
		berry
			CookingSkill = 3
			FoodValue = 4
			weight = 1
			Strawberry
				icon = 'temp_strawberry.dmi'
				colour = "Red"
			Blueberry
				icon = 'temp_blueberry.dmi'
				colour = "Blue"
		spice
			CookingSkill = 4
			FoodValue = 1
			weight = 1
			Thyme
				icon = 'temp_thyme.dmi'
			Mint
				icon = 'temp_mint.dmi'
			Rosemary
				icon = 'temp_rosemary.dmi'
		mushroom
			CookingSkill = 5
			weight = 2
			FoodValue = 5
			Mushroom
				icon = 'temp_mushroom.dmi'
				colour = "Tan"