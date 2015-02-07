Building
	var
		buildTime
		materials
		xpGained
		skillNeeded
	proc


mob
	player
		proc
			getChance(mob/player/player)
				var skill = player.GetSkill(SKILL_BUILDING)
				var chance = 50 + 8 * ( skill - skillNeeded )
				return chance