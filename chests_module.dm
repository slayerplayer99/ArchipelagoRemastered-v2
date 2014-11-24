//mob/player/verb/GiveMetalSmithXP()
//	GiveXP(SKILL_SMITHING,10000)




mob/player
	var	tmp/obj/building/chest/openedChest

	proc
		ChestStats()
			if ( openedChest )
				if ( get_dist(src,openedChest) > 1 )
					openedChest = null
					return
				if ( openedChest.isLocked )
					openedChest = null
					return

				statpanel("[openedChest]",openedChest.chestContents)



obj/item/DblClick()
//	world.log << "[src] double clicked. loc = [loc]. loctype = [loc.type] "
//	world.log << "istype(loc,/obj/building/chest) = [istype(loc,/obj/building/chest)]"

	if ( !istype(loc,/obj/building/chest) )
		return ..()

	//world.log << " in a building"

	if ( get_dist(src,usr) > 1 )
		return ..()


	if ( loc:isLocked )
		return

	gameMessage(usr,"You take [src] out of the [loc].",MESSAGE_CONTAINER)
	Move(usr.loc)
	Move(usr)



obj/item/misc/Key
	icon = 'temp_items.dmi'
	icon_state = "key"
	weight = 1
	var
		lockNum
	verb
		Inspect()
			usr << "This key's combo is [lockNum]"

obj/item/misc/Lock
	icon = 'temp_items.dmi'
	icon_state = "lock"

	weight = 2
	var
		lockNum
	verb
		Inspect()
			usr << "This lock's combo is [lockNum]"


obj/building/chest
	density = 0
	var
		list/chestContents = new()
		hasLock
		isLocked
		lockNum
		locked_state = "locked chest"


	DblClick()
		if ( get_dist(src,usr) > 1 )
			return
		if ( isLocked )
			gameMessage(usr,"The [src] is locked.",MESSAGE_CONTAINER)
			return

		if ( !chestContents.len )
			gameMessage(usr,"The [src] is empty.",MESSAGE_CONTAINER)
			return

		usr:openedChest = src


	Entered(obj/item)
		chestContents += item

	Exited(obj/item)
		chestContents -= item

	proc
		itemDrop(obj/item/Item,mob/player/mover)
			if ( mover.isBusy() )
				return

			if ( istype(Item,/obj/item/misc/Key) && hasLock && ( lockNum == Item:lockNum ) )
				if ( isLocked )
					isLocked = 0
					gameMessage(mover,"You unlock the [src].",MESSAGE_CONTAINER)
				else
					isLocked = 1
					gameMessage(mover,"You lock the [src].",MESSAGE_CONTAINER)
				return

			if ( !hasLock && istype(Item,/obj/item/misc/Lock) )
				gameMessage(mover,"You add a [Item] to the [src].",MESSAGE_CONTAINER)
				addLock(Item)
				return

			if ( isLocked )
				gameMessage(mover,"[src] is locked.",MESSAGE_CONTAINER)
				return

			gameMessage(mover,"You place [Item] into the [src].",MESSAGE_CONTAINER)
			Item.Move(src)


		addLock(obj/item/misc/Lock/lock)
			icon_state = locked_state
			hasLock = 1
			lockNum = lock.lockNum
			lock.Move(src)
			chestContents -= lock