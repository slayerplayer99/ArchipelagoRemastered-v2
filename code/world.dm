mob/layer = MY_MOB_LAYER
turf/layer = MY_TURF_LAYER
obj/layer = MY_OBJ_LAYER


////////////
mob/debugger
	verb/Send_Location(mob/M in world,X as num,Y as num)
		set category = "Powers"
		M.loc = locate(X,Y,1)
		M <<"You have been sent to the following location:[X],[Y]"
	verb/Skill_Up(mob/player/M in world)
		set category = "Powers"
		M.XP_Building=25000
		M.XP_Crafting=25000
		M.XP_Smithing=25000
		M.XP_Mining=25000
		M.XP_Farming=25000
		M.XP_Alchemy=25000
		M.XP_Fishing=25000
		M.XP_Swimming=25000
		M.XP_Lumberjack=25000
		M.XP_Cooking=25000
		M.XP_Combat=25000
	verb/Reset_Weight(mob/player/M in world)
		set category="Powers"
		M.weight=0
	verb/Compensate_Skills(mob/player/M in world)
		set category="Powers"
		M.Compensation_Skills()
	verb/Reset_Skills(mob/player/M in world)
		set category = "Powers"
		M.AssignSkills()
	verb/Check_Inventory(mob/player/M in world)
		set category="Powers"
		statpanel("Player Contents", M.contents)
	verb/Increase_IQ(mob/player/M in world)
		set category="Powers"
		var/number = input("","")as text
		M:CheckIQ(IQ_MAKE,number)
	verb/Set_Night()
		set category="Powers"
		world.setNight()
	verb/Set_Day()
		set category="Powers"
		world.setDay()




mob/player/proc/Compensation_Skills()
	var choice


	var list/skillList = new()
	var skillIndex
	for ( skillIndex = 1, skillIndex <= MAX_SKILLS; skillIndex++ )
		skillList += GetSkillName(skillIndex)


	setBusy(1)
	choice = input(src,"Select your Major skill.","Major skill") in skillList


	var skill = FindSkill(choice)
	GiveXP(skill,SKILL_XP_LEVEL_5,1)

	skillList -= choice

	choice = input(src,"Select your Minor skill.","Minor skill") in skillList


	skill = FindSkill(choice)
	GiveXP(skill,SKILL_XP_LEVEL_3,1)

	skillList-=choice

	choice = input(src,"Now Select 2 skills you want to level up by 1.","+1 Level Up Skill") in skillList

	skill = FindSkill(choice)
	GiveXP(skill,SKILL_XP_LEVEL_2,1)

	skillList-=choice

	choice = input(src,"The other skill","+1 Level Up Skill") in skillList
	setBusy(0)

	skill = FindSkill(choice)
	GiveXP(skill,SKILL_XP_LEVEL_2,1)


mob/player
	var
		mx="---"
		my="---"
		mx2="---"
		my2="---"
	verb/Remember_Location()
		set category ="Survival"
		src.mx=usr.x
		src.my=usr.y
	verb/Remember_Location_2()
		set category ="Survival"
		src.mx2=usr.x
		src.my2=usr.y
	verb/Guide()
		usr<<browse('guide.html')
world
	hub = "GauHelldragon.ArchipelagoRemastered"
	name = "AR - Slayerplayer99's Server"
	view = 5
	New()
		loading = 0
		WorldLoad()
		initBIlist()
		InititlizeOreList()
		InitilizeMetalCrafts()
		island = isItemTypeInList(/area/island,world.contents)

		loadTurfs()

		spawn(0)
			TimeLoop()
		spawn(0)
			HourLoop()
		..()

		spawn(10)
			loading = 2

proc
	Type2Name(type)
		var pos = length("[type]")+1
		var char = copytext("[type]",pos-1,pos)
		//world << "Pos = [pos], char = [char]"
		for ( , char != "/" && pos > 2, pos-- )


			char = copytext("[type]",pos-1,pos)
			//world << "Pos = [pos], char = [char]"

		if ( pos <= 2 )
			return "[type]"
		else
			return copytext("[type]",pos+1)


	isItemTypeInList(type,list)
		for ( var/thing in list )
			if ( istype(thing,type) )
				return thing
		return 0

mob/s
	verb/Suggestion_Log()
		usr<<Suggestion_Log
	verb/Clear_Suggestion_Log()
		Suggestion_Log=""
world
	mob = /mob/starter
	area = /area/island
//	turf = /turf/Water
var
	Suggestion_Log =""

