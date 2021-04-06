/********************************************/
/******** Coded by jOrDaN 10 DEC 2020 ********/
/********************************************/
//New Verbs
/mob/verb/Roleplay()
	set hidden = 1
	overlays += 'Bubble.dmi'
	var/msg=input(usr,"Type your message.","Message") as message
	if(muted["Roleplay"])
		GivePoints(-10)
		Progress()
		_output("You are muted from Roleplay, this may be from excessive trolling, arguing or something else. It is likely you are muted so an admin can give a ruling. Do not attempt to avoid this, it will result in progression being locked or reversed.", "selfalert", "outputall.output")
		return
	if(wordcount(msg) >= 800)
		_output("[msg]\n This was only shown to you because it was too large.", "selfalert", "outputall.output")
		_output("[msg]\n This was only shown to you because it was too large.", "selfalert", "outputic.output")
		overlays -= 'Bubble.dmi'
		return
	if(length(msg) >= 4000)
		_output("[msg]\n This was only shown to you because it was too large.", "selfalert", "outputall.output")
		_output("[msg]\n This was only shown to you because it was too large.", "selfalert", "outputic.output")
		overlays -= 'Bubble.dmi'
		return
	if(!msg)
		overlays -= 'Bubble.dmi'
		return
	else
		overlays -= 'Bubble.dmi'
		overlays+='TalkOverlay.dmi'
		spawn(15) overlays-='TalkOverlay.dmi'
		if(findtext(msg,"//",1,3))
			msg=copytext(msg,4,0)
			_output(msg, "rp2", "outputall.output")
			_output(msg, "rp2", "outputic.output")
		else
			_output(msg, "rp", "outputall.output")
			_output(msg, "rp", "outputic.output")
	GivePoints(CalcProg(wordcount(msg), "rp", CheckRP(msg, "rp"), IsRecent("rp")))
	lastrp = msg
	lastrptimer = world.timeofday
	if(progress_target && archive.progress_on)
		progress_target.progress(src, CalcProg(wordcount(msg), "rp", CheckRP(msg, "rp"), IsRecent("rp")))
	Progress()
/mob/verb/Say(msg as text)
	overlays+='TalkOverlay.dmi'
	spawn(15) overlays-='TalkOverlay.dmi'
	if(is_ooc(msg) && !findtext(msg,"/w",1,3)) // lower prog
		if(muted["LOOC"])
			GivePoints(-5)
			Progress()
			_output("You are muted from LOOC, this may be from excessive trolling, arguing or something else. It is likely you are muted so an admin can give a ruling. Do not attempt to avoid this, it will result in progression being locked or reversed.", "selfalert", "outputall.output")
			return
		_output(msg, "looc", "outputall.output")
		_output(msg, "looc", "outputoocsay.output")
		if(daily)
			GivePoints(-1)
	else if(findtext(msg,"/w",1,3)) // no prog
		if(muted["Say"])
			GivePoints(-3)
			Progress()
			_output("You are muted from say, this may be from excessive trolling, arguing or something else. It is likely you are muted so an admin can give a ruling. Do not attempt to avoid this, it will result in progression being locked or reversed.", "selfalert", "outputall.output")
			return
		msg=copytext(msg,4,0)
		_output(msg, "w", "outputall.output")
		_output(msg, "w", "outputic.output")
	else if(findtext(msg,"!",length(msg),0))
		if(muted["Say"])
			GivePoints(-3)
			_output("You are muted from say, this may be from excessive trolling, arguing or something else. It is likely you are muted so an admin can give a ruling. Do not attempt to avoid this, it will result in progression being locked or reversed.", "selfalert", "outputall.output")
			Progress()
			return
		_output(msg, "y", "outputall.output")
		_output(msg, "y", "outputic.output")
		GivePoints(CalcProg(wordcount(msg), "say", CheckRP(msg, "say"), IsRecent("say")))
		if(progress_target && archive.progress_on)
			progress_target.progress(src, CalcProg(wordcount(msg), "say", CheckRP(msg, "say"), IsRecent("say")))
	else 
		if(muted["Say"])
			GivePoints(-3)
			_output("You are muted from say, this may be from excessive trolling, arguing or something else. It is likely you are muted so an admin can give a ruling. Do not attempt to avoid this, it will result in progression being locked or reversed.", "selfalert", "outputall.output")
			Progress()
			return
		_output(msg, "say", "outputall.output")
		_output(msg, "say", "outputic.output")
		GivePoints(CalcProg(wordcount(msg), "say", CheckRP(msg, "say"), IsRecent("say")))
		if(progress_target && archive.progress_on)
			progress_target.progress(src, CalcProg(wordcount(msg), "say", CheckRP(msg, "say"), IsRecent("say")))
	lastsay = msg
	lastsaytimer = world.timeofday
	Progress()
