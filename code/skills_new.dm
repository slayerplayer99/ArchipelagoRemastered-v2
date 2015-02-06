skill
	var
		level = 1
		max_level = 10
		xp = 1
		xpNeeded = 100
	proc
		addXp(xpGained)
			xp += xpGained
			if (xp > xpNeeded)
				levelUp()
		levelUp()
			level += 1
			xpNeeded = xpNeeded * 2  //Make a better function for this in the future
			xp = 1;
		toText()
			return "[level]"
		getChance(difficulty) //where difficulty is some base difficulty modifier for any skill
			chance = 50 + ((level - difficulty) * 2)
			return prob(chance)