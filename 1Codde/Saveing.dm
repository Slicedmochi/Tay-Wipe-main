mob/var/Savable=1
mob
	proc
		Save()
			if(roaming)
				var/obj/lastAI = AIHandler.db[key][AIHandler.db[key].len]
				loc = locate(lastAI.x, lastAI.y, lastAI.z)
				move = 0
				overlays -= 'roam.dmi'
			if(!src.loc)
				return
			if(src.loc==locate(37,239,28))
				return
			var/savefile/F=new("Save/[src.ckey]")
			F["x"]<<src.x
			F["y"]<<src.y
			F["z"]<<src.z
			Write(F)
		AutoSave()
			Save()
			spawn(6000)
				AutoSave()
		Load()
			if(client)
				if(fexists("Save/[src.ckey]"))
					var/savefile/F=new("Save/[src.ckey]")
					Read(F)
					F["x"]>>src.x
					F["y"]>>src.y
					F["z"]>>src.z
					src.loc = locate(src.x,src.y,src.z)
					overlays-='afk.dmi'
					overlays -= 'Swim.dmi'
					overlays-='Bubble.dmi'
					src.icon_state=""
					pixel_y=0
					pixel_x=0
					see_in_dark=99
					if(!usr.icon) usr.icon=usr.Oicon
					AddToOnline(src)
					src << "<font size=-1>Current date is the [archive.day][Days(archive.day)] of [Months(archive.month)] in the year [archive.year]"
					src << "Update [archive.updatever]"
					src << "Link to the discord: [archive.discordinvite]"
					FixIcon(src)
					for(var/obj/items/Weapon/Torch/T in src.contents)
						T.worn = 0
						T.suffix=""
						overlays -= T.icon
					OOCFont = "#858755"
					if(client.IsByondMember())
						OOCFont = "#81BDD9"
					if(Admin)
						OOCFont="#3B56E1"
					if(Donator)
						OOCFont = "#B52735"
					checkSubscription()
					loadCharacterSheet()
					checkOfflineReward()
					updatetiles()
					incombat = locatecombat()
					AIHandler.loginReset(src)
					lastOn = time2text(world.realtime,"DD/MM/YYYY")
					src.text = null
					src.see_invisible = 0
				else
					alert("You do not have any characters on this server.")
					del(src)

mob/var/lastOn