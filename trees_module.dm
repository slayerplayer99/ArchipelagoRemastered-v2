#define	PLUCK_TIME	30
#define MAX_WOOD 10
#define WOOD_GROWTH_RATE 5
#define CUT_TIME 60
#define MAX_VINE 3
#define VINE_GROWTH 60

#define HATCHET_XP	2
#define LOGS_XP		5


obj
	Moss_Wall
		icon='vine wall.dmi'
		density=1
		layer=MY_MOB_LAYER
		var
			vineleft=MAX_VINE
		verb
			Pluck_Vine()
				set src in view(1)
				set category = "Survival"
				if ( usr:isBusy() )
					return
				if ( vineleft <= 0 )
					usr << "This moss wall has no vine left."
					return

				usr.Public_message("[usr] starts plucking from moss wall.",MESSAGE_PLUCKING)

				usr:setBusy(1)
				sleep(PLUCK_TIME)
				if ( !usr ) return
				usr:setBusy(0)

				gameMessage(usr,"You pluck a vine from the moss wall.",MESSAGE_PLUCKING)

				var obj/item/misc/Vine/v = new(usr.contents)

				v.Move(usr)
				vineleft-=1
				usr:CheckIQ(IQ_FIND,v)
		proc
			NewDay()
				vineleft += VINE_GROWTH
				if ( vineleft > MAX_VINE )
					vineleft = MAX_VINE
obj
	Tree
		icon = 'palm tree.dmi'
		density = 1
		layer = MY_MOB_LAYER + 1
		dayFunc = 1
		var
			woodLeft = MAX_WOOD

		DblClick()
			if ( get_dist(usr,src) > 1 )
				return
			if ( usr:isBusy() )
				return
			var obj/item/tool/tool = usr:getEquipedItem()
			if ( !tool  )
				return

			if ( woodLeft <= 0 )
				usr << "This tree has no wood left."
				return

			if ( istype(tool,/obj/item/tool/Hatchet) )
				HatchetCut(usr)
				return
			if ( istype(tool,/obj/item/tool/Axe) )
				AxeCut(usr)
				return


		proc
			HatchetCut(mob/player/owner)
				owner.Public_message("[usr] starts chopping the tree with a hatchet.",MESSAGE_LUMBERJACK)

				owner.setBusy(1)
				sleep(CUT_TIME)
				if ( !owner ) return
				owner.setBusy(0)

				woodLeft -= 1

				var objType

				if ( prob(50) )
					objType = /obj/item/misc/Twig
				else
					objType = /obj/item/misc/Branch

				var obj/newObj = new objType(owner.loc)
				newObj.Move(owner)
				gameMessage(owner,"You find a [newObj].",MESSAGE_LUMBERJACK)
				owner.CheckIQ(IQ_FIND,/obj/item/tool/Hatchet)


				owner.GiveXP(SKILL_LUMBERJACK,HATCHET_XP)


			AxeCut(mob/player/owner)
				owner.Public_message("[usr] starts chopping the tree with an axe.",MESSAGE_LUMBERJACK)

				owner.setBusy(1)
				sleep(CUT_TIME)
				if ( !owner ) return
				owner.setBusy(0)

				if ( prob(owner.getSuccessRate(/obj/item/material/Logs)) )
					woodLeft -= 2
					var obj/item/material/Logs/logs = new(owner.loc)

					logs.Move(owner)
					gameMessage(owner,"You chop off some logs from the tree.",MESSAGE_LUMBERJACK)
					owner.CheckIQ(IQ_FIND,logs)
					owner.GiveXP(SKILL_LUMBERJACK,LOGS_XP)
					return
				else
					gameMessage(owner,"You can't manage to chop off any useable firewood.",MESSAGE_LUMBERJACK)
					owner.GiveXP(SKILL_LUMBERJACK,LOGS_XP*FAILURE_XP_BOOST)

			NewDay()
				woodLeft += WOOD_GROWTH_RATE
				if ( woodLeft > MAX_WOOD )
					woodLeft = MAX_WOOD




		verb
			Pluck()
				set src in view(1)
				set category = "Survival"
				if ( usr:isBusy() )
					return

				usr.Public_message("[usr] starts plucking from the tree.",MESSAGE_PLUCKING)

				usr:setBusy(1)
				sleep(PLUCK_TIME)
				if ( !usr ) return
				usr:setBusy(0)

				gameMessage(usr,"You pluck something from the tree.",MESSAGE_PLUCKING)

				var obj/item/misc/Coconut/coco = new(usr.contents) , obj/item/misc/Twig/twig = new(usr.contents)

				pick(twig.Move(usr), coco.Move(usr))
				usr:CheckIQ(IQ_FIND,twig)
				usr:CheckIQ(IQ_FIND,coco)


