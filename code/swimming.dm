// todo: implement skill roll in swimming

#define SWIM_XP	5
#define SWIM_TIME 8
#define RAFT_TIME 5
#define SWIM_HURT 2

turf/Water/Enter(mob/player/enterer)
	if ( !istype(enterer,/mob/player) )
	//	world.log << "Not a player"
		return ..()


	usr:setBusy(1)

	if ( isItemTypeInList(/obj/item/misc/Raft,enterer.contents) )
	//	world.log << "Has a raft"
		spawn(RAFT_TIME)
			usr:setBusy(0)

		density = 0
		var ret = ..()
		density = 1
		return ret


	//world.log << "No raft"

	// SWIM CODE HERE



	if ( prob(50) )
		spawn(SWIM_TIME)
			usr:setBusy(0)

		usr:GiveXP(SKILL_SWIMMING,SWIM_XP)

		density = 0
		var ret = ..()
		density = 1
		return ret


	else
		spawn(SWIM_TIME*2)
			usr:setBusy(0)

		usr:GiveXP(SKILL_SWIMMING,SWIM_XP*FAILURE_XP_BOOST)

		gameMessage(usr,"The rough waters throw you about.",MESSAGE_SWIMMING)
		usr:Hurt(SWIM_HURT,"drowns!")


		return 0



/*turf/Water/Entered(mob/player/enterer)
	if ( !istype(enterer,/mob/player) )
		return ..()

	if ( isItemTypeInList(/obj/item/misc/Raft,enterer.contents) )
		return ..()

	enterer.setBusy(1)
	spawn(SWIM_TIME)
		enterer.setBusy(0)

	return ..()*/




