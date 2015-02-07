stat
	var/value = 0
	var/max_value = 0

	New(n)
		if(n)
			value = n
			max_value = n

	proc/add(n)
		value = min(max(value + n, 0), max_value)
	proc/toText()
		return "[value]/[max_value]"

mob/player
	var/stat/health
	var/stat/stamina
	var/stat/hunger
	var/stat/thirst

	New()
		..()
		health = new(100)
		stamina = new(100)
		hunger = new(100)
		thirst = new(100)