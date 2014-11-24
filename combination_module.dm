

proc


	GetComboType(obj/item/obj1,obj/item/obj2,SecondTry = 0)

		if ( istype(obj1,/obj/item/food/plant) && istype(obj2,/obj/item/food) )
			if ( obj1:cooked == COOKED_BURNT && obj2:cooked == COOKED_BURNT )
				return /obj/item/fertilizer/Vegetable_Matter


		switch (obj1.type)
			if ( /obj/item/misc/Softened_Clay)
				switch ( obj2.type )
					if ( /obj/item/misc/Sand )		return /obj/item/misc/Mortar
					if ( /obj/item/misc/Rock )		return /obj/item/misc/Soft_Clay_Bowl

			if ( /obj/item/misc/Needle_And_Twine )
				if(  obj2.type == /obj/item/misc/Bundle_Of_Cotton_Frabic)
					if(usr.ebackpack==0)
						return /obj/item/misc/Backpack
					else
						del obj1
						del obj2
						new/obj/item/misc/Backpack(usr.loc)


			if ( /obj/item/misc/Clay )
				if ( istype(obj2,/obj/Spring) )	return /obj/item/misc/Softened_Clay

			if ( /obj/item/misc/Branch )
				switch (obj2.type)
					if ( /obj/item/misc/Branch )	return /obj/item/misc/Bundle_Of_Branches
					if ( /obj/item/misc/Vine )		return /obj/item/misc/Branch_With_Vine
					if ( /obj/item/misc/Twine )		return /obj/item/misc/Branch_With_Twine


			if( /obj/item/misc/Sharpened_Rock)
				if( obj2.type == /obj/item/misc/Coconut)
					return /obj/item/misc/Coconut_Juice


			if ( /obj/item/misc/Twig )
				switch (obj2.type)
					if ( /obj/item/misc/Twig )		return /obj/item/misc/Bundle_Of_Twigs
					if ( /obj/item/misc/Vine )		return /obj/item/misc/Twig_With_Vine
					if ( /obj/item/misc/Bundle_Of_Branches )	return /obj/Fire

			if ( /obj/item/misc/Rock )
				switch (obj2.type)
					if ( /obj/item/misc/Flint )		return /obj/item/misc/Sharpened_Rock
					if ( /obj/item/misc/Mortar )	return /obj/item/tool/Mortar_And_Pedastle

			if ( /obj/item/misc/Vine )
				switch (obj2.type)
					if ( /obj/item/misc/Vine )				return /obj/item/misc/Bundle_Of_Vines
					if ( /obj/item/misc/Bundle_Of_Branches)	return /obj/item/misc/Raft


			if ( /obj/item/misc/Branch_With_Vine )
				switch (obj2.type)
					if ( /obj/item/misc/Rock )				return GetComboItemFromList(list(/obj/item/tool/Long_Shovel,
																					 		/obj/item/tool/Hoe	))
					if ( /obj/item/misc/Sharpened_Rock )	return GetComboItemFromList(list(/obj/item/tool/Harpoon,
																					 		/obj/item/tool/Pickaxe	))
					if ( /obj/Fire ) 						return /obj/item/misc/Torch
					if ( /obj/item/misc/Torch )				return /obj/item/misc/Torch

			if ( /obj/item/misc/Branch_With_Twine )
				if ( obj2.type == /obj/item/misc/Hook )
					return /obj/item/tool/Fishing_Rod

			if ( /obj/item/misc/Cotton_Frabic )
				if( obj2.type == /obj/item/misc/Cotton_Frabic)
					return /obj/item/misc/Bundle_Of_Cotton_Frabic


			if (/obj/item/misc/Twine)
				switch(obj2.type)
					if(/obj/item/misc/Needle)	return /obj/item/misc/Needle_And_Twine
					if (/obj/item/misc/Bundle_Of_Straw )	return /obj/item/misc/Rope



			if ( /obj/item/misc/Twig_With_Vine )
				switch (obj2.type)
					if ( /obj/item/misc/Rock )		return GetComboItemFromList(list(/obj/item/tool/Shovel,
																					 /obj/item/tool/Hammer))

					if ( /obj/item/misc/Sharpened_Rock )	return /obj/item/tool/Hatchet


			if ( /obj/item/misc/Bundle_Of_Vines )
				if ( obj2.type == /obj/item/misc/Bundle_Of_Vines )	return /obj/item/tool/Fishing_Net

			if ( /obj/item/fertilizer/Vegetable_Matter )
				if ( obj2.type == /obj/item/fertilizer/Vegetable_Matter )	return /obj/Compost

			if ( /obj/item/misc/Straw )
				if ( obj2.type == /obj/item/misc/Straw )	return /obj/item/misc/Bundle_Of_Straw


			if ( /obj/item/misc/Bundle_Of_Branches )
				if ( obj2.type == /obj/item/misc/Bundle_Of_Branches ) 	return /obj/item/misc/Brick_Mold

		if ( !SecondTry )
			return GetComboType(obj2,obj1,1)


	GetComboItemFromList(list/comboList)
		//world.log << "GetComboItem called: list size = ([comboList.len])"
//		for ( var/thing in comboList )
//			world.log << "  [thing]"

		var list/selectList = new()
		for ( var/type in comboList )
			selectList += Type2Name(type)

//		world.log << "Select list: "
//		for ( var/thing in selectList )
//			world.log << "  [thing]"

		selectList += "Cancel"

		if ( usr:isBusy() )
			return
		usr:setBusy(1)

		var selection = input(usr,"Which item do you want to make?","Combination") in selectList
		usr:setBusy(0)

		if ( selection == "Cancel" )
			return

		for ( var/type in comboList )
			if ( selection == Type2Name(type) )
				return type

obj
	item
		proc/canCombo(obj/over_obj)
			if ( loc != usr )
				return 0
			if ( !over_obj || !isobj(over_obj) )
				return 0
			if ( over_obj.loc != usr && istype(over_obj,/obj/item) )
				return 0
			if ( over_obj == src )
				return 0
			if ( get_dist(usr,over_obj) > 1 )
				return 0
			return 1

		MouseDrop(obj/over_obj)
			if ( !canCombo(over_obj) )
				return ..()

			if ( istype(over_obj,/obj/building/chest) )
				over_obj:itemDrop(src,usr)
				return


			var newType = GetComboType(src,over_obj)

			if ( !src )
				return ..()
			if ( !canCombo(over_obj) )
				return ..()


			if ( newType )
				var obj/newobj = new newType(usr.loc,usr)

				if ( istype(newobj,/obj/item) )
					newobj.Move(usr)

					gameMessage(usr, "You combine [src] with [over_obj] and create [newobj]",MESSAGE_COMBINING)
					usr:CheckIQ(IQ_MAKE,newobj)


				var NoDestroyRock = istype(newobj,/obj/item/misc/Soft_Clay_Bowl)


				var desObj = 1

				if ( !istype(over_obj,/obj/item) )
					desObj = 0
				if ( istype(over_obj,/obj/item/misc/Rock) && NoDestroyRock  )
					desObj = 0
				if ( istype(over_obj,/obj/item/misc/Torch) )
					desObj = 0

				if ( desObj )
					del over_obj

				if ( !istype(src,/obj/item/misc/Rock) || !NoDestroyRock )
					del src
				return ..()