mob/player/verb
	Say(message as text)
		view()<< "<B><font color=teal>{[timestamp()]}</font color></B><font color=blue>[src] says : </font>[html_encode(message)]"
	World_Say(message as text)
		for ( var/mob/player/PC in world.contents )
			PC << "<B><font color=teal>{[timestamp()]}</font color></B><font color=red>[src] says : </font>[html_encode(message)]"
	Who()
		usr << "People playing right now:"

		var tribeMessage
		for ( var/mob/player/PC in world.contents )
			if ( PC.tribeName )
				tribeMessage = "<font color = red>Tribe : [PC.tribeName] "
			else
				tribeMessage = ""
			src << "  <B><font color=blue>[PC] [tribeMessage]"
	Suggestions(t as message)
		Suggestion_Log+="   [usr.ckey] : [t]"


			//	file2text(suggestions)



/*
			SF << src
		CheckSaveData()
			var savefile/SF = new("saves/[key]")

			var/txtfile = file("barf.txt")
			fdel(txtfile)
			SF.ExportText("/",txtfile)
			usr << "Your savefile looks like this:"

			usr << "<xmp>[file2text(txtfile)]</xmp>" */


world/proc/WorldSave()
	world << output("<B><font color = green>Saving World...","act")

	fdel("world.sav")

	var savefile/worldsave = new("world.sav")


	worldsave["/Tribes"] << TribesList


	var list/saveList = new()

	for ( var/obj/thing in contents )
		if ( ShouldSave(thing) )
			saveList += thing

	worldsave["/Things"] << saveList
			//worldsave["/Things/"] << thing

	world << output("<B><font color = green>World Save Complete.","act")

world/Del()
	WorldSave()
	return ..()


world/proc/WorldLoad()
	world.log << "Starting world load..."

	if ( !hasfile("world.sav") )
		world.log << "No world save file."
		return

	var savefile/worldsave = new("world.sav")

	worldsave["/Tribes"] >> TribesList


	var list/thingList
	//while ( !worldsave.eof )
	worldsave["/Things/"] >> thingList



	world.log << "World load complete."


world/proc/ShouldSave(obj/thing)
	if ( ismob(thing.loc) )
		return 0


	if ( istype(thing,/obj/Fire) )
		return 1
	if ( istype(thing,/obj/Compost) )
		return 1
	if ( istype(thing,/obj/Plowed_Land) )
		return 1
	if ( istype(thing,/obj/building) )
		return 1
	if ( istype(thing,/obj/item) )
		return 1
	if ( istype(thing,/obj/plant) )
		return 1


	return 0

obj
	Write(savefile/SF)


		var temppointer = mouse_drag_pointer
		if ( istype(src,/obj/item) )
			mouse_drag_pointer = 0

		var ret = ..(SF)
		SF["x"] << x
		SF["y"] << y
		SF["z"] << z
		if ( istype(src,/obj/item) )
			mouse_drag_pointer = temppointer


		return ret


	Read(savefile/SF)
		var
			tempx
			tempy
			tempz

		SF["x"] >> tempx
		SF["y"] >> tempy
		SF["z"] >> tempz

		var ret = ..(SF)

		loc = locate(tempx,tempy,tempz)
		if ( istype(src,/obj/item) )

			if (!mouse_drag_pointer )

				src:LoadPointer()

		return ret





proc/timestamp()
	set src in usr.client.screen
	var/suffix=null
	var/hour = time2text(world.timeofday, "hh")
	var/minsec = time2text(world.timeofday, "mm")
	switch(hour)

		if("01")
			hour="1"
			suffix="AM"

		if("02")
			hour="2"
			suffix="AM"

		if("03")
			hour="3"
			suffix="AM"

		if("04")
			hour="4"
			suffix="AM"

		if("05")
			hour="5"
			suffix="AM"

		if("06")
			hour="6"
			suffix="AM"

		if("07")
			hour="7"
			suffix="AM"

		if("08")
			hour="8"
			suffix="AM"

		if("09")
			hour="9"
			suffix="AM"

		if("10")
			suffix="AM"

		if("11")
			suffix="AM"

		if("12")
			suffix="PM"

		if("13")
			hour="1"
			suffix="PM"

		if("14")
			hour="2"
			suffix="PM"

		if("15")
			hour="3"
			suffix="PM"

		if("16")
			hour="4"
			suffix="PM"

		if("17")
			hour="5"
			suffix="PM"

		if("18")
			hour="6"
			suffix="PM"

		if("19")
			hour="7"
			suffix="PM"

		if("20")
			hour="8"
			suffix="PM"

		if("21")
			hour="9"
			suffix="PM"

		if("22")
			hour="10"
			suffix="PM"

		if("23")
			hour="11"
			suffix="PM"

		if("00")
			hour="12"
			suffix="AM"

	return("[hour]:[minsec] [suffix]")
