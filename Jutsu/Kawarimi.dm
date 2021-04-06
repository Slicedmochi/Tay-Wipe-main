/*STAGES
1)Click Kawa
2)Click Ground
3)Move To Ground
*/
obj
	Log
		var/Owner
		icon='Log.dmi'
mob/var/ShunshinDelay = 0 
turf/DblClick()
	var/area/A=src.loc.loc
	var/area/AA=usr.loc.loc
	if(istype(A,/area/Interior/NoShunshin)) return
	if(istype(AA,/area/Interior/NoShunshin)) return
	var/mob/ControlledMob=usr
	if(usr.MindTransfer)
		ControlledMob=usr.MindTransfer
	//jumpishere
	if(ControlledMob.Jump&&!ControlledMob.ShunshinDelay)
		if(!ControlledMob.move) return
		if(get_dist(src,ControlledMob)>8) return
		if(Enter(ControlledMob))
			ControlledMob.jump_animation(src)
		return