/mob/var/strength = 1
/mob/var/agility = 1
/mob/var/endurance = 1
/mob/var/vitality = 10
/mob/var/control = 1
/mob/var/stamina = 10
/mob/var/speed = 1
/mob/var/stat_cap = 400
/mob/var/stat_points = 9
/mob/var/health = 50
/mob/var/maxhealth = 50
/mob/var/chakra = 100
/mob/var/trait_text
/mob/var/list/able_bodied = list()
/mob/proc/allocate_stats(stat)
	if(stat_points > 0 && !is_capped())
		var/stat_limit = round((total_stats() + stat_points) / archive.stat_limit_reducer)
		switch(stat)
			if("strength")
				if(Trait == "Able-Bodied" && "strength" in able_bodied)
					if(strength < stat_limit + _get_step_size(get_grade_stat(stat_limit)))
						strength++
						stat_points--
				else
					if(strength < stat_limit)
						strength++
						stat_points--
			if("endurance")
				if(Trait == "Able-Bodied" && "endurance" in able_bodied)
					if(endurance < stat_limit + _get_step_size(get_grade_stat(stat_limit)))
						endurance++
						stat_points--
				else
					if(endurance < stat_limit)
						endurance++
						stat_points--
			if("agility")
				if(Trait == "Able-Bodied" && "agility" in able_bodied)
					if(agility < stat_limit + _get_step_size(get_grade_stat(stat_limit)))
						agility++
						stat_points--
				else
					if(agility < stat_limit)
						agility++
						stat_points--
			if("speed")
				if(Trait == "Able-Bodied" && "speed" in able_bodied)
					if(speed < stat_limit + _get_step_size(get_grade_stat(stat_limit)))
						speed++
						stat_points--
				else
					if(speed < stat_limit)
						speed++
						stat_points--
			if("stamina")
				if(Trait == "Able-Bodied" && "stamina" in able_bodied)
					if(stamina < stat_limit + _get_step_size(get_grade_stat(stat_limit)))
						stamina++
						stat_points--
				else
					if(stamina < stat_limit + 10)
						stamina++
						stat_points--
			if("control")
				if(control < stat_limit)
					control++
					stat_points--
		if(character_box)
			character_box.update_stats(src)
			character_box.update_info(src)
			if(Trait == "Skilled")
				if(got_skill == 0 && total_stats()-30 >= 140)
					got_skill++
					points["skill"]++
				else if(got_skill == 1 && total_stats()-30 >= 220)
					points["skill"]++
					got_skill++
				else if(got_skill == 2 && total_stats()-30 >= 269)
					points["skill"]++
					got_skill++
				else if(got_skill == 3 && total_stats()-30 >= 309)
					points["skill"]++
					got_skill++
/mob/proc/is_capped()
	return total_stats() >= stat_cap

/mob/proc/total_stats()
	return strength + endurance + agility + speed + stamina + control - 15


/mob/proc/can_attack(var/mob/M)
	if(!(!resting && !KO && move && !M.KO && M.attackable && (!attacking && !(grabbee || grabber)) && chakra > 0))
		return 0
	return 1

/*/mob/proc/take_damage(amount)
	health -= amount
	if(character_box)
		character_box.update_bars(src)*/

/mob/proc/get_targets()
	var/list/targets = list()
	for(var/mob/M in get_step(src, dir))
		targets += M
	if(grabbee) targets += grabbee
	if(grabber) targets += grabber
	return targets

