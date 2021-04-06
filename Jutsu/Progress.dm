/mob/var/last_reward = 0
/proc/get_rank_grade(mob/M, number)
	var/total
	if(number)
		total = number
	else
		total = (M.total_stats()-30)
	if(total > 309) return "SS"
	if(total > 289) return "S+"
	if(total > 269) return "S"
	if(total > 249) return "S-"
	if(total >= 220) return "A+"
	if(total >= 170) return "A"
	if(total >= 155) return "A-"
	if(total >= 140) return "B-"
	if(total >= 125) return "C+"
	if(total >= 110) return "C"
	if(total >= 95) return "C-"
	if(total >= 80) return "D+"
	if(total >= 65) return "D"
	if(total >= 50) return "D-"
	if(total >= 35) return "E+"
	if(total >= 20) return "E"
	return "E-"
var/list/learn_reqs = list("E" = 1, "D" = 200, "C" = 500, "B" = 1000, "A" = 2000, "S" = 3000)
var/list/learn_timers = list("E" = 10, "D" = 600, "C" = 216000, "B" = 864000, "A" = 1#INF, "S" = 1#INF)
/mob/proc/FindScroll(n)
	for(var/obj/items/jutsu_scroll/scroll in src)
		if(scroll.source == n)
			return TRUE
	return FALSE
	
	
obj/progress_card
	name
	desc
	icon
	icon_state
	rank = "E"
	var
		custom = 0
		learn_req = 1
		control_req = 1
		stamina_req = 1
		jutsu_id = 1
		chakra_req = 1
		learn_progress = 1
		learn_timer = 600 // 1 min | 3000 | 5 MIN | 36000  1 hour
		hidden = 0
		jutsu_type
		list/prerequisites = list()
		list/encapsulates = list()
		learning_from
	test
		name = "Body"
		icon = 'Perk.dmi'
		icon_state = "Body"

	test2
		name = "Tailed Chakra"
		icon = 'Perk.dmi'
		icon_state = "Tailed Chakra"
	New()
		set_learn_req()
		..()
	proc/set_learn_req()
		learn_req = learn_req[rank]
	proc/progress(var/mob/M, progress_amount)
		if(!custom)
			learn_progress = 99999
			learn_timer = 1
			check_progress(M)
			return
		// check if you get more progress on this
		// give the points
		//check if you are near ur teacher probably
		//check to see if you are able to learn it
		var/progress_rate = 1// edit this to make you progress faster
		if(M.find_perk("Prodigy"))
			progress_rate += 1
		if(learning_from == "SCROLL") // scroll increases the rate, teacher adds directly to it, 
			if(M.FindScroll(name))
				progress_rate += 0.5
		else if(learning_from && M.teacher_activity)
			progress_rate += 1
			progress_amount += M.teacher_activity
			M.teacher_activity = 0
		progress_amount *= (M.progress_speed * progress_rate)
		learn_progress += progress_amount 
		if(M.character_box)
			M.character_box.update_bars(M)
		if(M.progress_box)
			M.progress_box.update_bars(M)
		check_progress(M)
	proc/check_progress(var/mob/M)
		if(learn_progress > learn_req)
			give_jutsu(M)
			M.progress_target = null
			M.progress_list -= src
			if(M.progress_box)
				M.progress_box.display_interface(M.progress_list, M)
				M.progress_box.update_bars(M)
			if(M.character_box)
				M.character_box.update_bars(M)
			if(M.jutsu_box)
				M.jutsu_box.display_interface(M.contents)
			del(src)
	proc/is_active(var/mob/M)
		if(M.progress_activity > 0)
			M.progress_activity--
			return 1
		return 0
	proc/give_jutsu(var/mob/M)
//		var/jutsu_type = get_jutsu(name)
		var/obj/jutsu/jutsu_type = get_jutsu(name)
		if(jutsu_type)
			var/obj/jutsu/new_jutsu = copy_jutsu(jutsu_type, M)
			if(jutsu_type.progresses_into)
				for(var/obj/jutsu/jutsu in M)
					if(jutsu.progresses_into == name)
						del(jutsu)
			if(new_jutsu.free_spec)
				M.points["spec"]++
				M << output("This perk grants you a free specialization perk. Buy it from the tree.", "outputall.output")

	proc/get_jutsu(name_identifier)
		for(var/obj/jutsu/jutsu in archive)
			if(jutsu.name == name_identifier)
				return jutsu

	proc/copy_jutsu(obj/jutsu/jutsu_type, var/mob/M)
		var/obj/jutsu/new_jutsu = new(M)
		for(var/variable in jutsu_type.vars - "transform")
			if(issaved(jutsu_type.vars[variable]))
				new_jutsu.vars[variable] = jutsu_type.vars[variable]
		return new_jutsu

	proc/set_current(var/mob/M)
		if(M.progress_target)
			src<<"You can't change."
			return
		M.progress_target = src
		if(M.character_box)
			M.character_box.update_bars(M)
		if(M.progress_box)
			M.progress_box.display_interface(M.progress_list, M)
			M.progress_box.update_bars(M)

	Click()
		set_current(usr)

mob
	var
		progress_cap = 120
		progress_speed = 1
		progress_today = 0
		progress_timer = 0
		progress_key = 1
		obj/progress_card/progress_target
		list/obj/progress_card/progress_list = list()
		progress_activity = 0
		teacher_activity = 0

	proc/is_req_locked(var/obj/jutsu/t)
		var/prerequisite_locked = 0
		for(var/r in t.prerequisites)
			var/l = 1
			for(var/obj/jutsu/p in src)
				if(p.name == r)
					l = 0
				else if(p.encapsulates.Find(r))
					l = 0
			if(l)
				prerequisite_locked = 1
				break
		if(prerequisite_locked)
			return 0
		return 1



	proc/bypass_teach(var/obj/jutsu/jutsu_type, var/hidden = 0, var/ignore)
		if(ignore) return
		if(!jutsu_type) return
		for(var/obj/jutsu/jutsu in src)
			if(jutsu.name == jutsu_type.name)
				return 0
		for(var/obj/progress_card/card in progress_list)
			if(card.name == jutsu_type.name)
				return 0

		for(var/obj/progress_card/card in progress_list)
			if(card.name == jutsu_type.name)
				del(card)

		var/obj/jutsu/new_jutsu = new(src)
		for(var/variable in jutsu_type.vars - "transform")
			if(issaved(jutsu_type.vars[variable]))
				new_jutsu.vars[variable] = jutsu_type.vars[variable]

		if(progress_box)
			progress_box.display_interface(progress_list)
			progress_box.update_bars(src)
		if(character_box)
			character_box.update_bars(src)
		if(jutsu_box)
			jutsu_box.display_interface(contents)
		return 1


	proc/teach_jutsu(var/obj/jutsu/jutsu_type, var/hidden = 0)
		if(!jutsu_type) return
		for(var/obj/jutsu/jutsu in src)
			if(jutsu.name == jutsu_type.name)
				return 0
		for(var/obj/progress_card/card in progress_list)
			if(card.name == jutsu_type.name)
				return 0
		var/obj/progress_card/card = new(src)
		card.name = jutsu_type.name
		card.desc = jutsu_type.desc
		card.icon = jutsu_type.icon
		card.jutsu_type = jutsu_type.jutsu_type
		card.icon_state = jutsu_type.icon_state
		//card.learn_req = jutsu_type.learn_req
		card.control_req = jutsu_type.control_req
		card.chakra_req = jutsu_type.chakra_req
		card.prerequisites = jutsu_type.prerequisites
		card.encapsulates = jutsu_type.encapsulates
		card.rank = jutsu_type.rank
		card.custom = jutsu_type.custom
		card.set_learn_req()
		if(hidden) card.hidden = 1
		progress_list += card
		src << "You've learnt the basics to [card.name]"
		if(progress_box)
			progress_box.display_interface(progress_list, src)
		spawn() card.check_progress(src)
		return card

	proc/update_jutsu()
		for(var/obj/jutsu/jutsu in src)
			for(var/obj/jutsu/archived_jutsu in archive)
				if(jutsu.name == archived_jutsu.name)
					if(jutsu.last_updated < archived_jutsu.last_edit)
						for(var/variable in archived_jutsu.vars - "transform")
							if(issaved(archived_jutsu.vars[variable]))
								jutsu.vars[variable] = archived_jutsu.vars[variable]
						jutsu.last_updated = archived_jutsu.last_edit
						src << "Updated [jutsu.name]."
						break

		for(var/obj/items/Weapon/wep in src)
			for(var/obj/items/Weapon/wep_arch in archive)
				if(wep.name == wep_arch.name)
					if(wep.last_edit < wep_arch.last_edit)
						for(var/variable in wep_arch.vars - "transform")
							if(issaved(wep_arch.vars[variable]))
								wep.vars[variable] = wep_arch.vars[variable]
						wep.last_edit = wep_arch.last_edit
						src << "Updated [wep.name]."
						break



	verb/Teach()
		if(TeachingOff)
			return
		//if(src.lifetime_progress_points  <= 60)
		//	alert("You can not teach until you have more than 60 progress points.")
		//	return
		var/mob/M = locate() in get_step(src, dir)
		if(M.client.address == src.client.address)
			del(M)
			return
		if(M.client.computer_id == src.client.computer_id)
			del(M)
			return
		if(!M) return
		if(M.progress_target) return
		var/list/L = list()
		for(var/obj/jutsu/jutsu in src)
			if(jutsu.jutsu_type <> "perk" && !jutsu.unlearnable)
				L += jutsu
			//if(jutsu.jutsu_type == "perk" && (jutsu.perk_type in list("Skill")))
			//	L += jutsu
		L += "Cancel"
		var/obj/jutsu/jutsu_type = input(usr,"Teach [M] what jutsu?") in L
		if(!jutsu_type || !istype(jutsu_type, /obj/jutsu) || jutsu_type == "Cancel")
			return

		var/reqs = M.check_reqs(jutsu_type, 1)
		if(reqs != "Pass")
			alert(src,reqs)
			return

		var/p = ""
		for(var/req in jutsu_type.prerequisites)
			p += "[req]"
			if(req != jutsu_type.prerequisites[jutsu_type.prerequisites.len])
				p += ", "

		if(jutsu_type.control_req) p += "[jutsu_type.control_req ? ", " : ""][length(p) ? ", " : ""][get_grade_stat(jutsu_type.control_req)] grade control "
		if(jutsu_type.stamina_req) p += "[jutsu_type.stamina_req ? ", " : ""][length(p) ? ", " : ""][get_grade_stat(jutsu_type.stamina_req)] grade stamina "
		if(jutsu_type.strength_req) p += "[jutsu_type.strength_req ? ", " : ""][length(p) ? ", " : ""][get_grade_stat(jutsu_type.strength_req)] grade strength "
		if(jutsu_type.speed_req) p += "[jutsu_type.speed_req ? ", " : ""][length(p) ? ", " : ""][get_grade_stat(jutsu_type.speed_req)] grade speed "
		if(jutsu_type.agility_req) text += "[jutsu_type.agility_req ? ", " : ""][length(text) > 45 ? ", " : ""][get_grade_stat(jutsu_type.agility_req)] grade agility "
		if(jutsu_type.endurance_req) text += "[jutsu_type.endurance_req ? ", " : ""][length(text) > 45 ? ", " : ""][get_grade_stat(jutsu_type.endurance_req)] grade endurance "
		if(p == "") p = "None"

		if(jutsu_type.jutsu_type <> "perk")
			var/obj/progress_card/card = M.bypass_teach(jutsu_type)
			if(!card)
				for(var/obj/progress_card/c in M.progress_list)
					if(c.name == jutsu_type.name)
						c.learning_from = src.ckey
						show_message("[src] is [M]'s new teacher for [jutsu_type]")
						return
				alert(M, "You already have [jutsu_type]")
				return
			if(!card.custom)
				card.give_jutsu(M)
				return
			card.learning_from = src.ckey

			var/mob/controlMob = src
			if(controlMob.MindTransfer) controlMob=controlMob.MindTransfer
			for(var/mob/hearer in hearers(16,controlMob))
				if(hearer.MindTransfer) if(hearer == hearer.MindTransfer.MindAfflicted) continue
				if(hearer.MindAfflicted)
					hearer.MindAfflicted << output("[hearer.getStrangerName(src)] has taught [hearer.MindAfflicted.getStrangerName(M)] the basics to [jutsu_type]", "outputall.output")
				else hearer << output("[hearer.getStrangerName(src)] has taught [hearer.getStrangerName(M)] the basics to [jutsu_type]", "outputall.output")
			return

		for(var/obj/progress_card/c in M.progress_list)
			if(c.name == jutsu_type.name)
				c.learning_from = src.ckey

				var/mob/controlMob = src
				if(controlMob.MindTransfer) controlMob=controlMob.MindTransfer
				for(var/mob/hearer in hearers(16,controlMob))
					if(hearer.MindTransfer) if(hearer == hearer.MindTransfer.MindAfflicted) continue
					if(hearer.MindAfflicted)
						hearer.MindAfflicted << output("[hearer.getStrangerName(src)] is [hearer.MindAfflicted.getStrangerName(M)]'s new teacher for [jutsu_type]", "outputall.output")
					else hearer << output("[hearer.getStrangerName(src)] is [hearer.getStrangerName(M)]'s new teacher for [jutsu_type]", "outputall.output")
				return

		if((input(M, "[src] is attempting to teach you [jutsu_type] for [jutsu_type.point_cost] point(s)\n\nPrerequisites: [p]\nPP Cost: [jutsu_type.point_cost]") in list("Accept", "Cancel")) == "Accept")
			if(M.progress_points >= jutsu_type.point_cost)
				var/obj/progress_card/card = M.teach_jutsu(jutsu_type)
				if(!card)
					alert(M, "You already have [jutsu_type]")
					return
				M.progress_points -= jutsu_type.point_cost
				card.learning_from = src.ckey
				var/mob/controlMob = src
				if(controlMob.MindTransfer) controlMob=controlMob.MindTransfer
				for(var/mob/hearer in hearers(16,controlMob))
					if(hearer.MindTransfer) if(hearer == hearer.MindTransfer.MindAfflicted) continue
					if(hearer.MindAfflicted)
						hearer.MindAfflicted << output("[hearer.getStrangerName(src)] has taught [hearer.MindAfflicted.getStrangerName(M)] the basics to [jutsu_type]", "outputall.output")
					else hearer << output("[hearer.getStrangerName(src)] has taught [hearer.getStrangerName(M)] the basics to [jutsu_type]", "outputall.output")
			else
				alert(M, "You don't have enough points ([progress_points]/[jutsu_type.point_cost])")
			M.character_box.update_info(M)
/mob/verb/FixAllReqs()
	for(var/obj/jutsu/perk in archive.contents)
		//we need to find the control req letter and sqitch it to the right thing
		perk.control_req = return_stat_grade(get_grade_stat(perk.control_req))
		perk.stamina_req = return_stat_grade(get_grade_stat(perk.stamina_req))
		perk.strength_req = return_stat_grade(get_grade_stat(perk.strength_req))
		perk.speed_req = return_stat_grade(get_grade_stat(perk.speed_req))
		perk.agility_req = return_stat_grade(get_grade_stat(perk.agility_req))
		perk.endurance_req = return_stat_grade(get_grade_stat(perk.endurance_req))
/mob/verb/fixreq(var/obj/jutsu/x in archive.contents)
		x.control_req = return_stat_grade(get_grade_stat(x.control_req))
		world<<x.control_req
		x.stamina_req = return_stat_grade(get_grade_stat(x.stamina_req))
		world<<x.stamina_req
		x.strength_req = return_stat_grade(get_grade_stat(x.strength_req))
		world<<x.strength_req
		x.speed_req = return_stat_grade(get_grade_stat(x.speed_req))
		world<<x.speed_req
		x.agility_req = return_stat_grade(get_grade_stat(x.agility_req))
		world<<x.agility_req
		x.endurance_req = return_stat_grade(get_grade_stat(x.endurance_req))
		world<<x.endurance_req
mob/Admin3/verb/clearinfotext()
	set category = null
	archive.info_text = list("here" = "goes")
	archive.info_text_green = list()
	archive.info_text_red = list()
/mob/proc/aBetterWay(var/stat, var/boost, genius)
	if(genius)
		return (stat + 2 + boost) + _get_step_size(get_grade_stat(stat + boost))
	else
		return stat + boost
mob
	proc/check_reqs(obj/jutsu/perk, teach = 0)

		var/list/listed_requirements = perk.prerequisites.Copy()

		for(var/i in listed_requirements)
			if(findtext(i,"Proficiency"))
				var/list/isplit = splittext(i," ")
				var/list/k = ""
				for(var/obj/jutsu/jutsu in src)
					k = splittext(jutsu.name," ")
					if(k[1] == isplit[1] && k[2] == isplit[2])
						if(checkNumeral(isplit[3],k[3]))
							listed_requirements -= i
							break
		for(var/obj/jutsu/jutsu in src)
			if(jutsu.name in listed_requirements)
				listed_requirements -= jutsu.name

		if(Trait == "Genius")
			if(listed_requirements.len || aBetterWay(control, control_boost(), 1) < perk.control_req || aBetterWay(stamina, stamina_boost(), 1) < perk.stamina_req || aBetterWay(endurance, endurance_boost(), 1) < perk.endurance_req || aBetterWay(strength, strength_boost(), 1) < perk.strength_req || aBetterWay(speed, speed_boost(), 1) < perk.speed_req || aBetterWay(agility, agility_boost(), 1) < perk.agility_req)
				world<<"[aBetterWay(control, control_boost(), 1)] < [perk.control_req] || [aBetterWay(stamina, stamina_boost(),1 )] < perk.stamina_req || [aBetterWay(endurance, endurance_boost(), 1)] < [perk.endurance_req] || [aBetterWay(strength, strength_boost(), 1)] < [perk.strength_req] || [aBetterWay(speed, speed_boost(),1)] < [perk.speed_req] || [aBetterWay(agility, agility_boost(), 1)] < [perk.agility_req]"
				var/text = "You don't meet the requirements for [perk] ( "
				if(teach == 1)
					text = "They don't meet the requirements for [perk] ( "
				for(var/t in listed_requirements)
					text += "[length(text) > 45 ? ", " : ""][t] "
				if(perk.control_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.control_req)] grade control "
				if(perk.stamina_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.stamina_req,1)] grade stamina "
				if(perk.strength_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.strength_req)] grade strength "
				if(perk.speed_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.speed_req)] grade speed "
				if(perk.agility_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.agility_req)] grade agility "
				if(perk.endurance_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.endurance_req)] grade endurance "
				text += ")"
				return text
			world<<"[aBetterWay(control, control_boost(), 1)] < [perk.control_req] || [aBetterWay(stamina, stamina_boost(),1 )] < perk.stamina_req || [aBetterWay(endurance, endurance_boost(), 1)] < [perk.endurance_req] || [aBetterWay(strength, strength_boost(), 1)] < [perk.strength_req] || [aBetterWay(speed, speed_boost(),1)] < [perk.speed_req] || [aBetterWay(agility, agility_boost(), 1)] < [perk.agility_req]"
			return "Pass"
		if(listed_requirements.len || aBetterWay(control, control_boost()) < perk.control_req || aBetterWay(stamina, stamina_boost()) < perk.stamina_req || aBetterWay(endurance, endurance_boost()) < perk.endurance_req || aBetterWay(strength, strength_boost()) < perk.strength_req || aBetterWay(speed, speed_boost()) < perk.speed_req || aBetterWay(agility, agility_boost()) < perk.agility_req)

			var/text = "You don't meet the requirements for [perk] ( "
			if(teach == 1)
				text = "They don't meet the requirements for [perk] ( "
			for(var/t in listed_requirements)
				text += "[length(text) > 45 ? ", " : ""][t] "
			if(perk.control_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.control_req)] grade control "
			if(perk.stamina_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.stamina_req,1)] grade stamina "
			if(perk.strength_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.strength_req)] grade strength "
			if(perk.speed_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.speed_req)] grade speed "
			if(perk.agility_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.agility_req)] grade agility "
			if(perk.endurance_req) text += "[length(text) > 45 ? ", " : ""][get_grade_stat(perk.endurance_req)] grade endurance "
			text += ")"
			return text
		return "Pass"


proc
	checkNumeral(x,y) //req , user's current
		x = numeralToInt(x)
		y = numeralToInt(y)
		if(y >= x)
			return 1
		return 0
proc
	numeralToInt(x)
		switch(x)
			if("I")
				return 1
			if("II")
				return 2
			if("III")
				return 3
			if("IV")
				return 4
			if("V")
				return 5