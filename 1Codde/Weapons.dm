obj/items/Chakra_Paper
	icon='Paper.dmi'
	verb/Chakra_Test()
		set src in usr
		usr << "Your primary element is: [usr.PrimaryElement]"
		usr << "Your secondary element is: [usr.SecondaryElement]"
		if(usr.Has3rd)
			usr<< "Your Trietary Element is: [usr.TrietaryElement]"
		del src

mob/Tsukuyomi_Body
	icon='Tsukuyomi.dmi'
	icon_state="Base"
obj/Bloodtrail
	icon='bloodtrail.dmi'
	icon_state=""
	var/mob/Owner
	New()
		..()
		if(icon == 'bloodtrail.dmi')
			spawn()
				icon_state=""
				var/turf/T=src.loc
				if(!T) del(src)
				while(Owner in T)
					src.icon_state="front"
					sleep(1)
				spawn(3)
					var/TOP = 0
					var/BOTTOM = 0
					var/LEFT = 0
					var/RIGHT = 0
					for(var/obj/Bloodtrail/O in get_step(src,NORTH))
						TOP = 1
					for(var/obj/Bloodtrail/O in get_step(src,SOUTH))
						BOTTOM = 1
					for(var/obj/Bloodtrail/O in get_step(src,EAST))
						RIGHT = 1
					for(var/obj/Bloodtrail/O in get_step(src,WEST))
						LEFT = 1
					if(TOP&&RIGHT)
						icon_state="dl"
					if(TOP&&LEFT)
						icon_state="dr"
					if(BOTTOM&&RIGHT)
						icon_state="tl"
					if(BOTTOM&&LEFT)
						icon_state="tr"
	Click()
		if(get_dist(src,usr)>1) return
		del(src)

mob/Dead_Body
	var/Bloods=145
	var/Bloodied=0
	var/description="No visible markings."
	var/Killer="Unknown"
	var/Capacity=0
	var/MaxCapacity=1500
	var/list/Contents=list()
	var/ContainerName
	var/Verification
	Click()
		if(get_dist(src,usr)>1) return
		ContainerName = src.name
		var/list/option = list()
		var/obj/items/Scrolls/Scroll/x = locate() in usr
		if(x)
			option += "Seal" 
		var/choice=input(usr,"Choose an option","[src]") in list ("Bury","Examine","Inventory") + option
		switch(choice)
			if("Examine")
				usr<<output("<font size = -3>[src] description: [description]","outputic.output")
				usr<<output("<font size = -3>[src] description: [description]","outputall.output")
				return
			/*if("Bury")
				var/turf/Terrain/Grass/T=src.loc
				if(!istype(T,/turf/Terrain/Grass/) && !istype(T,/turf/Terrain/Grasslight/)) return
				T.overlays+=image('turfgrassD.dmi',T,"buried")
				T.Body=src
				src.loc=null */

			if("Inventory")
				if(usr.ContainerCheck) return
				usr.move=0
				usr.ContainerCheck=src
				winset(usr,"Container.ContainerName","text=\"[src.ContainerName]\"")
				winset(usr,"Container","is-visible=true")
				winset(usr,"Container.Grid","cells=0x0")
				var/Row = 1
				usr<<output("Capacity: [Capacity]/[MaxCapacity]","Container.Grid:1,1")
				for(var/obj/items/O in Contents)
					Row++
					usr << output(O,"Container.Grid:1,[Row]")
					spawn() while(winget(usr,"Container","is-visible")=="true") sleep(10)
					usr << output("Weight: [O.Weight]","Container.Grid:2,[Row]")
			if("Seal")
				if(x.SealDate || x.bodyholder) return
				usr._output(name, "seal", "outputall.output")
				usr._output(name, "seal", "outputic.output")
				x.bodyholder = src
				src.loc = x
				