/mob/verb/Whipser(msg as text) // no prog
	if(muted["Say"])
		GivePoints(-3)
		_output("You are muted from say, this may be from excessive trolling, arguing or something else. It is likely you are muted so an admin can give a ruling. Do not attempt to avoid this, it will result in progression being locked or reversed.", "selfalert", "outputall.output")
		return
	if(is_ooc(msg))
		_output(msg, "w", "outputall.output")
	else
		_output(msg, "w", "outputall.output")
		_output(msg, "w", "outputic.output")
//New Var
/mob/var/daily = 0 // if u got ur daily or not
/mob/var/next_check = 0  // the next check
/mob/var/previous_check = 0 // the previous check, for checking if u missed days
/mob/var/max_dailies = 1// just in case u need more
/mob/var/daily_points = 75// points needed to get a full daily, u need 100 to gt a check normally
/mob/var/lastrp = null
/mob/var/lastrptimer = 0
/mob/var/tmp/lastsay = null
/mob/var/tmp/lastsaytimer = 1#INF
/mob/var/rerpcounter = 0 // how many times soembody has 'rerpd'
/mob/var/rerpcountertimer = 0 // when they last rerp'd, to auto reset it after a while, say like 30 mins or so
/mob/var/muted = list("LOOC" = 0 ,"Say" = 0 ,"Roleplay" = 0 )
//New Procs
/atom/proc/inView(exclude , range) // if TRUE exclude the src, if not exclude it. Only returns things with clients
	if(!range) range = 8 // the range in tiles around
	var/mob/list/mobs = list()
	var/mob/a = src
	if(!exclude && a.Invs)
		mobs+=src
	for(var/mob/x in view(range, src))
		if(exclude)
			if(x == src)
				continue // skip self
		if(x.client) // make sure they have client
			mobs += x
	return mobs
/mob/proc/SortPeople(list/mobs)
	var/mob/list/newmobs = list()
	for(var/mob/x in mobs)
		newmobs += getStrangerNameNoHTML(x)
	return newmobs
/mob/proc/FindPerson(name)
	world<<name
	for(var/mob/x in inView(TRUE,8))
		if(name == getStrangerNameNoHTML(x))
			return x
/mob/proc/loot(obj/items/item, var/obj/Container/body) // item, person, body
	for(var/mob/m in inView(FALSE))
		m << output("<font color = white>[m.getStrangerName(src)] removes [item.name] from [findtext(body.ContainerName, "body") ? "[body.ContainerName]" : "the [lowertext(body.ContainerName)]"].<font color = white>", "outputic.output")
		m << output("<font color = white>[m.getStrangerName(src)] removes [item.name] from [findtext(body.ContainerName, "body") ? "[body.ContainerName]" : "the [lowertext(body.ContainerName)]"].<font color = white>", "outputall.output")
		m.ChatLog("<font color = white>[src](src.strangerName)(key) removes [item.name] from [findtext(body.ContainerName, "body") ? "[body.ContainerName]" : "the [lowertext(body.ContainerName)]"].<font color = white>")
		m.SelfLog("<font color = white>[m.getStrangerName(src)] removes [item.name] from [findtext(body.ContainerName, "body") ? "[body.ContainerName]" : "the [lowertext(body.ContainerName)]"].<font color = white>")
