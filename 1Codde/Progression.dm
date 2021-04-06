
/world/New()
	..() 
	spawn(100) world<<"aaaa"
//var/global_progress_speed = 1
//mob/var/reward_point = 0
//mob/var/progress_points = 0
//mob/var/lifetime_progress_points = 0
/mob/var/temporaryBoost = 0
//mob/var/CanProgress=1
/*proc/progress_loop()
	while(world)
		sleep(125)
		if(logFrozen) continue
		for(var/mob/M)
			if(!M.client) continue
			if(world.realtime - M.progress_timer > 864000)
				M.progress_timer = world.realtime
				if(M.temporaryBoost) M.temporaryBoost--
				M.progress_today = 0
				if(M.temporaryBoost<=0) M.progress_speed = 1

			var/progress_rate = 1

			if(M.progress_today < M.progress_cap * M.progress_speed)
				progress_rate = 1
			else if(M.progress_today < M.progress_cap * M.progress_speed * 1.25)// * M.progress_speed * 1.7)
				progress_rate = 0.15
			else progress_rate = 0

			var/progress_amount
			if(is_active(M))
				progress_amount = rand(6,10) * M.progress_speed * progress_rate * M.progress_key
			else
				if(M.afk || M.autoafk) continue
				progress_amount = 0.01 * M.progress_speed * progress_rate * M.progress_key

			progress_amount = progress_amount * global_progress_speed

			M.reward_point += progress_amount

			if(M.reward_point > 500)//Higher this is, slower the gains.
				var/bonus = get_bonus(M)
				if(M.rping_for)
					M.progressedPerks[M.rping_for.perkName] += bonus
					M.perkCheck()
				else
					M.progress_points += bonus

				M.progress_today += bonus
				M.lifetime_progress_points += bonus
				M.reward_point = 0
				M.evaluate_grade()*/


/proc/is_ooc(text)
	if(copytext(text, length(text), length(text) + 1) in list("\]", ")", "}"))
		return 1
	if(copytext(text, 1, 2) in list("\[", "(", "{"))
		return 1
	return 0
/proc/is_active(var/mob/M)
	if(M.progress_activity > 0)
		M.progress_activity--
		return 1
	return 0
/proc/get_total_perks(var/mob/M)
	var/total_perks = 0
	for(var/obj/Perk/perk in M)
		total_perks++
	return total_perks
/proc/get_point_cap(var/mob/M)
	var/point_cap = 0
	var/rank = M.Grade
	if(findtext(rank, "E"))
		point_cap = 2//200
	if(findtext(rank, "D"))
		point_cap = 4//400
	if(findtext(rank, "C"))
		point_cap = 8//800
	if(findtext(rank, "B"))
		point_cap = 14//1400
	if(findtext(rank, "A"))
		point_cap = 21//2100
	if(findtext(rank, "S"))
		point_cap = 30//3000
	if(findtext(rank, "-"))
		point_cap = point_cap - 1//100
	if(findtext(rank, "+"))
		point_cap = point_cap + 1//100
	if(point_cap < 1) point_cap = 1//100
	return point_cap

///mob/var/progress_cap = 20//
//mob/var/progress_speed = 1
//mob/var/progress_today = 0
//mob/var/progress_timer = 0
//mob/var/progress_key = 1
//mob/var/progress_activity = 0
//mob/var/stars = 0

//the awful verbs
mob/proc/getPrereq()
	var/list/perks=list()
	for(var/obj/Perk/perk/P in contents)
		if(P.prerequisite)
			perks+=P.prerequisite
			while(P.prerequisite)
				P = new P.prerequisite
				if(P.prerequisite) perks+=P.prerequisite
	return perks
var/logFrozen=0
mob/var/list/customPerks = list()
mob/var/tmp/obj/Perk/perk/perkOpen = null
mob/var/progressedPerks = list()
mob/var/rewardLog = null
mob/var/obj/Perk/perk/rping_for = null
/*
/mob/Admin3/verb/change_state()
	set name="Toggle Log Freeze"
	set category="Admin"
	logFrozen=!logFrozen
	world<<"Progression is now [logFrozen ? "frozen" : "open"]."


/mob/verb/RewardRPX()
	set hidden=1
	winset(src,"RewardLog","is-visible=false")

/mob/verb/RewardRP()
	set hidden=1
	if(!client) return

	if(RecentVerbCheck("Goals", 1,1)) return
	recentverbs["Goals"] = world.realtime
	updateRPBox()
*/

