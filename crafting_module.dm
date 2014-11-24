#define CRAFTING_TIME_BOWL	 50
#define CRAFTING_TIME_GLASS  50
#define CRAFTING_TIME_CHISEL 50
#define CRAFTING_TIME_CRUCIBLE	50

#define GLASS_COOLING_TIME	120

#define SPIN_COTTON_TIME	60
#define SPIN_COTTON_XP		10

#define ROCK_BLOCK_XP		3

#define MOLD_TIME		40
#define MOLD_BAKE_TIME	50
#define MOLD_XP			10

obj/item/misc/Brick_Mold
	var
		obj/item/misc/Softened_Clay/clay

	proc
		addClay(obj/newclay,mob/player/owner)
			if ( clay )
				gameMessage(owner,"The mold already has clay in it.",MESSAGE_CONTAINER)
				return
			owner.Public_message("[owner] starts filling [src] with clay.",MESSAGE_CRAFTING)
			owner.setBusy(1)
			sleep(MOLD_TIME)
			if ( !owner )	return
			owner.setBusy(0)
			if ( !newclay )	return

			gameMessage(owner,"You finish filling the [src] with clay.",MESSAGE_CRAFTING)
			newclay.Move(src)
			icon_state = "filled brick mold"
			name = "Filled Brick Mold"
			clay = newclay

			owner.CheckIQ(IQ_FIND,src)


		bake(mob/player/baker,obj/oven)
			if ( !clay )
				//world << "no clay"

				return

			baker.Public_message("[baker] starts baking the clay bricks.",MESSAGE_CRAFTING)
			baker.setBusy(1)
			Move(oven)
			if ( istype( oven,/obj/Fire ) )
				oven.overlays += src
			sleep(MOLD_BAKE_TIME)

			if ( !baker )	return
			Move(baker)
			if ( !oven )	return
			if ( istype(oven,/obj/Fire) )
				oven.overlays -= src

			baker.setBusy(0)
			del clay

			icon_state = initial(icon_state)
			name = initial(name)
			var skill = baker.GetSkill(SKILL_CRAFTING)
			var chance = AdjustChance( 20 + 10 * skill )

			if ( prob(chance) )
				var obj/item/material/Bricks/newBricks = new(baker.loc)
				newBricks.Move(baker)
				gameMessage(baker,"You successfully bake the [newBricks].",MESSAGE_CRAFTING)
				baker.GiveXP(SKILL_CRAFTING,MOLD_XP)
				baker.CheckIQ(IQ_MAKE,newBricks)
			else
				gameMessage(baker,"You ruin the bricks.",MESSAGE_CRAFTING)
				baker.GiveXP(SKILL_CRAFTING,MOLD_XP*FAILURE_XP_BOOST)

				if ( prob(100-chance) )
					gameMessage(baker,"Your mold is burnt up in the fire!",MESSAGE_FIRE)
					del src


	MouseDrop(obj/oven)
		if ( !oven || ( !istype(oven,/obj/Fire) && !istype(oven,/obj/building/Furnace) ) )

			//world << "not an oven"
			return ..()

		if ( !canCombo(oven) )
			//world << "can't interact"
			return
		if ( usr:isBusy() )
			//world << "is busy"
			return
		bake(usr,oven)

obj/item/misc/Softened_Clay/MouseDrop(obj/item/misc/Brick_Mold/Mold)
	if ( !Mold || !istype(Mold,/obj/item/misc/Brick_Mold) )
		return ..()

	if ( !canCombo(Mold) )
		return ..()
	if ( usr:isBusy() )
		return
	Mold.addClay(src,usr)


