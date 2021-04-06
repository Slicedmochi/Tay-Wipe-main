mob/var/tmp
	list/recentverbs = list()
mob/proc/RecentVerbCheck(var/verbs, var/timer, var/spam = 0)
	if(src.Admin) return 0
	if(recentverbs["[verbs]"])
		if(world.realtime-recentverbs["[verbs]"] < timer)
			if(spam) src << output("<font size = -3>You must wait before using this.","outputic.output")
			if(spam) src << output("<font size = -3>You must wait before using this.","outputall.output")
			return 1
	return 0

mob
	var
		tmp/move=1
		tmp/overlayed
mob/var/tmp/DeathWarnings=0
mob
	proc
		Regenerate()
			set background = 1
			while(src)
				sleep(rand(30,50))
				if(!name) del(src)
				see_in_dark=99
				if(usr.Byakugan) see_in_dark=90
				if(usr.Sharingan) see_in_dark=99
				if(usr.Ghost) see_in_dark=99
				if(Fishing&&autoafk)
					Fishing=0
					move=1
					src<<output("<font size = -3>You were forced to stop fishing!","outputic.output")
					src<<output("<font size = -3>You were forced to stop fishing!","outputall.output")
					icon_state=""
				if(Mining&&autoafk)
					Mining=0
					move=1
					src<<output("<font size = -3>You were forced to stop mining!","outputic.output")
					src<<output("<font size = -3>You were forced to stop mining!","outputall.output")
					icon_state=""
				/*src.Learning()*/
				Ko()