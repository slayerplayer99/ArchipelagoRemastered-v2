//#define MAX_WEIGHT	125
var
	MAX_WEIGHT = 125
mob/player
	var
		weight = 0
	Stat()
		HealthStat()
		statpanel("Inventory",contents)
		statpanel("Inventory","Weight","[weight]/[MAX_WEIGHT]")

		StatSkills()
		ChestStats()

	proc/hasItems(itemType,num)
		var found = 0
		for ( var/obj/item/thing in contents )
			if ( istype(thing,itemType) )
				found++
				if ( found >= num )
					return 1

		return 0

/*	proc/getItems(itemType,num)
		var list/retList = new()
		var found = 0
		for ( var/obj/item/thing in contents )
			if ( istype(thing,itemType) )

				retList += thing
				found++
				if ( found >= num )
					return retList

		return retList */




obj
	item
		tool
			DblClick()
				if ( loc != usr )
					return
				if ( usr:isBusy() )
					return

				if ( usr:equipped )
					if ( src == usr:equipped )
						suffix = null
						usr:equipped = null
						return
					usr:equipped.suffix = null

				suffix = "Equipped"
				usr:equipped = src

		verb
			Get()
				set category ="Survival"
				set src in oview(1)
				if ( usr:isBusy() )
					return
				if(src==/obj/item/misc/Backpack)
					if(usr.ebackpack<=1)
						usr<<"You already have a back pack"
					else
						Move(usr)
						usr.ebackpack+=1
						pickedUp=1

				else
					Move(usr)
					pickedUp = 1

			Drop()
				set category ="Survival"
				set src in usr
				if ( usr:isBusy() )
					return

				density = 0
				Move(usr.loc)
				density = initial(density)

				if ( usr:equipped == src )
					usr:equipped = null
					suffix = null
				if(usr.backpackeffect==0)
					MAX_WEIGHT=125
					usr.ebackpack-=1
					src.suffix=""


		var	weight

		New(newLoc)
			..(newLoc)
			LoadPointer()

			if ( istype(newLoc,/mob/player) )
				if ( newLoc:weight + weight > MAX_WEIGHT )
					newLoc << "You cannot pick up [src], it's too heavy"
					src.Move(newLoc:loc)

				else
					newLoc:weight += weight


//			spawn(1)
//				CleanUpDrop()


		proc/LoadPointer()
			var icon/pointerIcon = icon(icon,icon_state)

			pointerIcon.Blend('item_pointer.dmi',ICON_OVERLAY)

			mouse_drag_pointer = pointerIcon

		Del()
			if ( !istype(loc,/mob/player) )
				return ..()

			loc:weight -= weight
			return ..()

		Move(newLoc)
			var oldLoc = loc

			if ( istype(newLoc,/mob/player) )
				if ( newLoc:weight + weight > MAX_WEIGHT )
					newLoc << "You cannot pick up [src], it's too heavy"
					return 0

			var ret = ..(newLoc)

			if ( !ret )
				return ret

			if ( istype(newLoc,/mob/player) )
				newLoc:weight += weight
			if ( istype(oldLoc,/mob/player) )
				oldLoc:weight -= weight




			return ret



		icon = 'Things.dmi'





