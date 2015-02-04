
atom/proc/Public_message(mes,mesType)
	for ( var/mob/player/player in viewers(world.view,src) )
		gameMessage(player,mes,mesType)

proc/gameMessage(mob/target,mes,mesType)
	if ( mesType )
		var colour = getMessageColour(mesType)
		var mesName = getMessageName(mesType)
		target << output("<FONT COLOR=[colour]><B>\[Game - [mesName]]</B> [mes]","act")
	else
		target << mes
proc
	getMessageColour(mesType)
		switch (mesType)
			if ( MESSAGE_HUNGER )		return "red"
			if ( MESSAGE_THIRST )		return "red"
			if ( MESSAGE_SEARCHING )	return "olive"
			if ( MESSAGE_PLUCKING )		return "olive"
			if ( MESSAGE_DOOR )			return "brown"
			if ( MESSAGE_CONTAINER )	return "purple"
			if ( MESSAGE_COMBINING )	return "silver"
			if ( MESSAGE_SWIMMING )		return "blue"
			if ( MESSAGE_DRINKING )		return "aqua"
			if ( MESSAGE_CRAFTING )		return "teal"
			if ( MESSAGE_FISHING )		return "blue"
			if ( MESSAGE_COOKING )		return "maroon"
			if ( MESSAGE_FARMING )		return "green"
			if ( MESSAGE_GEOGRAPHY )	return "blue"
			if ( MESSAGE_BUILDING )		return "navy"
			if ( MESSAGE_LUMBERJACK )	return "#964B00" //brown
			if ( MESSAGE_WATERING )		return "aqua"
			if ( MESSAGE_FIRE )			return "red" //slightly dark red
			if ( MESSAGE_ALCHEMY )		return "fuchsia"
			if ( MESSAGE_MINING )		return "silver"
			if ( MESSAGE_SMELTING )		return "maroon"
			if ( MESSAGE_SMITHING )		return "teal"
			if ( MESSAGE_COMBAT )		return "red"




	getMessageName(mesType)
		switch (mesType)
			if ( MESSAGE_HUNGER )		return "Hunger"
			if ( MESSAGE_THIRST )		return "Thirst"
			if ( MESSAGE_SEARCHING )	return "Searching"
			if ( MESSAGE_PLUCKING )		return "Plucking"
			if ( MESSAGE_DOOR )			return "Door"
			if ( MESSAGE_CONTAINER )	return "Container"
			if ( MESSAGE_COMBINING )	return "Combining"
			if ( MESSAGE_SWIMMING )		return "Swimming"
			if ( MESSAGE_DRINKING )		return "Drinking"
			if ( MESSAGE_CRAFTING )		return "Crafting"
			if ( MESSAGE_FISHING )		return "Fishing"
			if ( MESSAGE_COOKING )		return "Cooking"
			if ( MESSAGE_FARMING )		return "Farming"
			if ( MESSAGE_GEOGRAPHY )	return "Geography"
			if ( MESSAGE_BUILDING )		return "Building"
			if ( MESSAGE_LUMBERJACK )	return "Lumberjack"
			if ( MESSAGE_WATERING )		return "Watering"
			if ( MESSAGE_FIRE )			return "Fire"
			if ( MESSAGE_ALCHEMY )		return "Alchemy"
			if ( MESSAGE_MINING )		return "Mining"
			if ( MESSAGE_SMELTING )		return "Smelting"
			if ( MESSAGE_SMITHING )		return "Smithing"
			if ( MESSAGE_COMBAT )		return "Combat"
