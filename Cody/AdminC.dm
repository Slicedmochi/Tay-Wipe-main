mob/var/AdminRewardViewing
mob/var/AdminNotes=""
client
	Click(A,B,C)
		if(C == "Perk2.PerkGrid")
			if(istype(A,/obj/jutsu))
				if(usr.Admin)
					var/list/players=list()
					for(var/mob/ZZ in world)
						players+=ZZ
					var/mob/M = input("Choose a player") as mob in world
					if(!istype(A,/obj/jutsu)) return
					switch(input("Are you sure you want to give [M] the perk [A]?") in list ("Yes","No"))
						if("Yes")
							var/obj/Perk/O=copyatom(A)
							M:contents+=O
							for(var/mob/MM in world) if(MM.Admin) MM<< {"<font color=#F88017>[usr] gives [A] to [M]."}
							Admin_Logs+="<br>[usr]([usr.key]) gives [A] to [M]."
							SaveLogs()
						else
							return
			if(istype(A,/obj/items/jutsu_scroll))
				if(usr.Admin)
					var/list/players=list()
					if(!istype(A,/obj/items/jutsu_scroll)) return
					for(var/mob/ZZ in world)
						players+=ZZ
					var/mob/M = input("Choose a player") as mob in world
					switch(input("Are you sure you want to give [M] the perk [A]?") in list ("Yes","No"))
						if("Yes")
							var/obj/Perk/O=copyatom(A)
							M:contents+=O
							for(var/mob/MM in world) if(MM.Admin) MM<< {"<font color=#F88017>[usr] gives [A] to [M]."}
							Admin_Logs+="<br>[usr]([usr.key]) gives [A] to [M]."
							SaveLogs()
						else
							return
			if(istype(A,/mob/))
				if(usr.Admin)
					winset(usr, "MobGrid", "cells=0x0")
					winset(usr,"MobView","is-visible=true")
					usr << output(A,"MobGrid:1,1")
					usr.AdminRewardViewing=A
					var/list/rewardlist=list()
					var/total=0
					var/average=0
					for(var/mob/M in world)
						if(M.client)
							rewardlist+=M.lifetime_progress_points
							total+=M.lifetime_progress_points
					average = "[round(total/rewardlist.len)]"
					usr << output(null,"MobView.average")
					usr << output(null,"MobView.difference")
					usr << output(average,"MobView.average")
					usr << output("[round((total/rewardlist.len) - A:lifetime_progress_points)]","MobView.difference")
					usr<<output(null,"MobView.LogCheck")
					usr:ViewPlayerRPLog(A)
					usr << output(null,"MobView.AdminNotes")
					usr << output(A:AdminNotes,"MobView.AdminNotes")
		..()