obj
	item
		tool
			icon = 'Things.dmi'
			Steel_Anvil
				weight = 0
				icon='Things.dmi'
				icon_state="anvil"
			Hoe
				weight = 6
				icon = 'temp_hoe.dmi'

			Fishing_Rod
				damage = 3
				weight = 4

				icon_state = "Fishing Rod"
			Shovel
				weight = 4
				//icon = 'temp_shovel.dmi'
				icon_state = "Small Shovel"
			Long_Shovel
				weight = 6
				//icon = 'temp_long_shovel.dmi'
				icon_state = "Shovel"
			Hammer
				weight = 5
				//icon = 'temp_hammer.dmi'
				icon_state = "Hammer"
			Harpoon
				weight = 6
				icon_state = "Harpoon"
			Pickaxe
				weight = 6
				icon_state = "Pickaxe"
			Blow_Pipe
				damage = 3
				weight = 6
				icon = 'temp_items.dmi'
				icon_state = "blow pipe"
			Tongs
				damage = 2
				weight = 4
				icon_state = "tongs"
				icon = 'temp_items.dmi'
			Knife
				weight = 4
				icon_state = "Knife"
			Spade
				weight = 4
				icon_state = "Spade"
				icon = 'temp_items.dmi'


			Hatchet
				damage = 6
				weight = 5
				icon_state = "Hatchet"
				MouseDrop(obj/item/misc/over_obj)
					if ( !over_obj || !istype(over_obj,/obj/item/misc) || over_obj.loc != usr )
						return ..()
					if ( usr:getEquipedItem() != src )
						return ..()

					var newItemType

					switch ( over_obj.type )
						if ( /obj/item/misc/Bundle_Of_Twigs )	newItemType = /obj/item/misc/Twig
						if ( /obj/item/misc/Bundle_Of_Branches)	newItemType = /obj/item/misc/Branch
						if ( /obj/item/misc/Bundle_Of_Vines )	newItemType = /obj/item/misc/Vine
						if ( /obj/item/misc/Coconut)	newItemType = /obj/item/food/meat/Cracked_Open_Coconut
						if ( /obj/item/misc/Coconut_Juice)	newItemType = /obj/item/food/meat/Cracked_Open_Coconut
					if ( newItemType )
						var obj/newItem = new newItemType(usr.loc)
						newItem.Move(usr)
						newItem = new newItemType(usr.loc)
						newItem.Move(usr)

						usr:CheckIQ(IQ_FIND,over_obj)
						usr << "You split the [over_obj] into 2 [newItem]s."
						del over_obj
						return



			Axe
				weight = 6
				icon_state = "Axe"
				damage = 6
				MouseDrop(obj/item/misc/over_obj)
					if ( !over_obj || !istype(over_obj,/obj/item/misc) || over_obj.loc != usr )
						return ..()
					if ( usr:getEquipedItem() != src )
						return ..()

					var newItemType

					switch ( over_obj.type )
						if ( /obj/item/misc/Bundle_Of_Twigs )	newItemType = /obj/item/misc/Twig
						if ( /obj/item/misc/Bundle_Of_Branches)	newItemType = /obj/item/misc/Branch
						if ( /obj/item/misc/Bundle_Of_Vines )	newItemType = /obj/item/misc/Vine
						if ( /obj/item/misc/Coconut)	newItemType = /obj/item/food/meat/Cracked_Open_Coconut
						if ( /obj/item/misc/Coconut_Juice)	newItemType = /obj/item/food/meat/Cracked_Open_Coconut
					if ( newItemType )
						var obj/newItem = new newItemType(usr.loc)
						newItem.Move(usr)
						newItem = new newItemType(usr.loc)
						newItem.Move(usr)

						usr:CheckIQ(IQ_FIND,over_obj)
						usr << "You split the [over_obj] into 2 [newItem]s."
						del over_obj
						return
			Fishing_Net
				weight = 4
				icon_state = "Fishing Net"
				damage = 2
			Mortar_And_Pedastle
				weight = 4
				icon = 'temp_items.dmi'
				icon_state = "mortar ped"
				damage = 2

/*
mob
	verb
		reset()
			usr.backpackeffect=0
			usr.ebackpack=0
			*/
mob
	var
		backpackeffect=0
		ebackpack=0