/mob/proc/_output(message, style, type)
	if(style == "w")
		var/list/ppl = list()
		for(var/mob/x in inView(FALSE, 2))
			ppl += x
			x << output("<font color=\"[SayFont]\">[x.getStrangerName(src)] whisper:<font color = white> [message]", "[type]")
			x.ChatLog("<font color=\"[SayFont]\">([key])([strangerName])[name] whisper:<font color = white> [message]")
			x.SelfLog("<font color=\"[SayFont]\">[x.getStrangerName(src)] whisper:<font color = white> [message]")
		for(var/mob/x in inView(FALSE))
			if(x in ppl)
				continue
			//if(x.hasHearing() == 1 && x in inView(FALSE, 4))
			//    x << output("<font color=\"[SayFont]\">[x.getStrangerName(src)] whisper : [message]", "[type]")
			//    continue
			//if(x.hasHearing() == 2 && x in inView(FALSE, 6))
			//    x << output("<font color=\"[SayFont]\">[x.getStrangerName(src)] whisper : [message]", "[type]")
			//    continue
			//if(x.hasHearing() >=3 && x in inView(FALSE) // lipreader
			x << output("<font color=\"[SayFont]\">[x.getStrangerName(src)] whispers faintly.", "[type]")
			x.ChatLog("<font color=\"[SayFont]\">([key])([strangerName])[name] whispers: [message]")
			x.SelfLog("<font color=\"[SayFont]\">[x.getStrangerName(src)] whispers faintly.")
	else if(style == "y")
		for(var/mob/m in inView(FALSE, 12))
			m << output("<font color=\"[SayFont]\">[m.getStrangerName(src)] yells:<font color = white> [message]", "[type]")
			m.ChatLog("<font color=\"[SayFont]\">([key])([strangerName])[name] yells:<font color = white> [message]")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)] yells:<font color = white> [message]")
	else if(style == "looc")
		for(var/mob/m in inView(FALSE))
			m << output("<font color=\"[SayFont]\">[m.getStrangerName(src)] OOCs:<font color = white> [message]", "[type]")
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name] OOCs:<font color = white> [message]")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)] OOCs :<font color = white> [message]")
	else if(style == "say")
		for(var/mob/m in inView(FALSE))
			m << output("<font color=\"[SayFont]\">[m.getStrangerName(src)] says:<font color = white> [message]", "[type]")
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name] says:<font color = white> [message]")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)] says:<font color = white> [message]")
	else if(style == "rp")
		for(var/mob/m in inView(FALSE))
			m << output("<font color=\"[SayFont]\">[m.getStrangerName(src)] [message]", "[type]")
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name] [message]")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)] [message]", "[type]")
	else if(style == "rp2")
		for(var/mob/m in inView(FALSE))
			m << output("<font color=\"[SayFont]\">[message]\n([m.getStrangerName(src)])", "[type]")
			m.ChatLog("<font color=\"[SayFont]\">[message]\n([key])([m.getStrangerName(src)])[name]")
			m.SelfLog("<font color=\"[SayFont]\">message]\n([m.getStrangerName(src)])", "[type]")
	else if(style == "selfalert")
		src << output("<font color=white>[message]", "[type]")
		src.ChatLog("<font color=white>[message]")
		src.SelfLog("<font color=white>[message]")
	else if(style == "oocalert")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> [message]", "[type]")
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name]<font color = white> [message]")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> [message]")
	else if(style == "oocalert1")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color = white> [message]", "[type]")
			m.ChatLog("([key]) [name]<font color = white> [message]")
			m.SelfLog("<font color = white> [message]")
	else if(style == "stat")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has [message[3]] their [message[1]] by a cost of [message[2]].", "[type]") // 1 = stat, 2 = letter, 3 = restore/deduct
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name]<font color = white>has [message[3]] their [message[1]] by a cost of [message[2]].")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has [message[3]] their [message[1]] by a cost of [message[2]].")
	else if(style == "weapontransfer")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has moved a [message] to their bag.", "[type]") // 1 = stat, 2 = letter, 3 = restore/deduct
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name]<font color = white> has moved a [message] to their bag.")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has moved a [message] to their bag.")
	else if(style == "weaponreturn")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has removed a [message] from their bag.", "[type]") // 1 = stat, 2 = letter, 3 = restore/deduct
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name]<font color = white> has removed a [message] from their bag.")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has removed a [message] from their bag.")
	else if(style == "unseal")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has unsealed a [message] from their scroll.", "[type]") // 1 = stat, 2 = letter, 3 = restore/deduct
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name]<font color = white> has unsealed a [message] from their scroll.")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has unsealed a [message] from their scroll.")
	else if(style == "seal")
		for(var/mob/m in inView(FALSE))
			m <<output("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has unsealed a [message] from their scroll.", "[type]") // 1 = stat, 2 = letter, 3 = restore/deduct
			m.ChatLog("<font color=\"[SayFont]\">([key])([m.getStrangerName(src)])[name]<font color = white> has unsealed a [message] from their scroll.")
			m.SelfLog("<font color=\"[SayFont]\">[m.getStrangerName(src)]<font color = white> has unsealed a [message] from their scroll.")