// aoes
obj
	var/owner_ref
	proc
		SetOwner(mob/person)
			owner_ref = "\ref[person]"
		Owner()
			return locate(owner_ref)
mob
	var
		tmp/list/aoelist = list()
	verb
		ClearGrid()
			set category = "Combat Testing"
			for(var/obj/AOE/x in aoelist)
				x.remove()
			aoelist = list()
obj/AOE
	icon = 'AOE.dmi'
	var/owner
	var/obj/jutsu/linked = list()
	var/details = ""
	proc/FormDetails()
		for(var/x in linked)
			details+="<br>_________________<br><a href=?src=[owner_ref];action=Perk;perk=[x]>[locate(x).name]</a>"
		details+="<br>_________________<br>[Owner().strangerName]'s AOE."
	New(mob/p)
		p.aoelist += src
		SetOwner(p)
		..()
	Click()
		usr<<browse(details,"window=[src];size=500x350")
	proc
		remove()
			for(var/y in vis_locs)
				vis_locs -= y 
			Owner().aoelist -= src
			loc = null
			del src
world
	New()
		..()
		for(var/obj/AOE/x in world)
			del x
/mob/verb/Grid()
	set category = "Combat Testing"
	var/radius = input(usr, "What is the size of the AOE? (3x3, 2x3, etc)", "Size?") as text
	var/obj/jutsu/perk/otherstuff = get_perks()
	var/obj/jutsu/J = input(src, "What Jutsu are you using?", "What Jutsu?") in get_jutsus()
	var/obj/jutsu/p
	aoelist += new/obj/AOE(src)
	aoelist[1].linked+= "\ref[findArchivePerk(J.name)]"
	while(p != "Done")
		p = input(src, "Any perks used?", "Any perks?") in otherstuff + "Done"
		if(p == "Done")
			break
		aoelist[1].linked+= "\ref[findArchivePerk(p.name)]"
		otherstuff-=p
		sleep(1)
	for(var/turf/x in range(radius,src))  
		if(aoelist.len > 50)
			ClearGrid()
			break
		aoelist[1].vis_locs += x
	aoelist[1].FormDetails()
