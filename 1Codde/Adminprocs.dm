/********************************************/
/******** Coded by jOrDaN 24 Nov 2020 ********/
/********************************************/
var/list/OnlineList = list()
/proc/AddToOnline(mob/p)
	if(OnlineList[p.key])
		OnlineList[p.key] -= p
		OnlineList -= p.key
	if(p)
		if(!OnlineList[p.key])
			OnlineList[p.key] = list()
		OnlineList[p.key] += p 
/proc/RemoveFromOnline(mob/p)
	if(OnlineList[p.key])
		OnlineList[p.key] -= p
		OnlineList -= p.key
/proc/FindAdmins()
	var/mob/list/admins = list()
	for(var/keys in OnlineList)
		for(var/mob/p in OnlineList[keys])
			if(p.Admin)
				admins += p         
	return admins
/proc/ListOfPlayers()
	var/mob/list/players = list()
	for(var/keys in OnlineList)
		for(var/mob/p in OnlineList[keys])
			players += p
	return players
/proc/FindPlayerByKey(key)
	if(OnlineList[key])
		return OnlineList[key][1]
	else return null
proc/message_admins(t as text)
	for(var/mob/M in FindAdmins())
		M<<"[t]"
//Debug
/mob/verb/pingadmins()
	message_admins("test")
mob/Admin4/verb/ChangeTitleSong()
	archive.title_video = input(src, "The link", "yuh") as message
	if(length(archive.title_video) != 11) 
		archive.title_video = "KbNL9ZyB49c"
/mob/Admin3/verb/MuteSay(mob/p in ListOfPlayers())
	var/choice = input(src, "What kind of mute? If they are already muted, this will unmute them.") in list("Say", "LOOC", "Roleplay")
	if(p.muted[choice])
		p._output("You have been unmuted from [choice]", "selfalert", "outputall.output")
		p.muted[choice] = 0
	else
		p._output("You have been muted from [choice]", "selfalert", "outputall.output")
		p.muted[choice] = 1
