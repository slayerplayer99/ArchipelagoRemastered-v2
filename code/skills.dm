#define SKILL_XP_LEVEL_2	  100
#define SKILL_XP_LEVEL_3	  250
#define SKILL_XP_LEVEL_4	  500
#define SKILL_XP_LEVEL_5	 1000
#define SKILL_XP_LEVEL_6	 1750
#define SKILL_XP_LEVEL_7	 3000
#define SKILL_XP_LEVEL_8	 5000
#define SKILL_XP_LEVEL_9	 7500
#define SKILL_XP_LEVEL_10	10000
#define SKILL_XP_LEVEL_11	11000
#define SKILL_XP_LEVEL_12	14500
#define SKILL_XP_LEVEL_13	17500
#define SKILL_XP_LEVEL_14	19000
#define SKILL_XP_LEVEL_15	25000

#define	SKILL_BUILDING		1
#define SKILL_CRAFTING  	2
#define SKILL_SMITHING		3
#define SKILL_MINING		4
#define SKILL_FARMING		5
#define SKILL_ALCHEMY		6
#define SKILL_FISHING		7
#define SKILL_SWIMMING		8
#define SKILL_LUMBERJACK	9






proc
	GetSkillName(skill)
		switch ( skill )
			if ( SKILL_BUILDING )	return "Building"
			if ( SKILL_CRAFTING )	return "Crafting"
			if ( SKILL_SMITHING )	return "Smithing"
			if ( SKILL_MINING )		return "Mining"
			if ( SKILL_FARMING )	return "Farming"
			if ( SKILL_ALCHEMY )	return "Alchemy"
			if ( SKILL_FISHING )	return "Fishing"
			if ( SKILL_SWIMMING )	return "Swimming"
			if ( SKILL_LUMBERJACK )	return "Lumberjack"
			if ( SKILL_COOKING )	return "Cooking"
			if ( SKILL_COMBAT )		return "Combat"
	AdjustChance(chance)
		if ( chance < 5 )
			chance = 5
		if ( chance > 95 )
			chance = 95
		return chance

	FindSkill(skillName)
		var skillIndex
		for ( skillIndex = 1, skillIndex <= MAX_SKILLS; skillIndex++ )
			if ( GetSkillName(skillIndex) == skillName )
				return skillIndex

		world.log << "Could not find Skill [skillName]"
		return 0


mob/player
	var
		XP_Building
		XP_Crafting
		XP_Smithing
		XP_Mining
		XP_Farming
		XP_Alchemy
		XP_Fishing
		XP_Swimming
		XP_Lumberjack
		XP_Cooking
		XP_Combat
	proc
		StatSkills()
			var skill

			var colour
			if ( Effect_Type == EFFECT_FEVER )
				colour = "<font color=red"
			if ( Effect_Type == EFFECT_SKILL )
				colour = "<font color=green"

			for ( skill = 1, skill <= MAX_SKILLS, skill++  )
				statpanel("Skills",GetSkillName(skill),"[colour][GetSkill(skill)]")

		GetSkillXP(skill)
			switch ( skill )
				if ( SKILL_BUILDING )   return XP_Building
				if ( SKILL_CRAFTING )   return XP_Crafting
				if ( SKILL_SMITHING )	return XP_Smithing
				if ( SKILL_MINING )		return XP_Mining
				if ( SKILL_FARMING )	return XP_Farming
				if ( SKILL_ALCHEMY )	return XP_Alchemy
				if ( SKILL_FISHING )	return XP_Fishing
				if ( SKILL_SWIMMING )	return XP_Swimming
				if ( SKILL_LUMBERJACK )	return XP_Lumberjack
				if ( SKILL_COOKING )	return XP_Cooking
				if ( SKILL_COMBAT )		return XP_Combat
				else world.log << "Bad Skill number: [skill]"

			return 0
		AddXP(skill,xp)
			switch ( skill )
				if ( SKILL_BUILDING ) 	 XP_Building += xp
				if ( SKILL_CRAFTING ) 	 XP_Crafting += xp
				if ( SKILL_SMITHING )	 XP_Smithing += xp
				if ( SKILL_MINING )		 XP_Mining += xp
				if ( SKILL_FARMING )	 XP_Farming += xp
				if ( SKILL_ALCHEMY )	 XP_Alchemy += xp
				if ( SKILL_FISHING )	 XP_Fishing += xp
				if ( SKILL_SWIMMING )	 XP_Swimming += xp
				if ( SKILL_LUMBERJACK )	 XP_Lumberjack += xp
				if ( SKILL_COOKING )	 XP_Cooking += xp
				if ( SKILL_COMBAT )		 XP_Combat += xp

				else world.log << "Bad Skill number: [skill]"


		GetSkill(skill)

			var level = getSkillLevel(GetSkillXP(skill))

			if ( Effect_Type == EFFECT_FEVER )
				level--
			if ( Effect_Type == EFFECT_SKILL )
				level++


			// TODO: add istype for other skills, like combat

			if ( equipped )
				if ( skill == SKILL_MINING )
					level += equipped.bonus
				if ( skill == SKILL_SMITHING )
					level += equipped.bonus
				if ( skill == SKILL_LUMBERJACK )
					level += equipped.bonus
				if ( skill == SKILL_COMBAT )

					if ( istype(equipped,/obj/item/tool/Dagger) || istype(equipped,/obj/item/tool/Sword) )

						level += equipped.bonus


			return level

		GiveXP(skill,xp,silent=0)
			var oldLevel = GetSkill(skill)
			if ( oldLevel >= 10 )
				return

			AddXP(skill,xp)
			if ( !silent && GetSkill(skill) != oldLevel )
				src << "<B><font color=green>You Gain A Level In [GetSkillName(skill)]!"
				Increase_Weight()


		getSkillLevel(XP)
			if ( XP < SKILL_XP_LEVEL_2 )
				return 1
			if ( XP < SKILL_XP_LEVEL_3 )
				return 2
			if ( XP < SKILL_XP_LEVEL_4 )
				return 3
			if ( XP < SKILL_XP_LEVEL_5 )
				return 4
			if ( XP < SKILL_XP_LEVEL_6 )
				return 5
			if ( XP < SKILL_XP_LEVEL_7 )
				return 6
			if ( XP < SKILL_XP_LEVEL_8 )
				return 7
			if ( XP < SKILL_XP_LEVEL_9 )
				return 8
			if ( XP < SKILL_XP_LEVEL_10 )
				return 9

			return 10