mob/Genjutsu
obj/items/
	var/Description = "N/A"
	verb/View()
		set src in usr
		if(Description == "N/A")
			usr << "This is a [src.name]."
			return
		usr.showWeapon = src
		usr<<output(null,"Weapon.Description")
		usr<<output(null,"Weapon.Name")
		winshow(usr,"Weapon.Show",0)
		winset(usr,"Weapon","is-visible=true")
		var/icon/I = icon(icon,icon_state)
		var/newPicture = fcopy_rsc(I)
		winset(usr,"Weapon.Picture","image=\ref[newPicture]")
		winset(usr,"Weapon.Name","text=\"[name]\"")
		winshow(usr,"Weapon.Show",1)
		usr<<output("[Description]","Weapon.Description")
	proc/Descshow(mob/user)
		var/mob/controlMob = user
		if(controlMob.MindTransfer) controlMob=controlMob.MindTransfer
		display_desc(controlMob)

	proc/display_desc(mob/user)
		for(var/mob/M in hearers(16, user))
			if(M.MindTransfer) if(M == M.MindTransfer.MindAfflicted) continue
			if(M.MindAfflicted)
				M.MindAfflicted << output("<font size=-2><font color=[user.SayFont]>[M.MindAfflicted.getStrangerName(user)] shows: <a href=?src=\ref[user];action=Weapon;weapon=[md5(name)]>[name]</a>!</font>", "outputall.output")
			else
				M << output("<font size=-2><font color=[user.SayFont]>[M.getStrangerName(user)] shows: <a href=?src=\ref[user];action=Weapon;weapon=[md5(name)]>[name]</a>!</font>", "outputall.output")

mob
	var/tmp/obj/items/showWeapon
	verb/showWeapon()
		set hidden = 1
		if(!showWeapon) return
		if(!(showWeapon in src.contents))
			return
		winset(src,"Weapon","is-visible=false")

		showWeapon.Descshow(src)



/*

obj/items
	var/Description="This item does not have a description."
	verb/Examine()
		usr << "[Description]"


*/

