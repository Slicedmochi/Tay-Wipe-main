mob/proc/Payment()
	var/Paytimes=archive.month-LogMonth
	if(!Paytimes) return
	while(Paytimes>0)
		var/PaidRyo=0
		var/BaseRyo=rand(75,200)
		Paytimes--
		src<<"Your check has been sent to you with a sum of $[PaidRyo] Ryo!"
		var/hasryo=0
		for(var/obj/items/Ryo/R in contents)
			hasryo=R
		if(hasryo)
			hasryo:amount+=PaidRyo
			hasryo:Update()
		else
			var/obj/items/Ryo/R=new(src)
			R.amount=PaidRyo
			R.Update()
	LogMonth=archive.month
mob/var/LogMonth=6
proc/YearCheck(var/msg=1)
	if(Day>=31)
		Day=1
		archive.month+=1
	for(var/mob/M in world)
		if(!M.client) continue
		var/Paytimes=archive.month-M.LogMonth
		if(!Paytimes) return
		while(Paytimes>0)
			var/PaidRyo=0
			var/BaseRyo=rand(75,200)
			Paytimes--
			if(!PaidRyo) continue
			M<<"Your check has been sent to you with a sum of $[PaidRyo] Ryo!"
			switch(M.Trait)
				if("Fortunate I")
					PaidRyo+= 150
				if("Fortunate II")
					PaidRyo+= 300
				if("Fortunate III")
					PaidRyo+= 450
			M.give_ryo(PaidRyo)
		M.LogMonth=archive.month
	if(archive.month>12)
		archive.month=1
		archive.year+=1
		for(var/mob/P in world)
			if(P.client) P.Aging()
			P.LogMonth=archive.month
	if(msg) world<<"<font size=-1>Current date is the [Day][Days(Day)] of [Months(archive.month)] in the year [archive.year+100]"
//	global.OOC=!global.OOC
//	world<<"<font size=-1>The OOC channel has been [global.OOC ? "enabled" : "disabled"] during this day."
	SaveYear()
