
#define COOK_TIME 30






obj/item/container
	var
		item
	icon_state = "empty"


/*	Crucible
		SetVerbs()
			if ( item )
				verbs += /obj/item/container/verb/Empty
			else
				verbs -= /obj/item/container/verb/Empty
		SetName()
			name = initial(name)
			if ( item )
				name = "[name] of [item]"

		SetIcon() */


	verb
		Drink()
			if ( isobj(item) )
				world.log << "Bad drinking.. container has a [item] in it"
				return
			if ( !item )
				world.log << "No item to drink.."
				return

			if ( usr:Drink(item) )

				item = null
				SetIcon()
				SetName()
				SetVerbs()
		Empty()
			//world.log << "container empty verb"

			if ( !item )
				world.log << "No item to empty..."
				return
			if ( isobj(item) )
				item:Move(usr.loc)

			item = null

			usr << "You empty out the [src]"
			SetIcon()
			SetName()
			SetVerbs()


	jar

		SetVerbs()
			if ( item )
				verbs += /obj/item/container/verb/Drink
				verbs += /obj/item/container/verb/Empty
			else
				verbs -= /obj/item/container/verb/Drink
				verbs -= /obj/item/container/verb/Empty

	bowl
		var obj/seasoning

		isEmpty()
			return ( !item && !seasoning )

		verb

			Eat()
				if ( !item )
					if ( !seasoning )
						world.log << "No item to eat"
						return
					if ( usr:Eat(seasoning) )
						seasoning = null
					else
						return

				if ( usr:Eat(item,seasoning) )
					item = null
					seasoning = null
				else
					return
				SetIcon()
				SetName()
				SetVerbs()



		proc
			CookBowl(mob/player/owner,obj/fire)
				if ( !item && !seasoning )
					return

				if ( ( !item || item:cooked ) && ( !seasoning || seasoning:cooked ) )
					usr << "[src] is already cooked."
					return

				if ( item && seasoning && item:cooked )
					usr << "[src] is already cooked."
					return

				if ( !owner.CookBowl(src,fire) )
					return

				SetIcon()
				SetName()
				SetVerbs()



		SetName()
			if ( !seasoning && ( !item || !isobj(item) ) )
				return ..()


			name = initial(name)
			var
				firstThing
				secondThing
				prefix

			if ( item )
				if ( item:cooked == COOKED_BURNT)
					prefix = "Burnt "
				if ( item:cooked == COOKED_GOOD)
					prefix = "Cooked "

				firstThing = initial(item:name)
				if ( seasoning )
					secondThing = initial(seasoning.name)
			else
				if ( seasoning )

					if ( seasoning:cooked == COOKED_BURNT)
						prefix = "Burnt "
					if ( seasoning:cooked == COOKED_GOOD)
						prefix = "Cooked "


					firstThing = initial(seasoning.name)

			if ( firstThing && secondThing )
				name = "[prefix][name] of [firstThing] with [secondThing]"
			else if ( firstThing )
				name = "[prefix][name] of [firstThing]"

		SetIcon()
			if ( !seasoning && ( !item || !isobj(item) ) )
				return ..()

			var
				foodColour
				cooked

			if ( item )
				foodColour = getFoodColour(item)
				cooked = item:cooked
			else
				foodColour = getFoodColour(seasoning)
				cooked = seasoning:cooked

			var icon/BowlIcon = icon(initial(icon),"empty")
			var icon/FoodIcon = icon(initial(icon),"food")
			AdjustIconColour(FoodIcon,foodColour,cooked)
			BowlIcon.Blend(FoodIcon,ICON_OVERLAY)

			if ( seasoning && item )
				BowlIcon.Blend(icon(initial(icon),"spices"),ICON_OVERLAY)


			icon = BowlIcon


		Empty()
			//world << "bowl empty called"

			//world.log << "bowl empty verb"
			if ( item && !isobj(item) )
				return ..()

			if ( !item && !seasoning )
				world.log << "No item to empty..."
				return
			if ( !item || !seasoning)

				if ( item )
					if ( istype(item,/obj/item/food/plant/vegetable/Rice) && item:cooked )
						del item
					else
						item:Move(usr.loc)
				if ( seasoning )
					seasoning.Move(usr.loc)

			item = null
			seasoning = null

			gameMessage(usr, "You empty out the [src]", MESSAGE_CONTAINER )
			SetIcon()
			SetName()
			SetVerbs()

		SetVerbs()
			if ( seasoning || ( item && istype(item,/obj/item/food) ) )
				verbs += /obj/item/container/verb/Empty
				verbs += /obj/item/container/bowl/Empty


				verbs += /obj/item/container/bowl/verb/Eat
				verbs -= /obj/item/container/verb/Drink
			else if ( item )
				verbs += /obj/item/container/verb/Empty
				verbs += /obj/item/container/bowl/Empty

				verbs -= /obj/item/container/bowl/verb/Eat
				verbs += /obj/item/container/verb/Drink
			else
				verbs -= /obj/item/container/bowl/Empty
				verbs -= /obj/item/container/verb/Empty

				verbs -= /obj/item/container/bowl/verb/Eat
				verbs -= /obj/item/container/verb/Drink


	vial
		icon_state = "empty"
		var
			obj/item2
			mixed
			identified
		isEmpty()
			return ( !item && !item2 )


		Empty()
			if ( !item && !item2 )
				world.log << "Cannot empty an empty vial"
				return

			if ( !mixed && !( item && item2 ) ) // Can't recover mixed ingredients
				if ( item )
					item:Move(usr.loc)
				if ( item2 )
					item2:Move(usr.loc)
			else
				del item
				del item2


			item = null
			item2 = null
			mixed = 0
			identified = 0
			SetName()
			SetIcon()
			SetVerbs()
			gameMessage(usr, "You empty out the [src].", MESSAGE_CONTAINER)



		Drink()
			if ( !mixed )
				world.log << "Can't drink unmixed vials"
				return
			if ( !item || !item2 )
				world.log << "Not enough ingredients"
				return
			usr:DrinkPotion(item,item2,mixed)
			del item
			del item2
			item = null
			item2 = null
			mixed = 0
			identified = 0
			SetName()
			SetIcon()
			SetVerbs()



		SetVerbs()
		//	world.log << "glass vial setverbs"

			if ( item2 || item  )
				verbs += /obj/item/container/vial/Empty

			else
				verbs -= /obj/item/container/vial/Empty
				verbs -= /obj/item/container/verb/Empty

			if ( item && item2 && !mixed )
				verbs += /obj/item/container/vial/verb/Shake
			else
				verbs -= /obj/item/container/vial/verb/Shake

			if ( mixed )
				verbs += /obj/item/container/vial/Drink
			else
				verbs -= /obj/item/container/vial/Drink
				verbs -= /obj/item/container/verb/Drink

		SetName()
			name = initial(name)

			if ( mixed )
				var mix = "Mixed (???)"
				if ( identified )
					if ( mixed == MIXED_GOOD )
						mix = "Mixed"
					if ( mixed == MIXED_BAD )
						mix = "Ruined"

				name = "[mix] [name]"
			if ( !item && !item2 )
				return

			var name1
			var name2
			if ( item )
				name1 = item:itemName
			if ( item2 )
				name2 = item2:itemName


			if ( name1 && !name2 )
				name = "[name] of [name1]"
				return
			if ( !name1 && name2 )
				name = "[name] of [name2]"
				return
			if ( name1 && name2 )
				name = "[name] of [name1] and [name2]"
				return
		SetIcon()
			icon = initial(icon)
			icon_state = initial(icon_state)
			if ( !item && !item2 )
				return

			var icon/liquid = new(initial(icon),"Liquid")

			if ( item )
				AdjustIconColour(liquid,item:colour)
			if ( item2 )
				AdjustIconColour(liquid,item2:colour)

			var icon/newIcon = new(initial(icon),initial(icon_state))

			newIcon.Blend(liquid,ICON_OVERLAY)
			icon = newIcon


	New(loc)
		..(loc)
		//world.log << "[src] New called"

		spawn (1)
			SetVerbs()

	proc
		SetVerbs()
		SetIcon()
			icon = initial(icon)
			if ( !item )
				icon_state = "empty"
			if ( item == CONTENTS_WATER )
				icon_state = "water"
			if ( item == CONTENTS_MILK )
				icon_state = "milk"

		SetName()
			name = initial(name)
			if ( !item )
				return
			if ( item == CONTENTS_WATER )
				name = "[name] of water"
				return
			if ( item == CONTENTS_MILK )
				name = "[name] of milk"
				return
		isEmpty()
			return !item

	Entered()
		SetName()
		SetIcon()
		SetVerbs()


	MouseDrop(over_obj)
		if ( !over_obj )
			return

		if ( loc != usr )
			return

		if ( get_dist(over_obj,usr) > 1 )
			return

		if ( istype(over_obj,/obj/growingPlant) && item == CONTENTS_WATER )
			if ( over_obj:Watered(usr) )
				item = null
				SetName()
				SetIcon()
				SetVerbs()
				return

		if ( istype(over_obj,/obj/Spring) && isEmpty() && !istype(src,/obj/item/container/vial) )
			gameMessage(usr , "You fill [src] with spring water.", MESSAGE_CONTAINER )
			item = CONTENTS_WATER
			SetName()
			SetIcon()
			SetVerbs()

			return
		if ( istype(over_obj,/obj/building/Brick_Well) && isEmpty() && !istype(src,/obj/item/container/vial) )
			gameMessage(usr , "You fill [src] with well water.", MESSAGE_CONTAINER )
			item = CONTENTS_WATER
			SetName()
			SetIcon()
			SetVerbs()

			return
		if ( istype(over_obj,/obj/Fire) && istype(src,/obj/item/container/bowl) )
			src:CookBowl(usr,over_obj)

			return


		return ..()