/mob/proc/damage_message(mob/attacker, damage)
	var/damage_amount
	if(damage <= 2)
		damage_amount = pick(
		", but the blow is useless",
		", but barely does any damage",
		", but the blow doesn't land solidly",
		", but it doesn't seem to do a thing")
	else if(damage >= 50)
		damage_amount = pick(
		", doing incomprehensible damage")
	else if(damage >= 35)
		damage_amount = pick(
		", doing horrible damage",
		", doing grevious damage",
		", doing incredible damage",
		", doing extreme damage")
	else if(damage >= 25)
		damage_amount = pick(
		", heavily bruising the muscle and rattling bone",
		", horribly bruising the muscle and fracturing bone")

	var/damage_type
	if(damage >= 50)
		damage_type = pick(
		"hulk smashes")
	else if(damage >= 35)
		damage_type = pick(
		"smashes")
	else if(damage >= 25)
		damage_type = pick(
		"punches",
		"elbows",
		"palm strikes",
		"knees",
		"kicks")
	else
		damage_type = pick(
		"punches",
		"elbows",
		"palm strikes",
		"knees",
		"kicks")

	view() << "<font color=[hit_color]>[attacker] [damage_type] [src][damage_amount]."

/mob/proc/miss_message(mob/victim)
	view() << "<font color=[miss_color]>[src] completely misses [victim]."
/mob/proc/_get_step_size(var/grade_letter)
	if(grade_letter == "S")
		return 12
	if(grade_letter in list("A-", "A", "A+"))
		return 11
	if(grade_letter in list("B-", "B", "B+"))
		return 10
	if(grade_letter in list("C-", "C", "C+"))
		return 7
	if(grade_letter in list("D-", "D", "D+"))
		return 5
	return 5
proc/get_grade_stat(var/value = 0, var/stam = 0)
	if(stam) value -= 10
	if(value > 132) return "S+"
	if(value > 120) return "S"
	if(value > 109) return "S-"
	if(value > 98) return "A+"
	if(value > 87) return "A"
	if(value > 77) return "A-"
	if(value > 65) return "B+"
	if(value > 55) return "B"
	if(value > 45) return "B-"
	if(value > 38) return "C+"
	if(value > 31) return "C"
	if(value > 24) return "C-"
	if(value > 19) return "D+"
	if(value > 14) return "D"
	if(value > 9) return "D-"
	if(value > 4) return "E+"
	return "E"
proc/return_stat_grade(var/value = "E")
	if(value == "S+") return 133
	if(value == "S") return 121
	if(value == "S-") return 110
	if(value == "A+") return 99
	if(value == "A") return 88
	if(value == "A-") return 78
	if(value == "B+") return 66
	if(value == "B") return 56
	if(value == "B-") return 46
	if(value == "C+") return 39
	if(value == "C") return 32
	if(value == "C-") return 25
	if(value == "D+") return 20
	if(value == "D") return 15
	if(value == "D-") return 10
	if(value == "E+") return 5
	return 1
/var/miss_color = "#999999"
/var/hit_color = "#FFFFFF"

/var/tmp/attack_timer = 0

/mob/verb/Attack()
	set category = "Combat"

	if(world.realtime < attack_timer)
		return

	attack_timer = world.realtime + 10

	for(var/mob/m in get_step(src, dir))
		flick("Attack", src)
		break
		//if(prob(2)) m.surrender()


////////////////////////////////////
//////////////Avainer 10/1/2017/////
////////////////////////////////////

