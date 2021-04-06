//Captures a territory which seems to be an entire map
var/TerritoryHandler/THandler = new() // 720000 3pm, 1008000 11pm
/area/verb/Capture_Territory()
	set src in range()
	if(!usr.CurrentSquad) return
	if(usr.claiming) return
	if(world.timeofday < 720000 || world.timeofday > 1008000)
		usr._output("You can't capture this at this time, try again during 3-11pm EST", "selfalert", "outputall.output")
		return
	usr.CurrentSquad.CalculateRank()
	THandler.Capture(z, usr)
/mob/var/claiming = null
TerritoryHandler
	Del()
		db = list()
		..()
	var/list/Territory/db = list()
	//we must handle these
	proc/Finalize(Territory/x , n)
		db["[n]"].Remove(x)
		db["[n]"] = list()
		del x
		if(x.contested)
			world<<"It was contested, the squad trying to take it has failed."
		else
			world<<"Please gm help, if you have taken this over."
		
	proc/Capture(n,atk)
		if(!db["Territory [n]"])
			db["Territory [n]"] = list() 
			db["Territory [n]"] += new/Territory(atk,null,world.time)
		else
			db["Territory [n]"] += new/Territory(atk,null,world.time)
		world<<"Your Scouts have located a group capturing Territory [n], the Squad rank is X"
	proc/Update()
		for(var/y in db)
			for(var/Territory/x in db["[y]"])
				if(x.contested) continue
				if(world.time < x.endtime) continue
				if(world.time > x.endtime) // they did it
					//express they did it
					Finalize(x, y)
Territory
	New(atker, defend, time)
		starttime = time
		attackers = atker
		defenders = defend
		endtime = time + 1200
		..()
	var/attackers
	var/defenders
	var/contested = null
	var/starttime
	var/endtime // 27000
/mob/verb/testingsquadrank()
	var/n
	n += total_stats()
	n += 100
	n+= 140
	world<<get_rank_grade(null, n)
	world<<get_rank_grade(null, n/3)

/mob/var/Squad/CurrentSquad = null
/mob/verb/testsquad()
	CurrentSquad = new()
	CurrentSquad.CalculateRank()
Squad // A squad datum
	New(mob/p)
		members[p.key] = list(p.name, p.total_stats())
		p.verbs += /Squad/proc/Invite_To_Squad
		..()
	var/name
	var/rank
	var/leader
	var/list/members = list() // list("name" = list(key, rank))
	proc/Invite_To_Squad()
		set category = "Squad"
		var/mob/p = usr.FindPerson(input(usr, "Who do you want to invite?") in usr.SortPeople(usr.inView(TRUE)) + "Cancel")
		if(p.CurrentSquad) return
		if((input(p, "Do you want to join [p.getStrangerNameNoHTML(usr)]'s squad?") in list("Yes", "No")) == "Yes")
			members[p.key] = list(p.name, p.total_stats())
			p.CurrentSquad = src
	proc/CalculateRank()
		for(var/x in src.members)
			if(!FindPlayerByKey(x))
				if(src.members[x][2])
					continue
				world<<"A player is offline, and their rank was not saved, canceling calculation."
				return
			else
				continue
		var/n = 0
		for(var/x in src.members)
			if(FindPlayerByKey(x))
				n += FindPlayerByKey(x).total_stats()
			else
				n+= members[x][2]
		world<<n
		rank = get_rank_grade(null, n/3)
		//C- , B- , D-
		world<<"[rank]"