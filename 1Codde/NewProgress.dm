/********************************************/
/******** Coded by jOrDaN 10 DEC 2020 ********/
/********************************************/
//Archive vars
/archive/var/RewardTimer = 720000
mob/Admin5/verb/ChangeRewardTimer()
	set category = "Admin"
	var/num = input(src, "How much in hours?") as num
	num *= 36000
	message_admins("[src] just switched reward timers to every [num/36000] hour(s)")
	archive.RewardTimer = num
//New Mob Vars
/mob/var/IsProgLocked = 1
//New Procs
/mob/proc/Rewards(amount)
	amount = round(amount, 1)
	last_reward = amount
	stat_points += amount
	progress_points += amount
	lifetime_progress_points += amount
	_output("You have been rewarded [amount] point(s)", "selfalert", "outputall.output")
	character_box.update_stats(src)
/mob/proc/GetBonus()
	if(lifetime_progress_points < 115)
		return 3
	else if(lifetime_progress_points < 165)
		return 2
	else return 1
/mob/proc/CheckAge()
	if(Age <= 10 && !find_perk("Prodigy"))
		return TRUE 
	else return FALSE
/mob/proc/DailyReward(num, underage)
	if(underage)
		num /= 2
	Rewards(num)
/mob/proc/CheckSpam(rp)
	var/ticks = 0
	var/list/formerrp = splittext(lastrp, " ")
	var/list/currentrp = splittext(rp, " ")
	if(rerpcountertimer + 18000 < world.realtime) rerpcounter = 0
	for(var/x in 1 to formerrp.len)
		if(ticks >= currentrp.len / 10) break
		for(var/y in x to min(currentrp.len, x + 3))
			if(y<x) continue
			if(formerrp[x] == currentrp[y]) 
				ticks++
	world<<"did we gget here? [ticks]"
	if(ticks >= currentrp.len / 10)
		rerpcounter++
		rerpcountertimer = world.realtime
		src<<"You have added a tick to your rerpcounter, if you do the same or similar rp again, you will be punished. If you need to repost for somebody, send it in a pastebin.[rerpcounter]"
		if(rerpcounter>=2)
			src<<"Your prog has been locked for spamming rps"
		return TRUE
	else
		return FALSE
/mob/proc/Progress()//Progress, update the bar, see if u get a check 
	//update the bar first
	character_box.update_bars(src)
	//check to see if they can get more dailies
	if(max_dailies < 1)
		//check to see if u got a check, also check to see if u can get ur next check
		if(next_check < previous_check)
			max_dailies = 1
			next_check = 0
			character_box.progress_bar.color = "#099b46"
			character_box.update_bars(src)
		return
	if(daily_points >= archive.check_threshold)
		//give the check
		world<<"Check given"
		//take away max dailies, set next and prev, then reset the others, make daily = 1 for checking in other procs
		max_dailies--
		previous_check = world.realtime
		next_check = world.realtime + archive.RewardTimer
		daily_points = 0
		daily = 1
		character_box.progress_bar.color = "#757575"
		character_box.update_bars(src)
		DailyReward(GetBonus(), CheckAge())
/mob/proc/GivePoints(num)
	if(!daily) // if u can get dailies and u havent gotten one
		daily_points += num
	else if(daily_points <= 75)
		daily_points += num
/mob/proc/IsRecent(var/style) // check if there was another say/ rp recently
	switch(style)
		if("say")
			if(lastsaytimer + 50 > world.timeofday)
				return TRUE
			return FALSE
		if("rp")
			if(lastrptimer + 600 > world.timeofday)
				return TRUE
			return FALSE
/mob/proc/CheckRP(text , style) // text is the text, style is the style aka rp or say
	//check the rp, see if it is = to the last one
	switch(style)
		if("rp")
			if(text == lastrp) // if it is the last rp
				return FALSE
			if(CheckSpam(text))
				return FALSE 
			return TRUE
		if("say")
			if(is_ooc(text))
				return FALSE
			else if(lastsay == text)
				return FALSE
			return TRUE
/mob/proc/CalcProg(num,type, valid, recent) // take in the word counter nad if it is valid output their daily points in a number 
	if(!valid) return 0
	switch(type)
		if("say")
			if(recent) return 0.5
			return clamp(round((num/6), 1), 1, 2)
		if("rp")
			if(num >= 110 && recent)
				return clamp(round((num/55) * 10 , 1), 10, 20) / 4
			else if(num < 110 && recent)
				return clamp(round((num/55) * 10 , 1), 5, 10) / 2
			return clamp(round((num/55) * 10, 1), 10, 20)
/mob/proc/wordcount(string)
	var/characters = length(string)
	var/alpha = 0
	var/wordcount = 0
	for(var/i = 1, i <= characters, i++)
		switch(text2ascii(string,i))
			if(39) continue
			if(48 to 57, 65 to 90, 97 to 122) /*0-9, A-Z, a-z*/
				if(!alpha) {alpha = !alpha; wordcount++}
			else
				if(alpha)  {alpha = !alpha}
	return wordcount