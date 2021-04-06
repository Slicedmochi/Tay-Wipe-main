mob/var/tmp/
	onwater=0
	oncliff=0
	waterproc=0
	ontree=0
	onmud=0
	swim=0
turf/Terrain
	icon='Turf.dmi'
	Water
		icon_state="water"
		Entered(mob/M)
			if(ismob(M)&&M.Convert)
				M.onwater=1
			if(ismob(M)&&M.Convert==0)
				if(!M.overlays.Find('Swim.dmi')) M.overlays += 'Swim.dmi'
				M.swim=1
		Exited(mob/M)
			if(ismob(M)&&M.Convert)
				M.onwater=0
			if(ismob(M)&&M.Convert==0)
				M.overlays -= 'Swim.dmi'
				M.swim=0
				M.onwater=0
	Fishing_Spot
		Entered(mob/M)
			if(ismob(M)&&M.Convert==0)
				if(!M.overlays.Find('Swim.dmi')) M.overlays += 'Swim.dmi'
				M.swim=1
				M.onwater=1
		Exited(mob/M)
			if(ismob(M)&&M.Convert==0)
				if(!M.overlays.Find('Swim.dmi')) M.overlays -= 'Swim.dmi'
				M.swim=0
				M.onwater=0



turf/Terrain
	RuinBuildings
		Houses
			icon='housescountry.dmi'
		RuinWalls123
			icon='ruinwall.dmi'
		Sidewall
			icon='side.dmi'

turf/Terrain
	icon='Turf.dmi'
	Cliff2
		icon_state="cliff2"
		density=1
	Cliff1a
		icon_state="cliff1a"
		density=1
	Cliff2a
		icon_state="cliff2a"
		density=1
turf/Terrain/Cliff
	icon='Turf.dmi'
	icon_state="cliff"
	Entered(mob/M)
		if(ismob(M)&&M.Convert)
			if(src.icon_state=="cliff")
				M.oncliff=1
	Enter(mob/M)
		if(ismob(M))
			if(M.Convert)
				return ..()
			if(src.icon_state=="cliff")
				M<<output("<font size = -3>You struggle to climb up the mountain without chakra padding!","outputic.output")
				M<<output("<font size = -3>You struggle to climb up the mountain without chakra padding!","outputall.output")
				return 0
			else return ..()
		..()

	Exited(mob/M)
		if(ismob(M)&&M.Convert)
			M.oncliff=0
		..()


turf/Terrain/shadow1
	icon='shadow.dmi'

turf/Sound/Wall
	icon='Turf.dmi'
	icon_state="cliff"
	density=1
	opacity=1
turf/Sound/Wall1
	icon='Turf.dmi'
	icon_state="cliff"
	density=0
	opacity=1



mob/var/tmp/Fishing=0
mob/Move()
	if(Fishing) return 0
	..()
obj/SparklingWater
	name="Sparkling Water"
	icon='Sparkling.dmi'
	var/BeingUsed=0
	Click()
		var/HasFishingPole=0
		if(usr.RecentVerbCheck("Fishing", 350,1)) return
		if(usr.afk) return
		if(usr.autoafk) return
		if(get_dist(src,usr)>1)
			usr<<output("<font size = -3>You're not close enough to fish here.","outputic.output")
			usr<<output("<font size = -3>You're not close enough to fish here.","outputall.output")
			return
		if(usr.Fishing)
			usr<<output("<font size = -3>You stop fishing.","outputic.output")
			usr<<output("<font size = -3>You stop fishing.","outputall.output")
			usr.Fishing=0
			usr.move=1
			usr.icon_state=""
			src.overlays-=image('fisherpole.dmi',icon_state = "bobber")
			return
		for(var/obj/items/Weapon/Fishing_Rod/F in usr.contents)
			if(F.worn) HasFishingPole=1
		if(!HasFishingPole)
			usr<<output("<font size = -3>You must have a fishing rod equipped to fish!","outputic.output")
			usr<<output("<font size = -3>You must have a fishing rod equipped to fish!","outputall.output")
			return
		usr.Fishing=1
		src.overlays=null
		src.overlays+=image('fisherpole.dmi',icon_state = "bobber")
		usr<<output("<font size = -3>You begin to fish.","outputic.output")
		usr.recentverbs["Fishing"] = world.realtime
		usr.dir=get_dir(usr,src)
		usr.move=0
		usr.icon_state="Attack"
		while(usr.Fishing)
			sleep(1)
			if(!usr.Fishing) return
			var/random=rand(1,35)
			if(prob(40)&&usr.Fishing)
				var/obj/A = new/obj/items/Food/Small_Fish
				usr.contents+=A
				usr<<output("<font size = -3>You have caught a [A].","outputic.output")
				usr<<output("<font size = -3>You have caught a [A].","outputall.output")
			else
				if(random==11&&usr.Fishing)
					var/obj/A = new/obj/items/Food/Big_Fish
					usr.contents+=A
					usr<<output("<font size = -3>You have caught a [A].","outputic.output")
					usr<<output("<font size = -3>You have caught a [A].","outputall.output")
				if(random==2&&usr.Fishing)
					var/obj/A = new/obj/items/Food/Med_Fish
					usr.contents+=A
					usr<<output("<font size = -3>You have caught a [A].","outputic.output")
					usr<<output("<font size = -3>You have caught a [A].","outputall.output")
				if(random==5&&usr.Fishing)
					var/obj/A = new/obj/items/Food/Med_Fish2
					usr.contents+=A
					usr<<output("<font size = -3>You have caught a [A].","outputic.output")
					usr<<output("<font size = -3>You have caught a [A].","outputall.output")
				if(random==8&&usr.Fishing)
					var/obj/A = new/obj/items/Food/Med_Fish3
					usr.contents+=A
					usr<<output("<font size = -3>You have caught a [A].","outputic.output")
					usr<<output("<font size = -3>You have caught a [A].","outputall.output")
				if(random==13&&usr.Fishing)
					var/obj/A = new/obj/items/Food/Med_Fish
					usr.contents+=A
					usr<<output("<font size = -3>You have caught a [A].","outputic.output")
					usr<<output("<font size = -3>You have caught a [A].","outputall.output")
			sleep(350)
			if(!usr.Fishing) return





turf/Terrain/checkboard
	icon='shogipieces.dmi'
	layer=20
	density=1