mob/player/proc
	DoSandCrafting(obj/item/tool/Blow_Pipe/pipe,obj/Fire/fire)
		// INSERT CRAFTING CODE HERE

		var craftsList = GetMakableGlassCrafts()

		var craftType = GetSelection(craftsList,"Which craft do you want to make?","Glass Crafting")
		if ( !craftType )
			return
		pipe.sand = 0

		Public_message("[src] starts blowing a glass object over the fire.",MESSAGE_CRAFTING)
		setBusy(1)
		sleep(CRAFTING_TIME_GLASS)
		setBusy(0)
		if ( !fire )
			return

		var chance = GetObjSkillChance(craftType)

		var XP = GetObjXPAmount(craftType)
		if ( prob(chance) )
			GiveXP(SKILL_CRAFTING,XP)
			var obj/newCraft = new craftType(loc)
			//newCraft.Move(src)
			gameMessage(src,"You successfuly craft a [newCraft].",MESSAGE_CRAFTING)
			CheckIQ(IQ_MAKE,newCraft)
			return
		else
			GiveXP(SKILL_CRAFTING,XP*FAILURE_XP_BOOST)
			gameMessage(src,"You slip up and your glass is ruined.",MESSAGE_CRAFTING)
			return


	GetMakableGlassCrafts()
		var retList = list(/obj/item/glass/Glass_Vial)

		var skillLevel = GetSkill(SKILL_CRAFTING)
		if ( skillLevel >= 3 )
			retList += /obj/item/glass/Glass_Jar

		return retList

	GetSelection(objList,message,title)
		var list/selectList = new
		for ( var/objType in objList )
			selectList += Type2Name(objType)

		selectList += "Cancel"

		setBusy(1)
		var selection = input(src,message,title) in selectList
		setBusy(0)
		if ( selection == "Cancel" )
			return

		for ( var/objType in objList )
			if ( selection == Type2Name(objType) )
				return objType

		return

obj/item/tool/Hammer/MouseDrop(obj/item/misc/Rock/stone)
	if ( !stone || !istype(stone,/obj/item/misc/Rock) )
		return ..()
	if ( !canCombo(stone) )
		return
	if ( usr:isBusy() )
		return
	if ( usr:getEquipedItem() != src )
		return

	usr:Public_message("[usr] starts chiping away at a rock.",MESSAGE_CRAFTING)

	usr:setBusy(1)
	sleep(CRAFTING_TIME_CHISEL)
	if ( !usr ) return
	usr:setBusy(0)

	if ( !stone ) return

	var chance = usr:GetObjSkillChance(stone)
	var XP = ROCK_BLOCK_XP
	if ( prob(chance) )
		gameMessage(usr,"You chisel away a perfect stone block.",MESSAGE_CRAFTING)
		usr:GiveXP(SKILL_CRAFTING,XP)
		var obj/item/material/Stone_Block/sblock = new(usr.loc)
		usr:CheckIQ(IQ_MAKE,sblock)
		spawn(1)
			sblock.Move(usr)
	else
		gameMessage(usr,"Your hammer slips and smash the stone.",MESSAGE_CRAFTING)
		usr:GiveXP(SKILL_CRAFTING,XP*FAILURE_XP_BOOST)

	del stone


/*obj/item/tool/Pickaxe/MouseDrop(obj/item/misc/Rock/stone)
	if ( !stone || !istype(stone,/obj/item/misc/Rock) )
		return ..()
	if ( !canCombo(stone) )
		return
	if ( usr:isBusy() )
		return
	if ( usr:getEquipedItem() != src )
		return

	usr:Public_message("[usr] starts chiping away at a rock.",MESSAGE_CRAFTING)

	usr:setBusy(1)
	sleep(CRAFTING_TIME_CHISEL)
	if ( !usr ) return
	usr:setBusy(0)

	if ( !stone ) return

	var chance = usr:GetObjSkillChance(stone)
	var XP = ROCK_BLOCK_XP
	if ( prob(chance) )
		gameMessage(usr,"You craft the stone into a crucible.",MESSAGE_CRAFTING)
		usr:GiveXP(SKILL_CRAFTING,XP)
		var obj/item/container/Crucible/sblock = new(usr.loc)
		usr:CheckIQ(IQ_MAKE,sblock)
		sblock.Move(usr)
	else
		gameMessage(usr,"Your pickaxe slips and smash the stone.",MESSAGE_CRAFTING)
		usr:GiveXP(SKILL_CRAFTING,XP*FAILURE_XP_BOOST)

	del stone */


