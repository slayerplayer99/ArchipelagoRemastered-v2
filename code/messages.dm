#define MESSAGE_HUNGER		1
#define MESSAGE_THIRST		2
#define MESSAGE_SEARCHING	3
#define MESSAGE_PLUCKING	4
#define MESSAGE_DOOR		5
#define MESSAGE_CONTAINER	6
#define MESSAGE_COMBINING	7
#define MESSAGE_SWIMMING	8
#define MESSAGE_DRINKING	9
#define MESSAGE_CRAFTING	10
#define MESSAGE_FISHING		11
#define MESSAGE_COOKING		12
#define MESSAGE_FARMING		13
#define MESSAGE_GEOGRAPHY	14
#define MESSAGE_BUILDING	15
#define MESSAGE_LUMBERJACK	16
#define MESSAGE_WATERING	17
#define MESSAGE_FIRE 		18
#define MESSAGE_EATING		19
#define MESSAGE_ALCHEMY		20
#define MESSAGE_MINING		21
#define	MESSAGE_SMITHING	22
#define MESSAGE_SMELTING	23
#define MESSAGE_COMBAT		24


atom/proc/Public_message(mes,mesType)
	for ( var/mob/player/player in viewers(world.view,src) )
		gameMessage(player,mes,mesType)

proc/gameMessage(mob/target,mes,mesType)
	if ( mesType )
		var colour = getMessageColour(mesType)
		var mesName = getMessageName(mesType)
		target << "<FONT COLOR=[colour]>(Game - [mesName]) [mes]"
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