mob/Admin3
	verb
		Make_Samurai(mob/M in world)
			set category = "Admin"
			M.contents+=new/obj/items/Weapon/Katana
			M.contents+=new/obj/items/Clothing/Samurai_Robe
			M.contents+=new/obj/items/Weapon/Tanto

		RewardTimerMinusPlusMagic()
			set hidden = 1
			var/Time=input("What is the amount?") as num
			usr << "You input [Time], world realtime is [world.realtime] <br>The difference is [world.realtime - Time].	"
		Player_Progress(var/mob/M in world)
			set category = "Admin"
			M.IsProgLocked=!M.IsProgLocked
			usr << "[M] [M.IsProgLocked ? "can" : "cannot"] progress now."
			for(var/mob/X in world)
				if(X.Admin)
					X << "[usr] has turned [M]'s progress [M.IsProgLocked ? "on" : "off"]"
			Admin_Logs+="[usr] has turned [M]'s progress [M.IsProgLocked ? "on" : "off"]"
		VillageCount()
			set category = "Admin"
			var/amount=0
			var/kiricount=0
			var/konocount=0
			for(var/mob/m in world)
				if(m.client) amount++
				if(m.Village=="Konohagakure") konocount++
				if(m.Village=="Kirigakure") kiricount++
			usr << "Players: [amount]"
			usr << "Konoha Count: [konocount]"
			usr << "Kiri Count: [kiricount]"
		RewardSelected()
			set hidden=1
			if(usr.AdminRewardViewing)
				usr:Reward(usr.AdminRewardViewing)
			else
				usr << "ERROR"


		Create_Custom_Jutsu()
			var
				JIcon
				CustomIcon
				JPower=0
				JImpact
				JDmg
				JDef
				JGenPower
			set category = "Admin"
			var/JName=input("What is the Jutsu's name, preferable in English?","English Name")
			var/JName2=input("What is the Jutsu's Name var? This should be Japanese.","Weeb Name")
			switch(input("Is this a Genjutsu?","Genjutsu") in list ("Yes","No"))
				if("Yes")
					JGenPower=input("What is the Genjutsu's power?","Jutsu Rank")
					JPower=1
				if("No")
					JDmg=input("Enter the damage ranking.","Damage")
					JDef=input("Enter the defense ranking.","Defense")
			switch(input("Do you have an icon for this?","Icon") in list ("Yes","No"))
				if("Yes")
					JIcon=input("What is the icon for this perk?","Icon") as icon
					CustomIcon=1
				if("No")
					CustomIcon=0
			var/JRank=input("What is the Jutsu's rank?","Jutsu Rank") in list ("A","B","C","D","E")
			var/JSuffix=input("Insert additional Admin Only information for the jutsu.","Suffix") as message
			var/JDesc=input("Enter the Description for the Jutsu","Description") as message
			var/JSDrain=input("Enter the Chakra/Stamina drain.","Chakra and Stamina")
			var/JSpeed=input("Enter the Speed.","Speed")
			var/JTD=input("Enter the Turn Duration","Turn DURATION!")
			var/JNotes=input("Enter some extra notes about the Jutsu!","Notes") as message
			var/JColor=""
			if(JRank=="A")
				JColor="red"
			if(JRank=="B")
				JColor="blue"
			if(JRank=="C")
				JColor="green"
			if(JRank=="D")
				JColor="grey"
			else
				JColor="white"
			var/obj/NewJutsu = new/obj/jutsu
			NewJutsu:name=JName2
			NewJutsu:suffix=JSuffix
			if(CustomIcon)
				NewJutsu:icon=JIcon
			else
				NewJutsu:icon='NoIcon.png'
			if(JPower)
				JImpact = "Power: [JGenPower]"
			else
				JImpact = "Damage: [JDmg] Defense: [JDef]"
			NewJutsu:desc={"<font color=white><b><font face="Arial"><font size=1>[JName]</b></font>
<font color=[JColor]><i><font face="Arial"><font size=1>[JRank]-Rank</i></font>
<font color=white><font face="Arial"><font size=1><u><b>Jutsu Information<br></u></b></font>
[JDesc]
<center><font color=white><font face="Tahoma"><font size=1><b><Font color=#A81C1C>\[[JImpact]] <font color=#50CDF3>\[Chakra/Stamina Cost: [JSDrain]]
<font color=#2EC13A>\[Speed: [JSpeed]] <font color=#768177> \[Turn Duration: [JTD]] </b></font><br>
 [JNotes]</center>"}
 			Archive_Jutsu(NewJutsu)
		RewardHistory()
			set category = "Admin"
			winset(usr, "PerkGrid", "cells=0x0")
			var/height = 1
			var/width = 0
			var/list/playerrewards=new/list()
			var/Dayz = input("How many days since players last reward?","Days") as num
			for(var/mob/M in world)
				if(M.client)
					if(Dayz<=round((world.realtime - M.LastRewardTime)/864000))
						playerrewards+=M
			winset(usr,"Perk2","is-visible=true")
			for(var/mob/X in playerrewards)
				if(width>=2)
					width=0
					height+=1
				usr << output(X,"PerkGrid:[++width],[height]")
				usr << output("<font color=white>[X] | Days Passed: [round((world.realtime - X.LastRewardTime)/864000)] | PP: [X.lifetime_progress_points] | Last Reward: [X.LastAdminReward]", "PerkGrid:[++width],[height]")
		CloseMobView()
			set hidden = 1
			winset(usr, "MobGrid", "cells=0x0")
			winset(usr,"MobView","is-visible=false")
			usr << output(null,"MobView.average")
			usr << output(null,"MobView.difference")
			usr<<output(null,"MobView.LogCheck")
			usr << output(null,"MobView.AdminNotes")
		AddNote()
			set hidden = 1
			usr:NoteAdd(usr.AdminRewardViewing)
		ClearNote()
			set hidden = 1
			usr:NoteClear(usr.AdminRewardViewing)

		NoteAdd(mob/M in world)
			set hidden = 1
			var/notes=input("What notes do you want to add? Blank to cancel") as message
			if(notes)
				M.AdminNotes+="[notes]<br>"
		NoteClear(mob/M in world)
			set hidden = 1
			switch(input("Are you sure you want to clear [M]'s notes?") in list ("Yes","No"))
				if("Yes")
					M.AdminNotes=""
				if("No") return
		ViewPlayerRPLog(mob/M in world)
			set category="Admin"
			set hidden = 1
			var/wtf=0
			var/list/Blah=new
			var/View={"<html>
	<head><title></head></title><body>
	<body bgcolor="#000000"><font size=3><font color="#0099FF"><font size=-1><b><i>
	<font color="#00FFFF">**[M]'s Logged Activities**<br>
	</body><html>"}

			LOLWTF
			wtf+=1
			var/XXX=file("Saga/SelfRPLogs/[M.ckey]/[M.ckey][wtf].txt")
			if(fexists(XXX))
				Blah.Add(XXX)
				goto LOLWTF
			else
				if(Blah&&wtf>1)
					var/lawl=input("What one do you want to read?") in Blah
					var/ISF=file2text(lawl)
					View+=ISF
					usr<<"[File_Size(lawl)] File [lawl]"
					usr<<output(View,"MobView.LogCheck")
					SAdmin_Logs+="<br>[usr]([usr.key]) uses views [M]'s playerlogs. ([time2text(world.realtime)])"
					for(var/mob/MM in world) if(MM.ckey=="TiltHour") MM<< {"<font color=#F88017>[src] views [M]'s playerlog."}
				else
					usr<<"No logs found for [M.ckey]"
