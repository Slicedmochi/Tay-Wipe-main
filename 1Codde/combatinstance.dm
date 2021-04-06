// 3 layers of checking if in combat, first theres a var of the combat's name, if that doesnt come up, look to see if they are the owner of a combat, if not that look to see if they were in involved in the list of mobs
//globals
/var/list/CombatHandler/CombatByName = list() // named combats
/proc/FindCombatByName(n)
	for(var/x in CombatByName)
		if(n == x)
			return CombatByName[x]
		else if(CombatByName[x].name == n)
			return CombatByName[x]
	return null
/proc/FindCombatByOwner(n)
	for(var/x in CombatByName)
		if(CombatByName[x].ownerkey == n)
			return CombatByName[x]
	return null
/proc/FindPersonInCombat(n)
	for(var/x in CombatByName)
		for(var/CombatHandler/y in CombatByName[x])
			for(var/z in y.memberslist)
				if(n == z)
					return CombatByName[x]
	return null
//CombaTLoc
/obj/CombatLoc
	New(CombatHandler/o)
		parent = o 
		..()
	icon = 'combatflag.dmi'
	var/CombatHandler/parent
	var/list/TurnTracker = list()
	proc/EndTurn(mob/p)
		if(p.key in parent.memberslist)
			p._output("has declared the end of a turn", "oocalert", "outputall.output")
			for(var/x in TurnTracker)
				p._output("[FindPlayerByKey(x).strangerName]'s turn counter is [TurnTracker[x]]", "oocalert1", "outputall.output")
				TurnTracker[x]++
		else
			return
	proc/GiveInfo(mob/p)
		p._output("[parent.name]", "selfalert", "outputooc.output")
	//proc for joining combat, or maybe something to track your turns
	proc/TrackTurn(mob/p)
		for(var/x in parent.memberslist)
			if(x == p.key)
				if((input(usr, "Do you want to end the turn?", "Yes No") in list("Yes", "No")) == "Yes")
					EndTurn(p)
				else
					p._output("You are already in combat, fool", "selfalert", "outputall.output")
				return
		if(!TurnTracker["[p.key]"])
			TurnTracker["[p.key]"] = 1
			p._output("has started tracking turns (1)", "oocalert", "outputall.output")
		else
			TurnTracker["[p.key]"]++
			p._output("has increased their turn counter to [TurnTracker["[p.key]"]]", "oocalert", "outputall.output")
	Click()
		if(istype(usr,/mob))
			GiveInfo(usr)
			if((input(usr, "Do you want to track/count or end the turn?", "Yes No") in list("Yes", "No")) == "Yes")
				TrackTurn(usr)
			else if((input(usr, "Do you want to join combat then?") in list ("Yes", "No")) == "Yes")
				usr.EnterCombat(parent, FALSE)
//combathandler
CombatHandler // The datum that handles combat
	var/name
	var/ownerkey
	var/list/memberslist = list()
	var/location
	var/obj/CombatLoc/Combat
	New(mob/owner)
		ownerkey = owner.key
		name = "[owner.strangerName]'s Combat [rand(2,1000)]"
		for(var/mob/x in owner.inView(FALSE, 8))
			memberslist["[x.key]"] = list("[x.name] || [x.strangerName]")
			x.EnterCombat(src, 1)
			x.move = 0 
			x.leaveAI()
		CombatByName["[name]"] = src
		Combat = new(src)
		Combat.parent = src
		Combat.loc = locate(owner.x, owner.y, owner.z)
		Combat.x--
		Combat.y--
	proc
		playerLeave(mob/p)
			p.incombat = null
			p.current_combat = null
			p.move = 1
			p.updatetiles()
			p.current_tiles = 0
			memberslist["[p.key]"] = list()
			memberslist.Remove(p.key)
