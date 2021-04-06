mob/var/tmp/resting=0
mob/var/tmp/allowmed=1
mob/verb
	Meditate()
		set category = "Combat"
		set name="Rest"
	//	if(src.RecentVerbCheck("Meditate", 1,1)) return
		var/mob/controlMob = src
		if(MindTransfer) controlMob = MindTransfer
		if(controlMob.Cooking)
			return
		if(controlMob.Mining)
			return
		if(controlMob.Fishing)
			return
		if(controlMob.KO)
			return
		if(!controlMob.resting&&controlMob.move&&controlMob.allowmed)
			controlMob.recentverbs["Meditate"]=world.realtime
			controlMob.resting=1
			controlMob.icon_state="Focus"
			controlMob.move=0
			controlMob.rest()
			controlMob.meditate()
		else
			controlMob.resting=0
			controlMob.icon_state=""
			controlMob.move=1
mob/proc
	rest()
		if(!src) return
mob/proc
	bedrest()
mob/proc
	benchrest()
mob/proc
	meditate()


