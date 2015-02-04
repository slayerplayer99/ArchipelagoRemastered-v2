#define	CLEAN_UP_TIME	900
#define OCEAN_TIME	50


obj/item/var/pickedUp = 0
obj/item/proc
	CleanUpDrop()
//		if ( loading != 2 )
//			return

		if ( !isturf(loc) || pickedUp )
			return
		spawn ( CLEAN_UP_TIME )
			if ( isturf(loc) )
				del src


	CleanUpOcean()
		spawn ( OCEAN_TIME )
			if ( !istype(loc,/turf/Water) )
				return

			Public_message("[src] starts sinking to the bottom of the ocean.",MESSAGE_GEOGRAPHY)
			sleep(OCEAN_TIME)
			if ( !istype(loc,/turf/Water) )
				return
			del src


turf/Water/Entered(obj/item/Item)
	if ( istype(Item,/mob/player) )

		if ( isItemTypeInList(/obj/item/misc/Raft,Item.contents) )
			Item.icon_state = "raft"
		else
			Item.icon_state = "swim"
		return ..()

	if ( !Item || !istype(Item,/obj/item) )
		return ..()


	Item.CleanUpOcean()
	return ..()

turf/Water/Exited(mob/player/Player)
	if ( !istype(Player,/mob/player) )
		return ..()

	Player.icon_state = null

	return ..()