mob/player/proc/getSuccessRate(thing)
	if ( isobj(thing) && istype(thing,/obj/item/food) )

		return getCookingSuccessRate(thing)
	if ( ispath(thing,/obj/item/material/Logs) )
		return AdjustChance(12 + GetSkill(SKILL_LUMBERJACK) * 8)

//	if ( ispath(thing,/obj/building) )
//		return getBuildChance(thing)

	return 50


mob/player/proc/AssignSkills()
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
	setBusy(0)

	skill = FindSkill(choice)
	GiveXP(skill,SKILL_XP_LEVEL_3,1)




// SKILL OBJ XPS
proc/GetObjXPAmount(objType)
	if ( istype(objType,/obj/building) )
		return 15

	return 7

mob/player/proc/GetObjSkillChance(objType)

	if ( isobj(objType) )
		objType = objType:type
	var chance = 50
	var skill = 1
	var itemSkill = 1
	var skillMod = 10

	if ( ispath(objType,/obj/item/glass) )
		chance = 30
		skill = GetSkill(SKILL_CRAFTING)
		if ( ispath(objType,/obj/item/glass/Glass_Jar) )
			itemSkill = 3


	chance += ( skillMod * ( itemSkill - skill ) )

	return AdjustChance(chance)

// LUMBERJACK

//mob/player/proc/FindLogs()
//	return prob(50)

// BUILDING

//mob/player/proc/getBuildChance(datum/buildingInfo/BI)
	//var buildingSkill = getBuildingSkill(BuildType)


datum/buildingInfo/proc/getChance(mob/player/player)
	var Pskill = player.GetSkill(SKILL_BUILDING)

	var chance = 50 + 8 * ( Pskill - skill )

	return AdjustChance(chance)

//mob/player/proc/getRuinChance(datum/buildingInfo/BI)
	//var buildingSkill = getBuildingSkill(BuildType)
datum/buildingInfo/proc/getRuinChance(mob/player/player)
	var Pskill = player.GetSkill(SKILL_BUILDING)

	var chance = 30 - 2 * ( Pskill - skill ) - skill

	return AdjustChance(chance)

datum/buildingInfo/proc/getXP()
	return skill * 10


obj/item/seed/proc/GetPlantXP()
	return farm_skill
obj/item/seed/proc/GetGrowXP()
	return 2*farm_skill


obj/item/seed/proc/GerminateChance(mob/player/planter,fertilized)
	var pSkill = planter.GetSkill(SKILL_FARMING)

	var chance = 50 + 10 * ( pSkill - farm_skill )
	if ( fertilized )
		chance += 25

	return AdjustChance(chance)


obj/item/seed/proc/GetDoubleChance(mob/player/planter,fertilized)
	var pSkill = planter.GetSkill(SKILL_FARMING)

	var chance = 10 + 10 * ( pSkill - farm_skill )
	if ( fertilized )
		chance += 10

	return AdjustChance(chance)