obj
	item
		misc
			var
				burnable

			Backpack
				icon='pack.dmi'
				weight = 3
				var
					pack_on=0
					pack = 0
				DblClick()
					if(get_dist(src.loc,usr.loc) <=1)
	//					if(src.pack_on<=1)
						if(usr.ebackpack<=1)
							if(usr.backpackeffect==0)
								src.suffix="Equipped"
								MAX_WEIGHT=175
							//	src.pack_on+=1
							//	src.pack=1
								usr.ebackpack+=1
								usr.backpackeffect=1
							else
							//	src.pack_on=0
								usr.backpackeffect=0
								usr.ebackpack-=1
							//	src.pack=0
								src.suffix=""
								MAX_WEIGHT=125

						else
							usr<<"You May Only Equip One At A Time!"
					else
						return ..()
			Nails
				//icon = 'temp_nails.dmi'
				icon_state = "Nails"
				weight = 3
			Hook
				icon = 'temp_items.dmi'
				icon_state = "hook"
				weight = 1

			Needle
				weight = 0.5
				icon_state = "needle"
				icon = 'Things.dmi'
			Needle_And_Twine
				weight = 0.5
				icon_state = "2needle"
				icon = 'Things.dmi'
			Twig
				icon_state = "Twig"
				burnable = 1
				weight = 1
			Branch
				icon_state = "Branch"
				weight = 2
				burnable = 2
			Rock
				icon_state = "Big Rock"
				weight = 3
			Flint
				icon_state = "Flint"
				weight = 3
			Vine
				icon_state = "Vine"
				weight = 1

			Bundle_Of_Vines
				icon_state = "Vine 2"
				weight = 2
			Bundle_Of_Twigs
				icon_state = "Twigs"
				burnable = 2
				weight = 2
			Bundle_Of_Branches
				icon_state = "Branches"
				weight = 4
				burnable = 4

			Branch_With_Vine
				icon_state = "Branch with Vine"
				weight = 3
			Twig_With_Vine
				icon_state = "Twig with Vine"
				weight = 2
			Sharpened_Rock
				icon_state = "Sharpened Rock"
				weight = 2
			Branch_With_Twine
				icon_state = "Branch with Twine"
				weight = 3


//			Rice
//				icon = 'temp_rice.dmi'
//				weight = 1
			Cotton
				icon = 'temp_cotton.dmi'
				weight = 1
			Spunned_Cotton
				icon = 'temp_cotton.dmi'
				icon_state="spun"
				weight = 1
			Cotton_Frabic
				icon = 'Things.dmi'
				icon_state="cotton frabic"
				weight = 1.5
			Bundle_Of_Cotton_Frabic
				icon = 'Things.dmi'
				icon_state="bcotton frabic"
				weight = 3
			Twine
				icon = 'temp_items.dmi'
				icon_state = "twine"




			Straw
				icon = 'temp_straw.dmi'
				weight = 1
				burnable = 1

			Earthworm
				icon = 'temp_items.dmi'
				icon_state = "worm"
				weight = 1
			Sand
				//icon_state = "sand"
				icon = 'temp_sand.dmi'
				weight = 3

			Clay
				icon_state = "clay"
				icon = 'temp_clay.dmi'
				weight = 1

			Softened_Clay
				icon_state = "soft clay"
				icon = 'temp_clay.dmi'
				weight = 1

			Brick_Mold
				icon_state = "brick mold"
				icon = 'temp_items.dmi'
				weight = 6


			Mortar
				icon_state = "mortar"
				icon = 'temp_items.dmi'
				weight = 3

			Soft_Clay_Bowl
				icon_state = "soft clay bowl"
				icon = 'temp_items.dmi'
				weight = 4

			Raft
				icon_state = "raft"
				icon = 'temp_items.dmi'
				weight = 15

			Bundle_Of_Straw
				icon_state = "straw bundle"
				//icon = 'temp_icons.dmi'
				icon = 'temp_straw.dmi'
				weight = 2
			Rope
				weight = 5
				icon = 'temp_items.dmi'
				icon_state = "rope"

		container
			bowl
				Clay_Bowl
					name = "Clay Bowl"
					weight = 4
					icon = 'temp_bowl.dmi'

			jar
				Glass_Jar
					name = "Glass Jar"
					weight = 3
					icon = 'temp_jar.dmi'
			vial
				Glass_Vial
					name = "Glass Vial"
					weight = 2
					icon = 'temp_vial.dmi'