obj/item/misc/Soft_Clay_Bowl/MouseDrop(obj/fire)
	if ( !fire || ( !istype(fire,/obj/Fire ) && !istype(fire,/obj/building/Furnace) ) )
		return ..()



	if ( !canCombo(fire) )
		return
	if ( usr:isBusy() )
		return

	if ( istype(fire,/obj/building/Furnace) && !fire:isLit )
		gameMessage(usr,"The [fire] is not lit.",MESSAGE_FIRE)
		return
	// INSERT CRAFTING CODE HERE

	usr:Public_message("[usr] starts baking a clay bowl.",MESSAGE_CRAFTING)

	Move(fire)
	if ( istype(fire,/obj/Fire) )
		fire.overlays += src

	usr:setBusy(1)

	sleep(CRAFTING_TIME_BOWL)

	if ( usr )
		usr:setBusy(0)

	if ( !fire )
		return

	if ( istype(fire,/obj/Fire) )
		fire.overlays -= src

	if ( !usr )
		return

	var chance = AdjustChance(30 + ( 10 * usr:GetSkill(SKILL_CRAFTING) ) )
	var XP = 7
	if ( prob(chance) )

		usr:GiveXP(SKILL_CRAFTING,XP)
		gameMessage(usr,"You finish baking the clay bowl.",MESSAGE_CRAFTING)
		var obj/item/container/bowl/Clay_Bowl/newBowl = new(usr.loc)
		newBowl.Move(usr)
		usr:CheckIQ(IQ_MAKE,newBowl)
	else
		usr:GiveXP(SKILL_CRAFTING,XP*FAILURE_XP_BOOST)
		gameMessage(usr,"The bowl cracks as you are baking it.",MESSAGE_CRAFTING)



	del src

obj/item/misc/Sand/MouseDrop(obj/item/tool/Blow_Pipe/pipe)
	if ( !pipe || !istype(pipe,/obj/item/tool/Blow_Pipe) )
		return ..()
	if ( usr:getEquipedItem() != pipe )
		return ..()
	if ( !canCombo(pipe) )
		return ..()
	if ( pipe.sand >= 3 )
		gameMessage(usr,"The Blow Pipe is already full of sand.",MESSAGE_CONTAINER)
		return

	pipe.sand++
	gameMessage(usr,"You add sand to the Blow Pipe",MESSAGE_CONTAINER)
	del src

obj/item/tool/Blow_Pipe
	var
		sand = 0

	MouseDrop(obj/fire)
		if ( !fire || ( !istype(fire,/obj/Fire) && !istype(fire,/obj/building/Furnace) ))
			return ..()

		if ( usr:getEquipedItem() != src )
			return
		if ( !canCombo(fire) )
			return
		if ( usr:isBusy() )
			return

		if ( istype(fire,/obj/building/Furnace) && !fire:isLit )
			gameMessage(usr,"The [fire] is not lit.",MESSAGE_FIRE)
			return

		if ( sand < 3 )
			gameMessage(usr,"Your Blow Pipe does not have enough sand.",MESSAGE_CRAFTING)
			return

		usr:DoSandCrafting(src,fire)


obj/item/glass
	MouseDrop(obj/Spring/spring)
		if ( !spring || !istype(spring,/obj/Spring) )
			return ..()
		if ( !canCombo(spring) )
			return

		gameMessage(usr,"You place the [src] to cool in the spring.",MESSAGE_CRAFTING)
		Move(spring)
		sleep(GLASS_COOLING_TIME)

		var obj/newObj = new newType(spring.loc)


		if ( usr )
			gameMessage(usr,"Your [newObj] has finished cooling.",MESSAGE_CRAFTING)

		del src

	Get()
		set src in oview(1)
		var equip = usr:getEquipedItem()
		if ( !equip || !istype(equip,/obj/item/tool/Tongs) )
			usr << "[src] is too hot to pick up without the proper tool."
			return


		Move(usr)
		pickedUp = 1



	var
		newType

	icon = 'temp_items.dmi'
	icon_state = "melted glass"


	Glass_Vial
		name = "Formed Glass Vial"
		newType = /obj/item/container/vial/Glass_Vial

		weight = 2
	Glass_Jar
		name = "Formed Glass Jar"
		newType = /obj/item/container/jar/Glass_Jar
		weight = 3

