obj/dead_corpse
	Dead_Hog_Corpse
		icon='hog.dmi'
		icon_state="dead"
		New()
			.=..()
			spawn(1)
			respawn_hog()
			new/obj/item/food/meat/animal/Hog_Meat(src.loc)
		proc
			respawn_hog()
				spawn(3600)
				new/mob/AI/animal/Hog(src.loc)
	//			spawn(1)
				del src
mob/AI/animal
	New()
		.=..()
		spawn(5)
		Wander()
/*	Bump(mob/player/M)
		if(M.client)
			mattack(M)
		else
			return ..()*/

	var
		health=7.5
		damage
mob/AI/insects
	New()
		.=..()
		spawn(3)
		Fly()
mob/AI/animal
	DblClick()
		if ( usr == src )
			return ..()
		if ( get_dist(usr,src) > 1 )
			return ..()
		if ( usr:isBusy() )
			return ..()
		if ( src:health <= 0 )
			return ..()
		var/skill = usr:GetSkill(SKILL_COMBAT)
		var/damage = skill
		var/percentage=rand(10,100)
		if(percentage>=50)
			src.health-=damage
			usr.Public_message("<B>[usr] attacks [src]!",MESSAGE_COMBAT)
			if(src.health<=0)
				new/obj/dead_corpse/Dead_Hog_Corpse(src.loc)
				del src
		else
			usr.Public_message("<B>[usr] attacks [src] but misses!",MESSAGE_COMBAT)


	proc
		mattack(mob/player/M)
			var/percentage=rand(10,100)
			if(percentage<=50)
				M.health-=rand(1,src.damage)
				usr.Public_message("<b>[src] attacks [M]!",MESSAGE_COMBAT)
				if(M.health<=0)
					M:Die()
				else
					M:GiveXP(SKILL_COMBAT,2)
			else
				usr.Public_message("<b>[src] attacks [M] but misses!",MESSAGE_COMBAT)

		Wander()
			var/mob/player/M
			//var/turf/Water/w
			while(src)
				step_rand(src,4)
				sleep(7)
				/*if(M in oview(3))
					step_towards(src,M)
				else*/
				for(M in view(src))
					break
				sleep(7)
			spawn(7)
				Wander()
mob/AI/insects
	var
		obj/lighting/light
		lit=0
	proc
		Fly()
			for ( var/turf/turf in view(3,src) )
				turf.CheckEnviorment()
			var/turf/Water/w
		//	var/turf/Cave_Wall/c
		///	var/obj/building/b
			if(w in oview(3))
				step_away(src,w,3)
		//		step_away(src,c,2)
		//		step_away(src,b,2)
				spawn(7)
				Fly()
			else
				step_rand(src,3)
				spawn(7)
				Fly()

		isLit()
			for ( var/mob/AI/insects/Fire_Flies/ffly in view(3,src))
				if(get_dist(src,ffly) < ffly.luminosity)
					return 1



obj/item/food/meat/animal
	Hog_Meat
		icon='meat.dmi'
		icon_state="hog"
		CookingSkill = 3
		layer=16
		ghp=10
		weight=6

mob/AI/animal/Hog
	icon='hog.dmi'
	damage=5

mob/AI/insects/Fire_Flies
	luminosity = 3
	icon='fireflies.dmi'
	isLit()
	Bump(mob/M)
		if(M.client)
			src.density=0
			sleep(1)
			src.density=1