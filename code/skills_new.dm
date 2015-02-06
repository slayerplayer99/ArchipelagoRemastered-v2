// Couldn't think of a better way to access the skills list..
#define	SKILL_BUILDING		1
#define SKILL_CRAFTING  	2
#define SKILL_SMITHING		3
#define SKILL_MINING		4
#define SKILL_FARMING		5
#define SKILL_ALCHEMY		6
#define SKILL_FISHING		7
#define SKILL_SWIMMING		8
#define SKILL_LUMBERJACK	9


/*

	General 'skill' datum to assign for all future skills to increase ease of use and
	to provide easier insetion for future skills -- if necessary.

*/


skill
	var
		level = 1
		max_level = 10
		xp = 1
		xpNeeded = 100
	proc
		// if you do level up, returns a value so it's possible to know
		addXp(xpGained)
			var lvlUp = 0
			xp += xpGained
			if (xp > xpNeeded)
				levelUp()
				lvlUp = 1
			return lvlUp
		levelUp()
			level += 1
			xpNeeded = xpNeeded * 2  //Make a better function for this in the future
			xp = 1;
		toText()
			return "[level]"
		getChance(difficulty) //where difficulty is some base difficulty modifier for any skill
			var chance = 50 + ((level - difficulty) * 2)
			return prob(chance)
		getXP()
			return "[xp]"
		getXPNeeded()
			return "[xpNeeded]"







/*
	Implementation of the skills inside of the player
*/
mob
	player
		var
			skill
				building
				crafting
				smithing
				mining
				farming
				alchemy
				fishing
				swimming
				lumberjack
			skillList[]
		proc
			addSkillsToList()
				skillList.Add(building)
				skillList.Add(crafting)
				skillList.Add(smithing)
				skillList.Add(mining)
				skillList.Add(farming)
				skillList.Add(alchemy)
				skillList.Add(fishing)
				skillList.Add(swimming)
				skillList.Add(lumberjack)
			/*getSkillName(skillName)
				switch ( skillName )
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
					if ( SKILL_COMBAT )		return "Combat"*/
			getSkill(skillName)
				return skillList[skillName]

			addToPanel()
				for (i=1,i<=skillList.len,i++)
					statpanel("Skills",GetSkillName(skill),"[colour][GetSkill(skill)]")