mob
	var
		stamina_current = 10
		list/recentlyrestore = list()
		chakra_current = 1

		calories_current = 0

		swarms_current = 0


	verb
		restore_chakra()
			set category = "Combat"
			var/d
			var/c = input(usr,"What would you like to restore your chakra by?","Your current chakra: [(chakra_current / get_chakra() ) *100]%") in list("Cancel","D","C","B","A","S","Full")
			switch(c)
				if("Cancel")
					return
				if("D")
					d = 3
				if("C")
					d = 6
				if("B")
					d = 14
				if("A")
					d = 34
				if("S")
					d = 70
				if("Full")
					d = get_chakra()
			src.recentlyrestore = list("[c]", "chakra", "[(chakra_current/get_chakra())*100]", world.realtime)
			chakra_current += d
			if(chakra_current >= get_chakra())
				chakra_current = get_chakra()
			if(character_box)
				character_box.update_bars(src)
			src._output(list("chakra", "[c]", "restored"), "stat", "outputall.output")
			src._output(list("chakra", "[c]", "restored"), "stat", "outputic.output")
		deduct_chakra()
			set category = "Combat"
			var/critical
			var/d
			var/c = input(usr,"What would you like to deduct your chakra by?","Your current chakra: [(chakra_current / get_chakra() ) *100]%") in list("Cancel","D","C","B","A","S")
			switch(c)
				if("Cancel")
					return
				if("D")
					d = 3
				if("C")
					d = 6
				if("B")
					d = 14
				if("A")
					d = 34
				if("S")
					d = 70
			if(chakra_current - d < 0)
				alert("You do not have enough chakra to perform this action.")
				return
			var/percentage = ((chakra_current-d)/get_chakra()) * 100
			if(percentage< 20)
				switch(input("Are you sure you want to do this? This will take you to [percentage]% chakra.") in list("No","Yes"))
					if("No")
						return
				critical = 1
			chakra_current -= d
			if(character_box)
				character_box.update_bars(src)
			src._output(list("chakra", "[c]", "deducted"), "stat", "outputall.output")
			src._output(list("chakra", "[c]", "deducted"), "stat", "outputic.output")
			if(critical)
				src._output("is at [percentage]% chakra!! ", "oocalert", "outputall.output")
				src._output("is at [percentage]% chakra!! ", "oocalert", "outputic.output")
		restore_stamina()
			set category = "Combat"
			var/d
			var/c = input(usr,"What would you like to restore your stamina by?","Your current stamina: [(stamina_current / get_stamina() ) *100]%") in list("Cancel","D","C","B","A","S","Full")
			switch(c)
				if("Cancel")
					return
				if("D")
					d = 3
				if("C")
					d = 6
				if("B")
					d = 14
				if("A")
					d = 34
				if("S")
					d = 70

				if("Full")
					d = get_stamina()
			src.recentlyrestore = list("[c]", "stamina", "[(stamina_current/get_stamina())*100]", world.realtime)
			stamina_current += d
			if(stamina_current >= get_stamina())
				stamina_current = get_stamina()

			if(character_box)
				character_box.update_bars(src)
			src._output(list("stamina", "[c]", "restored"), "stat", "outputall.output")
			src._output(list("stamina", "[c]", "restored"), "stat", "outputic.output")
		deduct_stamina()
			set category = "Combat"
			var/d
			var/c = input(usr,"What would you like to deduct your stamina by?","Your current stamina: [(stamina_current / get_stamina() ) *100]%") in list("Cancel","D","C","B","A","S")
			switch(c)
				if("Cancel")
					return
				if("D")
					d = 3
				if("C")
					d = 6
				if("B")
					d = 14
				if("A")
					d = 34
				if("S")
					d = 70
			if(stamina_current - d < 0)
				alert("You do not have enough stamina to perform this action.")
				return
			var/critical = 0
			var/percentage = ((stamina_current-d) / get_stamina()) * 100
			if(percentage < 20)
				switch(input("Are you sure you want to do this? This will take you to [percentage]% stamina.") in list("No","Yes"))
					if("No")
						return
				critical = 1
			stamina_current -= d
			if(stamina_current <= 0)
				stamina_current = 0
			if(character_box)
				character_box.update_bars(src)
			src._output(list("stamina", "[c]", "deducted"), "stat", "outputall.output")
			src._output(list("stamina", "[c]", "deducted"), "stat", "outputic.output")
			if(critical)
				src._output("is at [percentage]% stamina!! ", "oocalert", "outputall.output")
				src._output("is at [percentage]% stamina!! ", "oocalert", "outputic.output")
		chakra()
			set category = "Combat"
			var/mob/controlMob = usr
			if(controlMob.MindTransfer) controlMob=controlMob.MindTransfer
			var/c = get_grade_stat((src.control*0.7)+(src.stamina*0.3)+ chakra_boost_pool())
			for(var/mob/M in hearers(16,controlMob))
				if(M.MindTransfer) if(M == M.MindTransfer.MindAfflicted) continue
				if(M.MindAfflicted)
					M.MindAfflicted << output("<i>[M.MindAfflicted.getStrangerName(src)] - Chakra: [c]</i>", "outputall.output")
				else M << output("<i>[M.getStrangerName(src)] - Chakra: [c]</i>", "outputall.output")
	proc
		get_chakra()	
			var/c = get_grade_stat((src.control*0.7)+(src.stamina*0.3)+ chakra_boost_pool())
			switch(c)
				if("E")
					return 6
				if("E+")
					return 9
				if("D-")
					return 12
				if("D")
					return 15
				if("D+")
					return 21
				if("C-")
					return 33
				if("C")
					return 45
				if("C+")
					return 60
				if("B-")
					return 70
				if("B")
					return 85
				if("B+")
					return 91
				if("A-")
					return 115
				if("A")
					return 140
				if("A+")
					return 180
				if("S-")
					return 220
				if("S")
					return 260
				if("S+")
					return 300

		get_stamina()
			var/c = get_grade_stat(stamina+stamina_boost_pool(),1)
			switch(c)
				if("E")
					return 6
				if("E+")
					return 9
				if("D-")
					return 12
				if("D")
					return 15
				if("D+")
					return 21
				if("C-")
					return 33
				if("C")
					return 45
				if("C+")
					return 60
				if("B-")
					return 70
				if("B")
					return 85
				if("B+")
					return 91
				if("A-")
					return 115
				if("A")
					return 140
				if("A+")
					return 180
				if("S-")
					return 220
				if("S")
					return 260
				if("S+")
					return 300
		get_calories()
			var/c = get_grade_stat(stamina+stamina_boost_pool()-15+calories_boost_pool(),1)
			switch(c)
				if("E")
					return 3
				if("E+")
					return 5
				if("D-")
					return 9
				if("D")
					return 12
				if("D+")
					return 15
				if("C-")
					return 18
				if("C")
					return 24
				if("C+")
					return 30
				if("B-")
					return 44
				if("B")
					return 58
				if("B+")
					return 71
				if("A-")
					return 104
				if("A")
					return 118
				if("A+")
					return 162
				if("S-")
					return 200
				if("S")
					return 200
				if("S+")
					return 200
		get_swarms()
			var/c = get_grade_stat( ( ((src.control + src.stamina) / 2 )+chakra_boost_pool() )) // chakra + swarm boost
			switch(c)
				if("E")
					return 1 + swarms_boost_pool()
				if("E+")
					return 2 + swarms_boost_pool()
				if("D-")
					return 3 + swarms_boost_pool()
				if("D")
					return 4 + swarms_boost_pool()
				if("D+")
					return 6 + swarms_boost_pool()
				if("C-")
					return 7 + swarms_boost_pool()
				if("C")
					return 8 + swarms_boost_pool()
				if("C+")
					return 10 + swarms_boost_pool()
				if("B-")
					return 12 + swarms_boost_pool()
				if("B")
					return 14 + swarms_boost_pool()
				if("B+")
					return 16 + swarms_boost_pool()
				if("A-")
					return 20 + swarms_boost_pool()
				if("A")
					return 22 + swarms_boost_pool()
				if("A+")
					return 26 + swarms_boost_pool()
				if("S-")
					return 30 + swarms_boost_pool()
				if("S")
					return 30 + swarms_boost_pool()
				if("S+")
					return 30 + swarms_boost_pool()
/*
Swarms
Swarm Costs per Jutsu
D = 1
C = 2
B = 6
A = 10

Max Swarms @ Chakra
D = 4
C = 8
B = 14
A = 22(edited)
*/