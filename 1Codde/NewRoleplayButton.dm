


mob/var/list/rpFlags = list()

obj/RPing
	icon='Bubble.dmi'
	layer=9999999999999



obj/RPFlag
	icon='flag.dmi'
	var/owner="Nobody"
	var/owner2
	var/Description="No description written."
	var/interactable = 0
	var/adminHiddenInfo
	Click()

		usr.custom_alert_html("<center><u>[name]</u><br><br>[Description][interactable=="Yes" ? "<br><br>If you are roleplaying towards this flag, alert the admins by clicking <a href=?src=\ref[src];action=rpflagalert>here</a>." : ""][usr.Admin&&adminHiddenInfo ? "<br><br>Hidden Admin Info: [adminHiddenInfo]" : ""]")
obj/CombatFlag
	icon='combatflag.dmi'
	var/owner="Nobody"
	var/owner2
	var/Description="No description written."
	Click()
		usr.custom_alert_html("<center><u>Combat Scenario</u><br><br>[Description]")
mob/verb
	Initiate_Combat()
		set category="Combat"
		for(var/obj/CombatFlag/RP in world)
			if(RP.owner==src.ckey)
				src<<output("<font size = -3>Your other combat flag has been deleted.","outputic.output")
				src<<output("<font size = -3>Your other combat flag has been deleted.","outputall.output")
				del(RP)
				return
		var/obj/CombatFlag/R=new(src.loc)
		R.owner2=src.name
		R.owner=src.ckey
		var/maxStack=input("Enter the maximum number of actions allowed in one roleplay.","Stacking Rules",3,1)
		var/concise=alert("Freeform roleplay, or short concise roleplay length limit?","Length Limit","Freeform","Concise")
		var/ruling=input("When faced with a problem, this situation's rulings are done based on?","Rulings") in list ("Dice","Debate","Admin")
		var/powerPlay=input("A character's power is based off of what combination of elements?","Powerplay") in list ("Perks","Rank","Rank+Perks")
		var/fightScenario=input("Decided realism level for this fight is? (Hardcore being no-bullshit, extremely lethal level)","Realism") in list ("For-fun","Realistic","Hardcore")
		var/killing=alert("Is murder/killing allowed in this fight?","Death","Yes","No")
		var/misc=input("Any other details you wish to include?") as message
		R.Description={"
There is a combat instance taking place here. This situation's rules include:<br><br>
Maximum number of actions allowed in one roleplay: [maxStack]<br>
Roleplaying length limit: [concise]<br>
Rulings based on: [ruling]<br>
Power influenced by: [powerPlay]<br>
Realism level: [fightScenario]<br>
Killing/Murder: [killing]<br>
[misc ? "Other information [misc]" : ""]
"}
	Roleplay_Flag()
		var/mob/ControlledMob=src
		if(MindTransfer)
			ControlledMob=MindTransfer
		if(alert(src,"Create or delete?","Create or Delete","Create","Delete")=="Create")
			var/i
			for(var/obj/o in src.rpFlags) i++
			if(i>=5)
				src<<"You have five roleplay flags created. Consider deleting one before creating anymore."
				return
			var/obj/RPFlag/R=new(ControlledMob.loc)
			R.Description=input("Write a description for this flag.") as message
			R.interactable = input("Is this flag interactable?") in list ("Yes","No")
			R.adminHiddenInfo = input("Is there any hidden information that should be restricted to admins only?") as message
			R.name = input("Give this flag a name.") as text
			if(length(R.name)>30) R.name = "Roleplay Flag"
			if(!R.name) R.name = "Roleplay Flag"
			global.rpFlags+=R
			src.rpFlags+=R
		else
			var/obj/O = input("Choose a flag to delete") in src.rpFlags
			if(O) del(O)
	CancelRoleplay()
		set hidden = 1
		var/mob/ControlledMob=src
		if(MindTransfer)
			ControlledMob=MindTransfer
		winset(src,"skinputbig","is-visible=false")
		winset(src,"skinputbig.skinputbar","text=\"\"")
		ControlledMob.overlays -= 'Bubble.dmi'
		src.overlays-='Bubble.dmi'
	Roleplay1()
		set hidden = 1
		return
//mob/verb
//	Remove()
//		set name = "Fix RP Bubble"
//		src.overlays -= /obj/RPing
//		src.overlays -= /obj/RPing
//Ths should do...s


//REMAEMABABRAR to add the new RP BUBBLE


/*mob/verb
	Change_Face_Icon(F as file)
		set hidden=1
		switch(alert(usr,"[usr].  Do you want this face icon?","Face Icon","Yes","No"))
			if("Yes")
				usr.faceicon = F
				usr.Ofaceicon = F
			if("No")
				alert(usr,"You have not changed your face icon!")*/