/*
Types:
	Regular
	Kage
	Mizu
	Suna
	Jujin
	Mushi
Commands:
	Follow
	Stay
	Attack
	Click + Drag = Move
*/
mob/var/tmp/list/bunshinList=list()
mob/Bunshin/MouseDrag()
	if(src.displaykey==usr.key)
		mouse_drag_pointer=icon(src.icon,src.icon_state,src.dir)
mob/Bunshin/New()
	..()
	mouse_drag_pointer=icon(src.icon,src.icon_state,src.dir)


mob/Bunshin/MouseDrop(o_o,s_l,o_l) //make it so if an object has been dragged to someplace...
	..()
	if(src.displaykey==usr.key)
		if(isturf(o_l)) //making sure it was dropped on the map, and not in a statpanel or off the map
			walk_towards(src,o_l)

mob/Bunshin
	var/function
	New()
		..()
		spawn() Run()
	Click()
		if(displaykey==usr.key)
			var/list/Choices=new/list
			Choices.Add("Follow")
			Choices.Add("Stay")
			Choices.Add("Destroy Bunshin")
			Choices.Add("Destroy Bunshins")
			Choices.Add("Cancel")
			switch(input("Choose Option","",text) in Choices)


				if("Clone POV")
					if(!usr.MindTransfer)
						usr.MindTransfer=src
						src.MindAfflicted=usr
						usr.client.eye=src
						usr.client.perspective=EYE_PERSPECTIVE
						return
					if(usr.MindTransfer)
						usr.MindTransfer.MindAfflicted=0
						usr.MindTransfer=null
						usr.client.eye=usr
						usr.client.perspective=EYE_PERSPECTIVE
						return


				if("Destroy Bunshins")
					if(!src) return
					if(usr.MindTransfer)
						usr.MindTransfer.MindAfflicted=0
						usr.MindTransfer=null
						usr.client.eye=usr
						usr.client.perspective=EYE_PERSPECTIVE
					usr.bunshinList -= src
					for(var/mob/Bunshin/A in world)
						if(A==src) continue
						if(A.displaykey==usr.key)
							usr.bunshinList -= A
							A.overlays = null
							del(A)
						del(src)
				if("Destroy Bunshin")
					if(!src) return
					if(usr.MindTransfer)
						usr.MindTransfer.MindAfflicted=0
						usr.MindTransfer=null
						usr.client.eye=usr
						usr.client.perspective=EYE_PERSPECTIVE
					usr.bunshinList -= src
					src.overlays = null
					flick('Smoke.dmi',src)
					del(src)
				if("Follow")
					function=1
					spawn while(function==1)
						sleep(5)
						if(prob(20)) step_rand(src)
						else step_towards(src,usr)
				if("Stay") function=2
				if("Attack Target")
					function=3
					var/mob/list/Targets=new/list
					for(var/mob/M in oviewers(12)) Targets.Add(M)
					var/mob/Choice=input("Attack who?") in Targets
					for(var/mob/M in oviewers(12)) if(Choice==M)
						spawn while(function==3)
							sleep(20)
							if(prob(10)) step_rand(src)
							else step_towards(src,M)
		else
			usr<<output("<font size = -3>This figure does not possess a shadow.","outputic.output")