/* /mob/proc/updateRPBox()
	if(!client) return
	winset(src,"RewardLog.Frozen","is-visible=false")
	if(logFrozen) winset(src,"RewardLog.Frozen","is-visible=true")
	winset(src,"RewardLog","is-visible=true")
	winset(src,"RewardLog.EXP","is-visible=true")
	winset(src,"RewardLog.ProgressionBar","is-visible=true")
	if(src.progress_speed > 1)
		winset(src,"RewardLog.Modifier","text=\"[temporaryBoost] days remaining on your [progress_speed]x modifier.\"")
	if(src.rping_for)
		winset(src,"RewardLog.EXP","text=\"[round(progressedPerks[src.rping_for.perkName]/10)]/[src.rping_for.maxPoints/10]\"")
		winset(src,"RewardLog.ProgressionBar","value=[(progressedPerks[src.rping_for.perkName]/src.rping_for.maxPoints)*100]")
	else
		winset(src,"RewardLog.EXP","is-visible=false")
		winset(src,"RewardLog.ProgressionBar","is-visible=false")
	src<<output(null,"RewardLog.ProgressPoints")
	src<<output(null,"RewardLog.Working")
	src<<output("[src.rping_for ? "<center><a href=?src=\ref[src];action=Perk;perk=[md5(rping_for.perkName)]>[rping_for.perkName]</a>" : "<center>Nothing"]","RewardLog.Working")
	winset(src,"RewardLog.perkGrid","cells=0x0")
	if(progress_points) src<<output("Overflow Points: [round(progress_points/10)]","RewardLog.ProgressPoints")
	var/Row = 1
	src<<output("Progressable Perks","RewardLog.perkGrid:1,1")
	src<<output("Difficulty","RewardLog.perkGrid:2,1")
	for(var/obj/Perk/perk/O in getAvailablePerks())
		if(!src.client) continue
		Row++
		if(!src.client) continue
		spawn()
			if(client)
				while(winget(src,"RewardLog","is-visible")=="true" && client)
					sleep(rand(30,45))
					if(!client)return
		if(!src.client) continue
		src << output(O,"RewardLog.perkGrid:1,[Row]")
		if(!src.client) continue
		src << output("[getDifficulty(O.maxPoints)] ([round(O.maxPoints/10)])","RewardLog.perkGrid:2,[Row]")
		if(!src.client) continue
*/
mob/proc/perkCheck()
	if(progressedPerks[src.rping_for.perkName] >= src.rping_for.maxPoints)
		src<<output("<font size = -3>You've earned [src.rping_for.perkName]!","outputic.output")
		src<<output("<font size = -3>You've earned [src.rping_for.perkName]!","outputall.output")
		src.ChatLog("<font color=red>[src.Oname]([src.key]) earned [src.rping_for.perkName]")
		for(var/obj/Perk/perk/P in contents)
			if(rping_for.prerequisite == P.type && !istype(rping_for,/obj/Perk/perk/Custom) && !rping_for.noDelete) del(P)
//		if(rping_for.type == /obj/Perk/perk/Faint_Sense) new/obj/Ninjutsu/Kagura_Shingan(src)
		var/obj/Perk/perk/perk = copyatom(rping_for)
		perk.name = perk.perkName
		perk.icon = perk.picture
		perk.loc = src
		perk.gridbased=0
		progressedPerks -= src.rping_for.perkName
		src.rping_for = null

obj/timeWarp
	name = "Warp to Timeskip (Click)"
	Click()
		if(usr.Dead) return
		if(usr.z!=28)
			usr.teleporting = 1
			usr.Move(locate(51,142,29))
			usr.resetLuminosity()
			usr.teleporting = 0
			return

var/timeskip=0
var/timewarp = new/obj/timeWarp()

LoginNotice
	Timeskip
		var/length = 1
		var/textLength = "one year"
		act(mob/M)
/mob/Admin4/verb/announceTimeskip()
	set name = "Announce TS"
	set category = "Admin"
	timeskip=!timeskip
	if(timeskip)
		world<<"There is a timeskip taking place. Select the warp in your character menu to teleport there."