/mob/var/list/total_tiles = list("dodge", "walk", "run")
/mob/var/current_tiles = 0 
/mob/var/current_combat = null 
/mob/var/tmp/CombatHandler/incombat = null
//procs
/mob/proc/EnterCombat(CombatHandler/combat, ignore) // if ignore just straight up join 
	if(key in combat.memberslist) return
	if(!ignore)
		if(!combat.Combat.TurnTracker[key])
			_output("You can't enter combat without waiting turns, if allowed, simply wait a turn and rejoin. ", "selfalert", "outputall.output")
			_output("tried to join combat, but didn't wait any turns. ", "oocalert", "outputall.output")
			return
		else
			_output("has entered combat, they have used the turn counter, if there's an issue gmhelp.", "oocalert", "outputall.output")
	move = 0
	updatetiles()
	_output("You have entered combat. ( [combat.name] ) ", "selfalert", "outputall.output")
/mob/proc/updatetiles()
	var/boost = 0
	for(var/obj/jutsu/P in src)
		if(P.jutsu_type == "perk" || (P.jutsu_type == "buff" && P.active))
			if(P.boost_speed) boost += P.boost_speed
	total_tiles["run"] = round(3 + GradeToTileBuff(get_grade_stat(speed+boost, 0 ), "run"))
	total_tiles["walk"] = round(2 + GradeToTileBuff(get_grade_stat(speed+boost, 0 ), "walk"))
	total_tiles["dodge"] = round(1 + GradeToTileBuff(get_grade_stat(speed+boost, 0 ), "dodge"))
/mob/proc/locatecombat()
	//if this findss them in combat, return the combat
	if(!current_combat) return
	var/CombatHandler/x = FindCombatByName(current_combat)
	if(!x)
		x = FindCombatByOwner(key)
		if(!x)
			x = FindPersonInCombat(key)
	return x
/mob/proc/calculatemovement()
	for(var/x in 1 to 1)
		world<<current_tiles
		if(current_tiles > total_tiles["run"])
			_output("has moved [current_tiles - total_tiles["run"]] over their run tiles.","oocalert","outputall.output")
			continue
		else if(current_tiles == total_tiles["run"])
			_output("has moved their run tiles.","oocalert","outputall.output")
			continue
		else if(current_tiles > total_tiles["dodge"])
			_output("has moved [current_tiles - total_tiles["dodge"]] over their dodge tiles.","oocalert","outputall.output")
			continue
		else if(current_tiles == total_tiles["dodge"])
			_output("has moved their dodge tiles.","oocalert","outputall.output")
			continue
		else if(current_tiles > total_tiles["walk"])
			_output("has moved [current_tiles - total_tiles["walk"]] over their walk tiles.","oocalert","outputall.output")
			continue
		else if(current_tiles == total_tiles["walk"])
			_output("has moved their walk tiles.","oocalert","outputall.output")
			continue
		else if(current_tiles < total_tiles["walk"])
			world<<"too low [current_tiles]"
			continue	
	// for this, we detect if total tiles is under 0, if it is, we 
//verbs
/mob/verb/MoveTiles()
	set category = "Combat Testing"
	if(roaming)
		_output("You can't count tiles while roaming, use the verb again to go back", "selfalert", "outputall.output")
		return
	updatetiles()
	_output("has used MoveTiles, this resets their movement, please be aware of this fact if they have used it twice or more to move.", "oocalert", "outputall.output")
	if(!move)
		current_tiles = 0 
		move = 1
	else
		leaveAI()
		move = 0
	//if we are stuck, make us not stuck. not real way to track move tiles per turn, but w/e
/mob/var/tmp/roaming = null
/mob/verb/Roam()
	set category = "Combat Testing"
	if(!move)
		move = 1
		roaming = 1
		overlays += 'roam.dmi'
	else
		var/obj/lastAI = AIHandler.db[key][AIHandler.db[key].len]
		loc = locate(lastAI.x, lastAI.y, lastAI.z)
		move = 0
		roaming = 0
		overlays -= 'roam.dmi'
//debug
/mob/verb/Combat_Start()
	set category = "Combat Testing"
	var/CombatHandler/combat = new(src)
	current_combat = "[combat.name]"
	incombat = combat
	updatetiles()
/mob/verb/Leave_Combat()
	set category = "Combat Testing"
	if(!incombat) return
	incombat.playerLeave(src)