obj/items/Weapon
	var
		last_edit = 0
	Rope
		icon='Icons/Rope.dmi'
		icon_state="Inv"
	Samehada
		icon='Samehada.dmi'
		icon_state="Inv"
		Weight=7
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.4
					usr.Agility *= 0.7
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Kiba
		icon='kibasscabbard.dmi'
		icon_state="Inv"
		var/Sheathe=1
		Weight=5
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
		verb/Sheathe()
			if(src in usr.contents)
				if(!worn) return
				if(Sheathe)
					usr.overlays+='Raiga.dmi'
					Sheathe=0
					usr.Taijutsu *= 1.9
					usr.Agility *=1.6
				else
					usr.overlays-='Raiga.dmi'
					Sheathe=1
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility

	Enma_Pole
		icon='Enma Pole.dmi'
		icon_state="Inv"
		Weight=6
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.5
					usr.Agility /= 1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility


	Kubiriki
		icon='Kubiriki.dmi'
		icon_state="Inv"
		Weight=7
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 2
					usr.Agility *= 0.4
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility

	Zanbatou
		icon='Zanbatou.dmi'
		icon_state="Inv"
		Weight=7

		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 7500

		Description = "This requires D+ strength to use in combat. Damage scales with strength + 2 steps, capping at A. This weapon uses the higher of strength and agility for striking speed. This reduces the user�s striking speed by four steps. Having the �Zanbatou Fighter� perk reduces this debuff to two steps. Two tile attack range. \[This requires 'Zanbatou Fighter' to apply the Combat Prof. perk boosts.]"

		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Strength *= 2.2
					usr.Agility *= 0.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Strength = usr.MaxStrength
					usr.Agility = usr.MaxAgility

	Gunbai
		icon='Gunbai.dmi'
		icon_state="Inv"
		Weight=7

		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 12500
		Description = " This requires D strength to use in combat. It deals blunt damage that starts at D and scales with the user�s strength, capping at A. When using this weapon, there is an agility debuff of two steps unless the perk �Zanbatou Fighter� is present, in which it is reduced to one step. The defense of this weapon is C. It can only be broken through with C damage or higher. This defense can be improved using chakra flow (refer to relevant Chakra Flow technique.) \[This requires 'Zanbatou Fighter' to apply the Combat Prof. perk boosts.]"

		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Strength *= 2.2
					usr.Agility *= 0.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Strength = usr.MaxStrength
					usr.Agility = usr.MaxAgility

	Naginata
		icon='naginata.dmi'
		icon_state="Inv"
		Weight=5

		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 7000

		Description = "This requires D strength to use in combat. Damage scales with strength + 1 step, capping at B. It reduces the user�s striking speed by two steps. Two tiles attack range if length is used fully.  Requires two hands to use at all times. \[This requires 'Halberd/Polearm Proficiency' to apply the Combat Prof. perk boosts.]"


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Strength *= 2.2
					usr.Agility *= 0.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Strength = usr.MaxStrength
					usr.Agility = usr.MaxAgility

	Dagger
		icon='Dirk.dmi'
		icon_state="Inv"
		Weight=1

		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 500
		Description = {"\[Meele] Damage scales with strength + 1 step, capping at C \[This requires 'Knife Fighter' to apply the Combat Prof. perk boosts.]
\[Thrown] Thrown weapon - \[Damage: Speed minus one step, caps at C] \[Speed: User�s strength, caps at B]
"}

		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Strength *= 2.2
					usr.Agility *= 0.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Strength = usr.MaxStrength
					usr.Agility = usr.MaxAgility

	Hiramekarei
		icon='Hiramekarei.dmi'
		icon_state="Inv"
		Weight=8
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.8
					usr.Strength *= 1.8
					usr.Agility *= 0.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Strength = usr.MaxStrength
					usr.Agility = usr.MaxAgility

	Kyodai_Sensu
		icon='Fan.dmi'
		icon_state="Inv"
		Weight=4
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 4750
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)
					src.worn = 1
					src.suffix = "Equipped"
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
	Torch
		icon='torch.dmi'
		icon_state="Inv"
		var/fuel=300
		Weight=1
		var
			obj/light/light
			matrix
				on_matrix = matrix()
				off_matrix = matrix()
		Move()
			..()
			del(light)
			if(istype(loc,/turf/))
				on_matrix = new()
				off_matrix = new()
				light = new(src.loc)
				on_matrix.Scale(8)
				off_matrix.Scale(0)
				animate(light,transform=on_matrix,time=5)
				sleep(6)
				// And flickering...
				animate(light,color=rgb(220,220,220),time=4,loop=-1)
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.3
					usr.Ninjutsu *= 1
					usr.Agility *= 1
					usr.light = new(usr.loc)
					usr.light.alpha = 150
					var/matrix/m = new()
					m.Scale(8)
					animate(usr.light,transform=m,time=5)
					sleep(6)
					// And flickering...
					animate(usr.light,color=rgb(220,220,220),time=4,loop=-1)
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Agility = usr.MaxAgility
					animate(usr.light,transform=off_matrix,time=5)
					sleep(6)
					del(usr.light)
	Raijin
		icon='Raijin.dmi'
		icon_state="Inv"
		Weight=4
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.3
					usr.Ninjutsu *= 2
					usr.Agility *= 1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Agility = usr.MaxAgility

	Umbrella
		icon='Umbrella.dmi'
		icon_state="Inv"
		Weight=3
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 6000
		Description = "This requires D strength to use in combat. Damage scales with strength + 1 step, capping at C. \[This requires 'Exotic Weapon Proficiency' to apply the Combat Prof. perk boosts.]"
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.6
					usr.Ninjutsu *= 1.2
					usr.Agility *= 1.2
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Agility = usr.MaxAgility

	Cross_Blade
		icon='Sword_Sheathed.dmi'
		icon_state="Inv"
		Weight=2
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.6
					usr.Agility *= 0.9
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility


	Memori_Tail
		icon='Tail of Memori.dmi'
		icon_state="Inv"
		Weight=1
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.4
					usr.Strength *= 1.6
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Strength = usr.MaxStrength
					usr.Agility = usr.MaxAgility

	Tan_Polearm
		icon='Suna no Geton Staff Blade.dmi'
		icon_state="Inv"
		Weight=1
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 0.8
					usr.Defence *= 0.7
					usr.Strength *= 1.6
					usr.Taijutsu *= 1.4
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility

	Spear
		icon='Spear.dmi'
		icon_state="Inv"
		Weight=6
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.2
					usr.Taijutsu *= 2
					usr.Defence *= 0.6
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility

	Shuusui
		icon='Shuusui Unsheathed.dmi'
		icon_state="Inv"
		Weight=4
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.8
					usr.Taijutsu *= 0.6
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility= usr.MaxAgility

	Samurai_Sword
		icon='Samurai Sword.dmi'
		icon_state="Inv"
		Weight=3
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 5000
		Description = "Damage scales with strength + 2 steps, capping at B. This reduces the user�s striking speed by one step. \[This requires 'Katana Prof.' to apply the Combat Prof. perk boosts.]"
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.4
					usr.Defence *= 1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility

	Water_Form
		icon='WaterArmorJutsu.dmi'
		icon_state="Inv"
		Weight=1
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.4
					usr.Defence *= 1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Agility = usr.Agility
					usr.Defence = usr.Defence

	Garian
		icon='Garian.dmi'
		icon_state="Inv"
		Weight=6
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 0.4
					usr.Strength *= 2.3
					usr.Ninjutsu *=1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Agility = usr.MaxAgility
					usr.Strength = usr.MaxStrength
					usr.Ninjutsu = usr.MaxNinjutsu

	Demon_Brother_Arm_1
		icon='Demon Bro Arm.dmi'
		icon_state="Inv"
		Weight=4
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 0.8
					usr.Defence *= 1.2
					usr.Strength *= 1.6
					usr.Taijutsu *= 0.8
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility

	Demon_Brother_Arm_2
		icon='Demon Bro Arm 2.dmi'
		icon_state="Inv"
		Weight=4
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 0.8
					usr.Defence *= 1.2
					usr.Strength *= 1.6
					usr.Taijutsu *= 0.8
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility

	Kura_Bow_Sword
		icon='Bow Sword right.dmi'
		icon_state="Inv"
		Weight=5
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.2
					usr.Defence *= 1.3
					usr.Strength *= 1.3
					usr.Taijutsu *= 0.5
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility

	Kura_Bow_Sword_2
		icon='Bow Sword left.dmi'
		icon_state="Inv"
		Weight=5
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.2
					usr.Defence *= 1.3
					usr.Strength *= 1.3
					usr.Taijutsu *= 0.5
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Agility = usr.MaxAgility




	Jet_Warglaive
		icon='Hand blade 2.dmi'
		icon_state="Inv"
		Weight=5
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.4
					usr.Defence *= 0.7
					usr.Offence *= 1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Defence = usr.MaxDefence
					usr.Offence = usr.MaxOffence
					usr.Agility = usr.MaxAgility

	Jet_Warglaive_2
		icon='Hand blade.dmi'
		icon_state="Inv"
		Weight=5
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.4
					usr.Defence *= 0.7
					usr.Offence *= 1.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Defence = usr.MaxDefence
					usr.Offence = usr.MaxOffence
					usr.Agility = usr.MaxAgility


	BlackStar_Chained_Scythes
		icon='Black Star Chained Scythe.dmi'
		icon_state="Inv"
		Weight=5
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 1.2
					usr.Defence *= 1.2
					usr.Offence *= 1.3
					usr.Taijutsu *= 0.5
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Defence = usr.MaxDefence
					usr.Offence = usr.MaxOffence
					usr.Agility = usr.MaxAgility

	Fishing_Rod
		icon='fisherpole.dmi'
		icon_state="inv"
		Weight=3
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
				else
					if(usr.Fishing)
						usr<<"You cannot unequip this while you're fishing!"
						return
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Offence = usr.MaxOffence
					usr.Agility = usr.MaxAgility
	Void_Blade
		icon='KuraSword.dmi'
		icon_state="Inv"
		Weight=4
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 0.6
					usr.Defence *= 0.7
					usr.Offence *= 1.3
					usr.Strength *= 2
					usr.Taijutsu *= 0.9
					usr.Ninjutsu *= 1.4
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Strength = usr.MaxStrength
					usr.Defence = usr.MaxDefence
					usr.Offence = usr.MaxOffence
					usr.Agility = usr.MaxAgility

	Ender_Blade
		icon='Ender Blade.dmi'
		icon_state="Inv"
		Weight=10
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Agility *= 0.4
					usr.Defence *= 0.7
					usr.Control *= 1.3
					usr.Strength *= 2
					usr.Taijutsu *= 0.6
					usr.Ninjutsu *= 1.9
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Agility = usr.MaxAgility
					usr.Defence = usr.MaxDefence
					usr.Control = usr.MaxControl
					usr.Strength = usr.MaxStrength

	Gord
		icon='Gord.dmi'
		icon_state="Inv"
		Weight=5
		Description = "This has a minus three tiles slow down. With the relevant Gourd Combatant perk, this slowdown is reduced to one tile."
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 6000
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 0.7
					usr.Agility /= 2
					usr.Ninjutsu *= 2.3
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Ninjutsu = usr.MaxNinjutsu
					usr.Agility = usr.MaxAgility
	Kunai
		icon='Kunai.dmi'
		icon_state="Inv"
		var/Kunai=1
		Weight=0.50
		Description = {"\[Meele] Damage is the user�s strength stat, capping at B \[This requires 'Knife Fighter' to apply Combat Prof. perk boosts.
\[Thrown] \[Damage: Speed, caps at C] \[Speed: User�s strength, caps at B]"}
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 15


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.15
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu

	Giant_Shuriken
		name="Back Shuriken"
		icon='Giant Shuriken.dmi'
		icon_state="Inv"
		var/GiantShuriken=1
		Weight=2.5
		Description = "\[Thrown] \[Damage: Speed one grade, caps at A] \[Speed: User�s strength minus two steps, caps at C]"

		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 1200


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
					usr.Taijutsu *= 1.89
					usr.Agility *= 0.8
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility

	Poison_Bomb
		icon='Poison.dmi'
		icon_state="Inv"
		var/Bomb=1
		Weight=0.5
		verb/Throw()
			world<<"[usr.key] tried using a poison bomb."


	Explosive_Tag
		icon='Explosive Tag.dmi'
		icon_state="Inv"
		var/Tag=1
		Weight=1
		Description = "Explosion is a two tile radius. C damage. For each aditional two tags, the damage goes up by one step to a maximum of B. Explosion speed is C rank."
		craftRank = "Lotus Sealing"
		craftChance = 60
		craftCost = 250
	Log
		icon='Log.dmi'
		icon_state="Inv"
	Katana
		icon='katana(sleath.dmi'
		icon_state="Inv"
		var/Sheathe=1
		Description = "Damage scales with strength + 1 steps, capping at B. This reduces the user�s striking speed by one step. \[This requires 'Katana Prof.' to apply the Combat Prof. perk boosts.]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 3000
		Weight=4
		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
		verb/Sheathe()
			if(src in usr.contents)
				if(!worn) return
				if(Sheathe)
					usr.overlays+='katana(atk).dmi'
					Sheathe=0
					usr.Taijutsu *= 1.9
					usr.Agility *=1.6
				else
					usr.overlays-='katana(atk).dmi'
					Sheathe=1
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Bokken
		name="Training Sword"
		icon='bokken.dmi'
		icon_state="Inv"
		Weight=2

		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 10

		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.Taijutsu *= 1.3
					usr.Agility *=1.25
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Tanto
		name="Wakizashi"
		icon='Tanto.dmi'
		icon_state="Inv"
		Weight=2
		Description = "Damage scales with strength, capping at B. \[This requires 'Knife Fighter.' to apply the Combat Prof. perk boosts.]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 500


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.Taijutsu *= 1.3
					usr.Agility *=1.25
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Longsword
		name="Longsword"
		icon='Longsword.dmi'
		icon_state="Inv"
		Weight=2
		Description = "This requires D strength to use in combat. Damage scales with strength + 2 steps, capping at B. This reduces the user�s striking speed by two steps. \[This requires 'Zanbatou Fighter.' to apply the Combat Prof. perk boosts.]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 6000


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.Taijutsu *= 1.3
					usr.Agility *=1.25
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Rapier
		name="Rapier"
		icon='Rapier.dmi'
		icon_state="Inv"
		Weight=2
		Description = "Damage scales with strength + 1 step, capping at C. \[This requires 'Katana Prof.' to apply the Combat Prof. perk boosts.]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 3750


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.Taijutsu *= 1.3
					usr.Agility *=1.25
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Bostaff
		name="Bo-staff"
		icon='bostaff.dmi'
		icon_state="Inv"
		Weight=2
		Description = "Damage scales with strength + 1 step, capping at C. It reduces the user�s striking speed by one step. Two tiles attack range if length is used fully. \[This requires 'Polearm prof.' to apply the Combat Prof. perk boosts.]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 3500


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.Taijutsu *= 1.3
					usr.Agility *=1.25
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Claymore
		name="Claymore"
		icon='7bustersword.dmi'
		icon_state="Inv"
		Weight=2
		Description = "This requires D+ strength to use in combat. Damage scales with strength + 3 steps, capping at A.This weapon uses strength for striking speed. This reduces the user�s striking speed by five steps. Having the �Zanbatou Fighter� perk reduces this debuff to two steps. Two tile attack range. \[This requires 'Zanbatou Fighter' to apply the Combat Prof. perk boosts.]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 10000


		Click()
			..()
			if(src in usr.contents)
				if(!src.worn)

					src.worn = 1
					src.suffix = "Equipped"

					usr.Taijutsu *= 1.3
					usr.Agility *=1.25
					usr.overlays += src.icon
				else
					src.worn = 0
					src.suffix=""
					
					usr.overlays -= src.icon
					usr.Taijutsu = usr.MaxTaijutsu
					usr.Agility = usr.MaxAgility
	Shuriken
		icon='Shuriken.dmi'
		icon_state="Inv"
		var/shuriken=1
		Weight=0.25
		Description = "\[Thrown] \[Damage: Speed minus one grade, caps at C] \[Speed: User�s Strength, caps at B]"
		craftRank = "Weapon-Smith"
		craftChance = 100
		craftCost = 10
	Windmill
		icon='Windmill.dmi'
		icon_state="Inv"
		var/Windmill=1
		Weight=2.5
		Description = "\[Thrown] \[Damage: Speed two steps, caps at B] \[Speed: User�s strength minus one step, caps at C]"
		craftRank = "Weapon-Smith"
		craftChance = 60
		craftCost = 500
	Senbon
		icon='Senbon.dmi'
		icon_state="Inv"
		var/senbon=1
		Weight=0.25
		Description = "\[Thrown] \[Damage: Speed minus four steps, caps at C] \[Speed: User�s strength, caps at B]"
		craftRank = "Weapon-Smith"
		craftChance = 100
		craftCost = 5