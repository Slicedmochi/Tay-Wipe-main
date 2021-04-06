var/AfterimageHandler/AIHandler = new()
var/update_loop/AILoop = new(600, "Update")
/mob/verb/testaideleteall()
	set category = "Combat Testing"
	AIHandler.Del()
AfterimageHandler // we're gonna track all afterimages in game, period, meaning they can be left behind after logging and will expire based on a time limit, not anything else 
	Del()
		for(var/x in db)
			var/mob/player = FindPlayerByKey(x)
			world<<player
			if(player)
				world<<"here"
				removeAllAI(player, x)
				player.clearlist()
			else
				removeAllAI(null, x)
			db.Remove(x)
			AILoop -= src
		..()
	var/list/obj/afterimage/db = list()
	var/timer = 1200
	proc/addAfterImage(mob/p, obj/afterimage/ai)
		if(!db["[p.key]"])
			db["[p.key]"] = list()
			db["[p.key]"] += ai
		else
			db["[p.key]"] += ai
	proc/removeAI(mob/p)
		var/obj/afterimage/ai = db["[p.key]"][1]
		db["[p.key]"].Remove(db["[p.key]"][1])
		ai.loc = null
	proc/removeAllAI(mob/p, key)
		for(var/obj/afterimage/ai in db["[key]"])
			db["[key]"].Remove(ai)
			del ai
		db["[key]"] = list()
		if(p)
			p.currentainum = 0 
	proc/RevealAllAI(key)
		for(var/obj/afterimage/ai in db["[key]"])
			ai.invisibility = 0
	proc/RevealAllAIToPerson(key, mob/p)
		for(var/obj/afterimage/ai in db["[key]"])
			p<<ai.Invs
	proc/Update()
		for(var/x in db)
			if(db["[x]"].len > 0)
				if(!db["[x]"][1].timertoggle)
					continue
				else if(db["[x]"][1].logged)
					db["[x]"][1].inView(TRUE,18) << "The owner of these afterimages has logged out, after a total of 5 mins or more, these afterimages will delete, be sure to screenshot their location"
					if((world.realtime-db["[x]"][1].createdat) > 3000)
						db["[x]"][1].inView(TRUE,18) << "The owner of these afterimages has been logged out for 5 or more minutes, gmhelp unless this was agreed upon."
						removeAllAI(null, x)
						world<<"Person is offline, AI is up"
						//make an alert to the people that it has been too long
				else if((world.realtime-db["[x]"][1].createdat) > timer)
					removeAllAI(FindPlayerByKey(x), x)
					world<<"Person is online, AI is up"
	proc/combatToggle(mob/p)
		if(!db["[p.key]"][1].timertoggle)
			db["[p.key]"][1].createdat = world.realtime
			db["[p.key]"][1].timertoggle = 1
			world<<"tiemrtoggle = 1, aka counting"
		else
			db["[p.key]"][1].timertoggle = 0
			world<<"tiemrtoggle = 0, aka not counting"
	proc/logoutReset(mob/p) // only to be called when the mob logs out
		if(!p.incombat) return
		if(db["[p.key]"][1] && p.current_combat)
			db["[p.key]"][1].logged = 1
			if(p.invisibility)
				p.invisibility = 0
			combatToggle(p)
	proc/loginReset(mob/p) // only to be called if they are in combat
		if(p.incombat && db["[p.key]"][1])
			db["[p.key]"][1].logged = 0
			combatToggle(p)
/obj/afterimage
	var/owner
	var/number = 0
	var/timertoggle = 1
	var/createdat
	var/logged = null
	var/tmp/image/Invs = null
	New(mob/p)
		owner = p.key
		p.currentainum++
		number = p.currentainum
		createdat = world.realtime
		if(p.current_combat)
			timertoggle = 0
		//check if in combat, if so turn timer toggle off
		appearance = p.appearance
		dir = p.dir
		alpha = 155
		name = "[name] AI [number]"
		draw_text("[number]", , 20,20,5,10,FALSE)
		..()
	proc/draw_text(string, list/thelist, s_x, s_y, n_x,n_y, cutoff)
		if(!istext(string)) return
		var/obj/letter_icon = new
		letter_icon.icon = 'fontsmall.dmi'
		letter_icon.layer = OBJ_LAYER+1
		letter_icon.pixel_x = s_x
		letter_icon.pixel_y = s_y
		var/counterx = s_x
		var/countery = s_y
		for(var/index in 1 to length(string))
			var/letter = string[index]
			if(index == 1)
				letter_icon.icon_state = letter
				vis_contents += letter_icon
				if(thelist)
					thelist += letter_icon
				continue
			counterx+=n_x
			letter_icon = new()
			letter_icon.icon = 'fontsmall.dmi'
			letter_icon.layer = OBJ_LAYER+1
			letter_icon.icon_state = letter
			letter_icon.pixel_x = counterx
			letter_icon.pixel_y = countery
			if(letter_icon.pixel_x >= s_x + (n_x * 20))
				if(cutoff)
					continue
				letter_icon.pixel_x = s_x
				counterx = s_x
				letter_icon.pixel_y -= n_y
				countery -= n_y
			vis_contents += letter_icon
			if(thelist)
				thelist += letter_icon
/mob/proc/clearlist()
	 set category = "Combat Testing"
	 AIHandler.db["[key]"] = list()
	 currentainum = 0
/mob/var/currentainum = 0
/mob/proc/AICheck() // check to see if their ai needs to be reset
	if(AIHandler.db["[key]"].len >= 1)
		//they must be in combat or bugged or still have ai up and are simply relogging
	else
		if(currentainum > 0)
			clearlist()
/mob/verb/leaveAI()
	set category = "Combat Testing"
	if(roaming)
		_output("You can't leave an AI while roaming, use the verb again to go back", "selfalert", "outputall.output")
		return
	if(!AIHandler.db["[key]"])
		_output("Your Ai List is bugged, gmhelp if it isnt fixed after this", "selfalert", "outputall.output")
		AIHandler.db["[key]"] = list()
	if(AIHandler.db["[key]"].len < 1 && currentainum > 0)
		currentainum = 0
		_output("Current AI Number was over 0, but Ai numbers were under 1, fixing. If not fixed after, gm help.", "selfalert", "outputall.output")
	if(AIHandler.db["[key]"].len >= 7)
		AIHandler.removeAI(src)
	var/obj/afterimage/ai = new(src)
	ai.loc = src.loc
	if(src.Invs)
		ai.Invs = image(src.icon, ai)
		ai.Invs.appearance = src.appearance
		ai.Invs.dir = src.dir
		ai.Invs.vis_contents = ai.vis_contents
		src<<ai.Invs
	AIHandler.addAfterImage(src, ai)
	if(incombat)
		ai.timertoggle = 0 
/mob/verb/FixAiList()
	set category = "Combat Testing"
	var/mob/p = input(src, "What person?" , "Person ") in ListOfPlayers()
	p.clearlist()
	p._output("Your Ai List has been fixed", "selfalert", "outputall.output")
	_output("You have fixed [p]'s Ai List", "selfalert","outputall.output")
	