/obj/item/misc/Cotton/MouseDrop(obj/building/Spinning_Wheel/wheel)
	if ( !wheel || !istype(wheel,/obj/building/Spinning_Wheel) )
		return ..()
	if ( !canCombo(wheel) )
		return
	if ( usr:isBusy() )
		return

	usr:Public_message("[usr] starts spinning cotton.",MESSAGE_CRAFTING)

	usr:setBusy(1)
	sleep(SPIN_COTTON_TIME)
	if ( !usr )
		return


	usr:setBusy(0)
	switch(input("What Would You Like To Spin Cotton Into?","Spinning Wheel")in list("Twine","Spunned Cotton","Cancel"))
		if("Twine")
			var chance = AdjustChance( 40 + 10 * usr:GetSkill(SKILL_CRAFTING) )
			if ( prob(chance) )


				gameMessage(usr,"You spin the cotton into twine.",MESSAGE_CRAFTING)
				var /obj/item/misc/Twine/twine = new(usr.loc)
				twine.Move(usr)
				usr:GiveXP(SKILL_CRAFTING,SPIN_COTTON_XP)
				usr:CheckIQ(IQ_MAKE,twine)
			else
				gameMessage(usr,"The cotton is ruined.",MESSAGE_CRAFTING)
				usr:GiveXP(SKILL_CRAFTING,SPIN_COTTON_XP*FAILURE_XP_BOOST)

			del src
		if("Spunned Cotton")
			var chance = AdjustChance( 30 + 10 * usr:GetSkill(SKILL_CRAFTING) )
			if ( prob(chance) )


				gameMessage(usr,"You prepare the cotton into spunned cotton",MESSAGE_CRAFTING)
				var /obj/item/misc/Spunned_Cotton/sc = new(usr.loc)
				sc.Move(usr)
				usr:GiveXP(SKILL_CRAFTING,SPIN_COTTON_XP)
				usr:CheckIQ(IQ_MAKE,sc)
			else
				gameMessage(usr,"The cotton is ruined.",MESSAGE_CRAFTING)
				usr:GiveXP(SKILL_CRAFTING,SPIN_COTTON_XP*FAILURE_XP_BOOST)

			del src



/obj/item/misc/Spunned_Cotton/MouseDrop(obj/building/Spinning_Wheel/wheel)
	if ( !wheel || !istype(wheel,/obj/building/Spinning_Wheel) )
		return ..()
	if ( !canCombo(wheel) )
		return
	if ( usr:isBusy() )
		return

	usr:Public_message("[usr] starts spinning spunned cotton.",MESSAGE_CRAFTING)

	usr:setBusy(1)
	sleep(SPIN_COTTON_TIME)
	if ( !usr )
		return


	usr:setBusy(0)
	var chance = AdjustChance( 25 + 10 * usr:GetSkill(SKILL_CRAFTING) )
	if ( prob(chance) )


		gameMessage(usr,"You spin the cotton into frabic",MESSAGE_CRAFTING)
		var /obj/item/misc/Cotton_Frabic/c = new(usr.loc)
		c.Move(usr)
		usr:GiveXP(SKILL_CRAFTING,SPIN_COTTON_XP)
		usr:CheckIQ(IQ_MAKE,c)
	else
		gameMessage(usr,"The cotton is ruined.",MESSAGE_CRAFTING)
		usr:GiveXP(SKILL_CRAFTING,SPIN_COTTON_XP*FAILURE_XP_BOOST)

	del src

