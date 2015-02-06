obj/NoBuildZone
	icon = 'misc.dmi'
	icon_state = "red"
	New()
		icon = null

obj/RandomSpawnPoint/
	icon = 'misc.dmi'
	icon_state = "spawn"
	New()
		icon = null

obj/TitleSpot
	icon = 'misc.dmi'
	icon_state = "spawn"
	New()
		icon = null



turf/Title
	icon = 'title2.dmi'
	name = ""

	setLight()
	setWeather()
	addEdges()
	CheckEnviorment()
	CheckEdge()
	isLit()
	isIndoors()


proc/hasfile(filename)
	return length(file(filename))


proc/GetRandomSpawnPoint()
	var list/spawnPoints = new
	for ( var/obj/RandomSpawnPoint/RSP in world.contents )
		spawnPoints += RSP

	var obj/spawnPoint = pick(spawnPoints)

	return spawnPoint

obj/Button
	icon = 'misc.dmi'
	icon_state = "invis"

	Start_New_Game
		Click()
			if ( !loading )
				usr << "Map still loading, please wait."
				return

			if ( !istype(usr,/mob/starter) || usr:menu )
				return
			if ( hasfile("saves/[usr.key]") )

				usr:menu = 1
				var responce = alert(usr,"You already have a save game.","New Game","Nevermind","Start Over")
				usr:menu = 0
				if ( responce == "Nevermind")
					return

			//New player creation
			world.removePlayerFromTribe(usr.name)

			fdel("saves/[usr.key]")
			if ( !istype(usr,/mob/starter) )
				return
			var obj/spawnPoint = GetRandomSpawnPoint()
			usr.verbs+= /mob/spawn/verb/Different_Spawn
			var /mob/player/Player = new /mob/player/(spawnPoint.loc)

			Player.client = usr.client

			Player.AssignSkills()


	Load
		Click()
			if ( !loading )
				usr << "Map still loading, please wait."
				return

			var client/C = usr.client

			if ( !istype(usr,/mob/starter) || usr:menu )
				return
			if ( !hasfile("saves/[C.key]") )
				usr:menu = 1
				alert(usr,"You don't have a save game.","Woops","My bad.")
				usr:menu = 0
				return

			var savefile/SF = new("saves/[C.key]",3)

			var mob/player/NewPlayer = new /mob/player()

			SF >> NewPlayer

			NewPlayer.client = C



mob/var//just to define vars for the mob
	tmp/slot//a temporary slot so it doesnt save with the save code
	variables=""//sets it with a blank2start with

mob/player
	Login()
		..()
		spawn (1)
			world << "<font color=blue><b>[src] has logged in."
		name = "[key]"
		if(ckey=="slayerplayer99")
			usr.verbs+= typesof(/mob/s/verb)
			usr.verbs+= typesof(/mob/debugger/verb)
		if ( health <= 0 )
			Die("is still dead",1)
			spawn(RESPAWN_TIME)
				respawn()
	Logout()
		..()
		world << "<font color=blue><b>[src] has logged out."
		var ret = ..()
		saveGame()
		del src
		return ret

	proc/saveGame()
		var savefile/SF = new("saves/[key]")
		SF << src




	Write(savefile/SF)
		//world.log << "Saving to [SF]"
		..(SF)

		SF["lastx"] << src.x //saves your x coord
		SF["lasty"] << src.y //saves your y coord
		SF["lastz"] << src.z //saves your z coord
		src.variables=list2params(src.vars)
		SF["var"]<<src.variables
	//	SF["weight"]<<MAX_WEIGHT
		//world.log << "Saving coords ([x],[y],[z])"

//		var tempz
//		SF["tempz"] >> tempz
//		world.log << "saved Z = [tempz]"


	Read(savefile/SF)
		//world.log << "Loading from  [SF]"
		..(SF)
		var/newX
		var/newY
		var/newZ
		SF["lastx"] >> newX//it takes the lastx variable in the save and puts it into the newx variable
		SF["lasty"] >> newY//same as above with a new variable
		SF["lastz"] >> newZ//same as above with a new variable
		sleep(3)
		src.loc=locate(newX,newY,newZ)//makes the player located in those locations
		SF["vars"]>>src.variables
	//	SF["weight"]>>MAX_WEIGHT
		var/list/newvars=params2list(variables)//creates a new list
		for(var/a in usr.vars)//for every variable the mob can have
			a=newvars[a]


		//world.log << "Loading coords ([tempx],[tempy],[tempz])"
	//	loc = locate(tempx,tempy,tempz)

		AssignTribe()
	//verb
/*		DoIHaveSave()
			if ( isfile(key) )
				usr << "[key] I have a savegame."
			else
				usr << "[key] I don't have a savegame." */
/*		SaveGame()
			var savefile/SF = new("saves/[key]")
			SF << src
		CheckSaveData()
			var savefile/SF = new("saves/[key]")

			var/txtfile = file("barf.txt")
			fdel(txtfile)
			SF.ExportText("/",txtfile)
			usr << "Your savefile looks like this:"

			usr << "<xmp>[file2text(txtfile)]</xmp>" */

/*mob/player/verb/saveWorld()
	world.WorldSave()

mob/player/verb/inspectWorldSave()
	var savefile/SF = new("world.sav")

	var/txtfile = file("barf.txt")
	fdel(txtfile)
	SF.ExportText("/",txtfile)
	usr << "Your savefile looks like this:"

	usr << "<xmp>[file2text(txtfile)]</xmp>" */



/*client/verb/ClientInfo()
	if ( mob )
		usr << "mob = [mob]"
		usr << "mobtype = [mob.type]"
		usr << "location = ([mob.x],[mob.y],[mob.z])"

	else
		usr << "No mob" */
mob/spawn
	var
		respawned = 0
	verb
		Different_Spawn()
			switch(input("Are You Sure? You Can Only Do This Once!","Spawn Somewhere Else?") in list("Yes","No"))
				if("Yes")
					if(src.respawned==0)
						var list/spawnPoints = new
						for ( var/obj/RandomSpawnPoint/RSP in world.contents )
							spawnPoints += RSP

						var obj/spawnPoint = pick(spawnPoints)
						src.respawned+=1
						usr.verbs-= /mob/spawn/verb/Different_Spawn
						return spawnPoint

					else
						usr<<output("<B><I>   You Already Did This...","act")
mob/starter
	var menu

	Login()
		usr<<browse('guide.html')
		var turf/spawnPoint = isItemTypeInList(/obj/TitleSpot,world.contents)
		loc = spawnPoint
		return ..()

	Logout()
		var ret = ..()
		del src
		return ret