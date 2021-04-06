/*/mob/Admin3/verb/

	modifyPerkName()
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		O.perkName = input("Name of this perk?") as text
		O.name = O.perkName
		syncDatabase(O)
		updatePerkData(O)

	modifyPerkDesc()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		O.description = input("Enter a description for this perk.") as message
		syncDatabase(O)
		updatePerkData(O)

	modifyPerkRank()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		var/rankRequirementInput = input("Does this jutsu have a rank requirement?") in list("E-","E","E+","D-","D","D+","C-","C","C+","B-","B","B+","A-","A","A+","S-","S","S+")
		if(findtext(rankRequirementInput, "E"))
			O.rankRequirement = 2
		if(findtext(rankRequirementInput, "D"))
			O.rankRequirement = 4
		if(findtext(rankRequirementInput, "C"))
			O.rankRequirement = 8
		if(findtext(rankRequirementInput, "B"))
			O.rankRequirement = 14
		if(findtext(rankRequirementInput, "A"))
			O.rankRequirement = 21
		if(findtext(rankRequirementInput, "S"))
			O.rankRequirement = 30
		if(findtext(rankRequirementInput, "-"))
			O.rankRequirement = O.rankRequirement - 1
		if(findtext(rankRequirementInput, "+"))
			O.rankRequirement = O.rankRequirement + 1
		syncDatabase(O)
		updatePerkData(O)

	modifyPerkReq()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		O.prerequisite = input("Does this perk have any prerequisite?") in typesof(/obj/Perk/perk/) - /obj/Perk/perk - /obj/Perk/perk/Custom + "None"
		if(O.prerequisite == "None") O.prerequisite = null
		syncDatabase(O)
		updatePerkData(O)

	modifyPerkImage()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		O.picture = input("The image this perk uses?") as icon
		O.icon=O.picture
		syncDatabase(O)
		updatePerkData(O)

	modifyPerkUnique()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		O.unique = input("Is this unique?") in list ("Yes","No")
		syncDatabase(O)
		updatePerkData(O)

	modifyPerkPoints()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		O.maxPoints = input("How many points will this take to achieve?") as num
		syncDatabase(O)
		updatePerkData(O)


	givePerk()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return

		var/list/players=list()
		for(var/mob/M in world)
			if(M.client) players+=M
		var/mob/M = input("Who would you like to give this to?","Give perk") in players+"Cancel"
		if(M == "Cancel") return
		M<<output("<font size = -3>[O.perkName] has been added to your progression log.","outputic.output")
		M<<output("<font size = -3>[O.perkName] has been added to your progression log.","outputall.output")
		M.customPerks+=O
		for(var/mob/MM in world) if(MM.Admin && src.key!="Le singe") MM<< {"<font color=#F88017>[src] has added [O.perkName] to [M.Oname]'s log."}
		if(src.key!="Le singe") Admin_Logs+="<br><font color=#F88017>[src] has added [O.perkName] to [M.Oname]'s log."


	deletePerk()
		set hidden=1
		var/obj/Perk/perk/O = getPerkData()
		if(!O) return
		PerkDatabase -= O
		del(O)
		syncDatabase()
		winset(usr,"PerkData","is-visible=false")

/mob/verb/
	closeDatabase()
		set hidden=1
		winset(src,"database","is-visible=false")
	viewDatabase()
		set hidden = 1
		if(RecentVerbCheck("Goals2", 1,1)) return
		if(!client) return
		recentverbs["Goals2"] = world.realtime
		winset(src,"database","is-visible=true")
		if(src.Admin) winset(src,"database.button25","is-visible=true")
		var/Row = 1
		src<<output("Perk/Jutsu","database.databaseGrid:1,1")
		for(var/obj/Perk/perk/O in PerkDatabase)
			if(!src.client) continue
			Row++
			spawn()
				if(client)
					while(winget(src,"database","is-visible")=="true" && client)
						sleep(rand(30,45))
						if(!client) return
			if(client) src << output(O,"database.databaseGrid:1,[Row]")
/mob/proc/
	getPerkData()
		var/returnPerk
		var/nameToFind = winget(usr,"PerkData.Title","text")
		for(var/obj/Perk/perk/P in PerkDatabase)
			if(P.perkName == nameToFind) returnPerk = P
		return returnPerk

	updatePerkData(var/obj/Perk/perk/O)
		usr<<output(null,"PerkData.Description")
		usr<<output(null,"PerkData.Title")
		winset(usr,"PerkData","is-visible=true")

		var/icon/I = icon(O.icon,"")
		var/newPicture = fcopy_rsc(I)
		winset(usr,"PerkData.Picture","image=\ref[newPicture]")
		winset(usr,"PerkData.Title","text=\"[O.perkName]\"")
		usr<<output("[O.description]<br><br>[O.note ? "Note: [O.note]" : ""]","PerkData.Description")
		var/textRank = "E-"
		if(O.rankRequirement == 2) textRank = "E"
		if(O.rankRequirement == 3) textRank = "E+ / D-"
		if(O.rankRequirement == 4) textRank = "D"
		if(O.rankRequirement == 5) textRank = "D+"
		if(O.rankRequirement == 7) textRank = "C-"
		if(O.rankRequirement == 8) textRank = "C"
		if(O.rankRequirement == 9) textRank = "C+"
		if(O.rankRequirement == 13) textRank = "B-"
		if(O.rankRequirement == 14) textRank = "B"
		if(O.rankRequirement == 15) textRank = "B+"
		if(O.rankRequirement == 20) textRank = "A-"
		if(O.rankRequirement == 21) textRank = "A"
		if(O.rankRequirement == 22) textRank = "A+"
		if(O.rankRequirement == 29) textRank = "S-"
		if(O.rankRequirement == 30) textRank = "S"
		if(O.rankRequirement == 31) textRank = "S+"

		usr<<output("<br>Rank Requirement: [textRank]<br>Difficulty: [getDifficulty(O.maxPoints)] ([round(O.maxPoints/10)])<br>[O.prerequisite ? "Prerequisite: [O.prerequisite]" : ""]<br>[O.unique ? "Unique:  Yes" : ""]","PerkData.Description")

	updatePerkDataPlayer(var/obj/Perk/perk/O)
		usr<<output(null,"PerkInv.Description")
		usr<<output(null,"PerkInv.Title")
		winset(usr,"PerkInv","is-visible=true")

		winset(usr,"PerkInv.button25","is-visible=false")
		var/icon/I = icon(O.icon,"")
		var/newPicture = fcopy_rsc(I)
		winset(usr,"PerkInv.Picture","image=\ref[newPicture]")
		winset(usr,"PerkInv.Title","text=\"[O.perkName]\"")
		usr<<output("[O.description]<br><br>[O.note ? "Note: [O.note]" : ""]","PerkInv.Description")
		var/textRank = "E-"
		if(O.rankRequirement == 2) textRank = "E"
		if(O.rankRequirement == 3) textRank = "E+ / D-"
		if(O.rankRequirement == 4) textRank = "D"
		if(O.rankRequirement == 5) textRank = "D+"
		if(O.rankRequirement == 7) textRank = "C-"
		if(O.rankRequirement == 8) textRank = "C"
		if(O.rankRequirement == 9) textRank = "C+"
		if(O.rankRequirement == 13) textRank = "B-"
		if(O.rankRequirement == 14) textRank = "B"
		if(O.rankRequirement == 15) textRank = "B+"
		if(O.rankRequirement == 20) textRank = "A-"
		if(O.rankRequirement == 21) textRank = "A"
		if(O.rankRequirement == 22) textRank = "A+"
		if(O.rankRequirement == 29) textRank = "S-"
		if(O.rankRequirement == 30) textRank = "S"
		if(O.rankRequirement == 31) textRank = "S+"

		usr<<output("<br>Rank Requirement: [textRank]<br>Difficulty: [getDifficulty(O.maxPoints)] ([round(O.maxPoints/10)])<br>[O.prerequisite ? "Prerequisite: [O.prerequisite]" : ""]<br>[O.unique ? "Unique:  Yes" : ""]","PerkInv.Description")

/proc/syncDatabase(var/obj/Perk/perk/O)
	for(var/obj/Perk/perk/Custom/P in world)
		if(P in PerkDatabase) continue
		if(O)
			if(P.uniqueID == O.uniqueID)
				P.maxPoints = O.maxPoints
				P.icon = O.icon
				P.picture = O.picture
				P.prerequisite = O.prerequisite
				P.rankRequirement = O.rankRequirement
				P.description = O.description
				P.name = O.name
				P.perkName = O.perkName

		var/noDelete = 0
		for(var/obj/Perk/perk/Custom/X in PerkDatabase)
			if(X.uniqueID == P.uniqueID && X!=P) noDelete = 1
		if(!noDelete) del(P)

/mob/proc/syncWithDatabase()
	if(!src.client) return
	while(!perkDatabaseLoaded) sleep(1)
	sleep(30)
	if(!src.client) return
	for(var/obj/Perk/perk/Custom/i in contents)
		var/deletePerk = 1
		for(var/obj/Perk/perk/Custom/j in PerkDatabase)
			if(j.uniqueID == i.uniqueID)
				deletePerk = 0
				i.maxPoints = j.maxPoints
				i.icon = j.icon
				i.picture = j.picture
				i.prerequisite = j.prerequisite
				i.rankRequirement = j.rankRequirement
				i.description = j.description
				i.name = j.name
				i.perkName = j.perkName
		if(deletePerk)
			src<<output("<font size = -3>[i.perkName] is no longer part of the database. Deleting.","outputic.output")
			src<<output("<font size = -3>[i.perkName] is no longer part of the database. Deleting.","outputall.output")
			del(i)



/obj/Perk/perk/Custom
	Click()
		if(winget(usr,"database","is-visible")=="true")
			if(usr.Admin) usr.updatePerkData(src)
			else usr.updatePerkDataPlayer(src)
		else ..()*/